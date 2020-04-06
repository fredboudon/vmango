#################################################################################
#############     FRUIT MODEL : FRUIT GROWTH IN DRY MASS    #####################
#################################################################################

# Original model from : Léchaudel et al. 2005_Tree Physiology 25:583-597
# See also : Lescourret et al 1998_European J. of Agronomy 9:173-188

# - erratum eq.1 : it's not "D_fruit" but "D_fruit/LA"
# - erratum Table 1 : parameter units for p1, p2, p3 and p4 are 
#                     p1 [µmol CO2 day s-1 g-1 C]
#                     p2 [µmol CO2 m-2 s-1]
#                     p3 [µmol CO2 m-2 s-1]
#                     p4 [µmol CO2 µmol-1 photon]


# Differences between the current R code and the original model :
#--------------------------------------------------------------------------------
# - calculation of degree-days : based on daily mean temperature and lower temperature thresholds (vs. daily max. and min. temperatures and lower and upper temperature thresholds in the original model)
# - MODIF 2015-04_1 : a condition on P_shaded (P_sunlit) was added to select values > 0 because P_shaded (P_sunlit) can be ≤ 0 when PAR is very low
# - MODIF 2017-05_1 : a minimal threshold was added for Pmax to avoid that P_shaded (P_sunlit) ≤ 0 for branches without fruits (i.e. with D_fruit = 0) 


growth_DM <- function( GR,
                       T_air,
                       T_fruit, 
                       sunlit_bs,
                       DM_fruit_0,
                       DM_fruit_previous,
                       reserve_stem,
                       reserve_leaf,
                       LF
)
  
{
  
  ## GR conversion form J/cm2/h to W/m2 :
  GR <- GR / 3600 * 10000                    
  
  ## -- photosynthetic active radiation (eq.10-19) :
  PAR <- GR * k1 * k2
  PAR_shaded <- k3 * PAR
  
  ## -- leaf area (eq. 11) :
  LA <- a3 * LF ^ a4

  ## -- dry mass of stem and leaf structure :
  DM_structure_stem <- DM_stem * (1 - r_DM_stem_ini)
  DM_structure_leaf <- DM_leaf_unit * LF * (1 - r_DM_leaf_ini)

  
  # =============================================================================
  # CARBON ASSIMILATION BY LEAVES
  # =============================================================================
  
  ## -- carbon demand for fruit growth (eq.5-6-7) :
  DM_fruit_max <- a1 * DM_fruit_0 ^ a2
  dd_delta <- sum((T_fruit - Tbase)/24)
  D_fruit <- dd_delta  * (cc_fruit + GRC_fruit) *
    RGR_fruit_ini * DM_fruit_previous * (1 - (DM_fruit_previous / DM_fruit_max))

  ## -- light-saturated leaf photosynthesis (eq.1) :
  Pmax <- (p1 * (D_fruit / LA) * p2) / (p1 * (D_fruit / LA) + p2)
  if (Pmax >= Pmax_MAX) { Pmax = Pmax_MAX }
  #if (Pmax < Pmax_MIN)  { Pmax <- Pmax_MIN }                                     # _MODIF 2017-05_1 : TO BE ACTIVATED ???
  
  ## -- photosynthetic rate per unit leaf area (eq.2) :
  P_sunlit <- ((Pmax + p3) * (1 - exp(-p4 * PAR[PAR>0] / (Pmax + p3)))) - p3
  P_shaded <- ((Pmax + p3) * (1 - exp(-p4 * PAR_shaded[PAR_shaded>0] / (Pmax + p3)))) - p3
  
  ## -- carbon assimilation by leaf photosynthesis (eq.3) :
  LA_sunlit <- sunlit_bs[PAR>0] * sunlit_ws[PAR>0] * LA
  LA_shaded <- LA - LA_sunlit
  photo_shaded <- sum(P_shaded[P_shaded>0] * LA_shaded[P_shaded>0]) * k           # _MODIF 2015-04_1
  photo_sunlit <- sum(P_sunlit[P_sunlit>0] * LA_sunlit[P_sunlit>0]) * k           # _MODIF 2015-04_1 
  photo <- photo_shaded + photo_sunlit
  
  
  # =============================================================================
  # CARBON AVAILABLE FROM RESERVE MOBILIZATION
  # =============================================================================
  
  ## -- mobile amount of reserves (eq.8-9) :
  reserve_m <- (r_mobile_leaf * reserve_leaf) + (r_mobile_stem * reserve_stem) 
  
  ## -- non-mobile amount of reserves :
  reserve_nm_leaf <- reserve_leaf * (1 - r_mobile_leaf)
  reserve_nm_stem <- reserve_stem *  (1- r_mobile_stem)
  
  
  # =============================================================================
  # MAINTENANCE RESPIRATION (eq.4)
  # =============================================================================
  
  ## -- hourly maintenance respiration for the stem, leaves and fruits :
  ##    (warning : calculated with daily mean air temperature T_air (T_fruit) which is 24 times the same value)
  MR_stem <- MRR_stem/24 * (Q10_stem ^ ((T_air - Tref)/10)) * (DM_structure_stem + reserve_stem / cc_stem)
  MR_leaf <- MRR_leaf * (Q10_leaf ^ ((T_air - Tref)/10)) * (DM_structure_leaf + reserve_leaf / cc_leaf)
  MR_fruit <- MRR_fruit/24 * (Q10_fruit ^ ((T_fruit - Tref)/10)) * DM_fruit_previous
  
  ## -- daily maintenance respiration for the stem, leaves (only during dark hours) and fruits :
  MR_stem <- sum(MR_stem)
  MR_leaf <- sum(MR_leaf[PAR == 0])
  MR_fruit <- sum(MR_fruit)
  
  ## -- daily maintenance respiration for reproductive and vegetative components :
  MR_repro <- MR_fruit
  MR_veget <- MR_stem + MR_leaf
  
  
  # =============================================================================
  # CARBON ALLOCATION
  # =============================================================================
  ## Allocation of carbon according to organ demand and priority rules :
  ##    1- maintenance of the system
  ##    2- reproductive growth
  ##    3- accumulation and replenishment of reserves in leaves and then in stem
  
  ## -- pool of assimilates :
  assimilates <- photo + reserve_m
  
  # -----------------------------------------------------------------------------
  # 1- assimilates are used for maintenance respiration
  # -----------------------------------------------------------------------------
  ## Priority rules for maintenance respiration :
  ##    1- vegetative components
  ##    2- reproductive components
  
  ## -- use of assimilates for maintenance respiration of vegetative components :
  if (assimilates >= MR_veget)   {
    remains_1 <- assimilates - MR_veget
  }
  else {
    ## mobilization of non-mobile reserves if maintenance respiration is not satified by assimilates :
    ##      1- mobilization of non-mobile reserves from leaves
    ##      2- mobilization of non-mobile reserves from stem
    if (assimilates + reserve_nm_leaf >= MR_veget) {
      remains_1 <- 0
      reserve_nm_leaf <- assimilates + reserve_nm_leaf - MR_veget
    }
    else {
      if (assimilates + reserve_nm_leaf + reserve_nm_stem >= MR_veget) {
        remains_1 <- 0
        reserve_nm_stem <- assimilates + reserve_nm_leaf + reserve_nm_stem - MR_veget
        reserve_nm_leaf <- 0
      }
      else {
        ## death of vegetative components if maintenance respiration is not satisfied by assimilates and non-mobile reserves :
        remains_1 <- 0
        error = c("Vegetative part of the system dies ...")
        if (exists('idsimu')) {
          write.csv(data.frame(error), paste(localdir,"/tmp/failed-",idsimu,".csv",sep=''))
        } else {
          write.csv(data.frame(error), paste(localdir,"/tmp/r.csv",sep=''), row.names=FALSE)
        }
        stop("Vegetative part of the system dies ...\n")
        return (NULL)
      }
    }
  }
  
  ## -- use of remaining assimilates for maintenance respiration of reproductive components :
  if ( remains_1 < MR_repro ) {
    ## mobilization of fruit reserves if maintenance respiration is not satified by remaining assimilates :
    required_DM_fruit <- (MR_repro - remains_1) / cc_fruit
    if (required_DM_fruit < DM_fruit_previous) {
      DM_fruit_previous <- DM_fruit_previous - required_DM_fruit
    }
    else {
      ## death of reproductive components if maintenance respiration is not satisfied by remaining assimilates and fruit reserves :
      error <- c("Reproductive part of the system dies ...")
      if (exists('idsimu')) {
        write.csv(data.frame(error), paste(localdir,"/tmp/failed-",idsimu,".csv",sep=''))
      } else {
        write.csv(data.frame(error), paste(localdir,"/tmp/r.csv",sep=''), row.names=FALSE)
      }
      stop("Reproductive part of the system dies ...\n")
    }
  }
  remains_2 <- max(0, remains_1 - MR_repro)
  
  # -----------------------------------------------------------------------------
  # 2- remaining assimilates are used for fruit growth
  # -----------------------------------------------------------------------------
  
  DM_fruit <- DM_fruit_previous + (min(D_fruit, remains_2) / (cc_fruit + GRC_fruit))
  remains_3 <- remains_2 - min(D_fruit, remains_2)
  
  # -----------------------------------------------------------------------------
  # 3- remaining assimilates are accumulated as reserves in leaves and stem
  # -----------------------------------------------------------------------------
  ## Priority rules for reserve storage : 
  ##    1- replenishment of mobile reserves of the stem
  ##    2- storage of all remaining assimilates in leaf reserves up to a maximum threshold
  ##    3- storage of all remaining assimilates in stem reserves
  
  reserve_stem_provi <- reserve_nm_stem + min(remains_3, reserve_stem * r_mobile_stem)
  reserve_leaf_provi <- reserve_nm_leaf + max(0, remains_3 - reserve_stem * r_mobile_stem)
  
  reserve_MAX <- (r_storage/(1 - r_storage)) * DM_structure_leaf * cc_leaf
  
  if (reserve_leaf_provi > reserve_MAX){
    reserve_leaf <- reserve_MAX
    reserve_stem  <- reserve_stem_provi + (reserve_leaf_provi - reserve_MAX) 
  }
  else {
    reserve_leaf <- reserve_leaf_provi
    reserve_stem <- reserve_stem_provi
  }

    
  # =============================================================================
  # OUTPUTS
  # =============================================================================
  Results <- list( DM_fruit = DM_fruit,
                   reserve_leaf = reserve_leaf,
                   reserve_stem = reserve_stem )
  
  return(Results)
}
