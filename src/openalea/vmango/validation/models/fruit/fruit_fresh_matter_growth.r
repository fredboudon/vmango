#########################################################################################################################
###  FRUIT MODEL : FRUIT GROWTH IN FRESH MASS    ########################################################################
#########################################################################################################################

# Original model from : Léchaudel et al. 2007_Tree Physiology 27:219-230
# See also : Fishman and Génard 1998_Plant Cell Environ. 21:739-752
#            Léchaudel 2004_PhD

# - erratum parameter units : alpha [g cm-3] and tau [dimensionless] 
# - flesh compartment : comprise flesh and peel

# Differences between the current R code and the original model :
# ------------------------------------------------------------------------------------------------------------------------
# - the model run at a daily time step (vs. hourly time step in the original model)
#   parameter units in Table A2 are updated : ro [cm day-1], aLf [g cm-2 MPa-1 day-1] and phi_max [MPa-1 day-1]
# - fruit growth is based only on plactic component (vs. plastic and elastic components in the original model)
#   Eq.12 becomes : dV/dt = dV_plas/dt
#   Eq.13 becomes : dV/dt = phi*V*(P_f - Y) if P_f > Y 
#                   dV/dt = 0               if P_f ≤ Y
# - Eq.6-7 : contribution of amino acids to osmotic pressure (R*T*n_aa/w) is fixed at a constant (osmotic_pressure_aa)
# - MODIF 2017-05_1 : if not fixed as input (cf year-dependent calibrated value in the original model), 
#                     dd_thresh value is empirically calculated from fruit dry mass at the end of cell division   


growth_FM <- function( date,
                       T_air,
                       GR,
                       RH,
                       dd_cum,
                       TM_air,
                       DM_fruit_0,
                       DM_fruit,
                       DM_fruit_previous,
                       FM_fruit_previous,
                       W_fleshpeel_previous,
                       dd_thresh
)
  
{
  
  ## -- physical constants -------------------------------------------------------------------------------------------------

  R <- 8.3                             # gaz constant [cm3 MPa mol-1 K-1]
  d_W <- 1                             # water density [g cm-3]
  MM_water <- 18                       # molecular mass of water [g mol-1]
  MM_mal <- 134                        # molecular mass of malic acid [g mol-1]
  MM_cit <- 192                        # molecular mass of citric acid [g mol-1]
  MM_pyr <- 88                         # molecular mass of pyruvic acid [g mol-1]
  MM_oxa <- 90                         # molecular mass of oxalic acid [g mol-1]
  MM_K <- 39                           # molecular mass of K+ [g mol-1]
  MM_Mg <- 24                          # molecular mass of Mg2+ [g mol-1]
  MM_Ca <- 40                          # molecular mass of Ca2+ [g mol-1]
  MM_NH4 <- 18                         # molecular mass of NH4+ [g mol-1]
  MM_Na <- 23                          # molecular mass of Na+ [g mol-1]
  MM_glc <- 180                        # molecular mass of glucose [g mol-1]
  MM_frc <- 180                        # molecular mass of fructose [g mol-1]
  MM_suc <- 342                        # molecular mass of sucrose [g mol-1]
  
  
  # ========================================================================================================================
  # DRY MASS AND GROWTH RATE OF FRUIT FLESH
  # ========================================================================================================================
  ## from empirical relationships in Léchaudel (2004)
  
  DM_fleshpeel_previous <- (a7 * (DM_fruit_previous) ^ a8) + (a5 * (DM_fruit_previous) ^ a6)
  DM_fleshpeel_growth <- (a7 * a8 * (DM_fruit) ^ (a8 - 1) + a5 * a6 * (DM_fruit) ^ (a6 - 1)) * (DM_fruit - DM_fruit_previous)
  DM_fleshpeel_growth <- max(DM_fleshpeel_growth, 0)
  DM_flesh_previous <- a9 * DM_fleshpeel_previous
  W_flesh_previous <- a10 * W_fleshpeel_previous
  
  
  # ========================================================================================================================
  # OSMOTIC PRESSURE IN THE FRUIT
  # ========================================================================================================================
  
  ## -- mass proportion of osmotically active solutes & starch in the dry mass of fruit flesh (eq.9) :
  prop_mal <- delta_mal[1] + delta_mal[2] * dd_cum + delta_mal[3] * DM_flesh_previous + delta_mal[4] * DM_flesh_previous * dd_cum
  prop_cit <- delta_cit[1] + delta_cit[2] * dd_cum + delta_cit[3] * DM_flesh_previous + delta_cit[4] * DM_flesh_previous * dd_cum
  prop_pyr <- delta_pyr[1] + delta_pyr[2] * dd_cum + delta_pyr[3] * DM_flesh_previous + delta_pyr[4] * DM_flesh_previous * dd_cum
  prop_oxa <- delta_oxa[1] + delta_oxa[2] * dd_cum + delta_oxa[3] * DM_flesh_previous + delta_oxa[4] * DM_flesh_previous * dd_cum
  prop_K   <- delta_K[1]   + delta_K[2]   * dd_cum + delta_K[3]   * DM_flesh_previous + delta_K[4]   * DM_flesh_previous * dd_cum
  prop_Mg  <- delta_Mg[1]  + delta_Mg[2]  * dd_cum + delta_Mg[3]  * DM_flesh_previous + delta_Mg[4]  * DM_flesh_previous * dd_cum
  prop_Ca  <- delta_Ca[1]  + delta_Ca[2]  * dd_cum + delta_Ca[3]  * DM_flesh_previous + delta_Ca[4]  * DM_flesh_previous * dd_cum
  prop_NH4 <- delta_NH4[1] + delta_NH4[2] * dd_cum + delta_NH4[3] * DM_flesh_previous + delta_NH4[4] * DM_flesh_previous * dd_cum
  prop_Na  <- delta_Na[1]  + delta_Na[2]  * dd_cum + delta_Na[3]  * DM_flesh_previous + delta_Na[4]  * DM_flesh_previous * dd_cum
  prop_glc <- delta_glc[1] + delta_glc[2] * dd_cum + delta_glc[3] * DM_flesh_previous + delta_glc[4] * DM_flesh_previous * dd_cum
  prop_frc <- delta_frc[1] + delta_frc[2] * dd_cum + delta_frc[3] * DM_flesh_previous + delta_frc[4] * DM_flesh_previous * dd_cum
  prop_suc <- delta_suc[1] + delta_suc[2] * dd_cum + delta_suc[3] * DM_flesh_previous + delta_suc[4] * DM_flesh_previous * dd_cum
  prop_sta <- delta_sta[1] + delta_sta[2] * dd_cum + delta_sta[3] * DM_flesh_previous + delta_sta[4] * DM_flesh_previous * dd_cum
  if (prop_mal < 0) { prop_mal <- 0 }
  if (prop_cit < 0) { prop_cit <- 0 }
  if (prop_pyr < 0) { prop_pyr <- 0 }
  if (prop_oxa < 0) { prop_oxa <- 0 }
  if (prop_K < 0)   { prop_K <- 0 }
  if (prop_Mg < 0)  { prop_Mg <- 0 }
  if (prop_Ca < 0)  { prop_Ca <- 0 }
  if (prop_NH4 < 0) { prop_NH4 <- 0 }
  if (prop_Na < 0)  { prop_Na <- 0 }
  if (prop_glc < 0) { prop_glc <- 0 }
  if (prop_frc < 0) { prop_frc <- 0 }
  if (prop_suc < 0) { prop_suc <- 0 }
  if (prop_sta < 0) { prop_sta <- 0 }
  
  ## -- mass and number of moles of osmotically active solutes & starch in fruit flesh (eq.8) :
  m_mal <- prop_mal * DM_flesh_previous ;      n_mal <- m_mal / MM_mal
  m_cit <- prop_cit * DM_flesh_previous ;      n_cit <- m_cit / MM_cit
  m_pyr <- prop_pyr * DM_flesh_previous ;      n_pyr <- m_pyr / MM_pyr
  m_oxa <- prop_oxa * DM_flesh_previous ;      n_oxa <- m_oxa / MM_oxa
  m_K   <- prop_K   * DM_flesh_previous ;      n_K   <- m_K   / MM_K
  m_Mg  <- prop_Mg  * DM_flesh_previous ;      n_Mg  <- m_Mg  / MM_Mg
  m_Ca  <- prop_Ca  * DM_flesh_previous ;      n_Ca  <- m_Ca  / MM_Ca
  m_NH4 <- prop_NH4 * DM_flesh_previous ;      n_NH4 <- m_NH4 / MM_NH4
  m_Na  <- prop_Na  * DM_flesh_previous ;       n_Na <- m_Na  / MM_Na
  m_glc <- prop_glc * DM_flesh_previous ;      n_glc <- m_glc / MM_glc
  m_frc <- prop_frc * DM_flesh_previous ;      n_frc <- m_frc / MM_frc
  m_suc <- prop_suc * DM_flesh_previous ;      n_suc <- m_suc / MM_suc
  m_sta <- prop_sta * DM_flesh_previous
  
  ## -- osmotic pressure in fruit flesh (eq.6-7) :
  n_solutes <- n_mal + n_cit + n_pyr + n_oxa + n_K + n_Mg + n_Ca + n_NH4 + n_Na + n_glc + n_frc + n_suc
  osmotic_pressure <- (R * (TM_air + 273.15) * n_solutes) / (W_flesh_previous / d_W) + osmotic_pressure_aa


  # ========================================================================================================================
  # FRUIT TRANSPIRATION
  # ========================================================================================================================
  
  ## -- fruit surface (eq.3) :
  A_fruit <- a11 * FM_fruit_previous ^ a12
  
  ## -- saturation vapor pressure (eq.3 in Fishman and Génard 1998) :
  ##    converted from bar to MPa
  P_sat <- s1 * exp(s2 * TM_air) / 10
  
  ## -- fruit transpiration (eq.2) :
  alpha <- MM_water * P_sat / (R * (TM_air + 273.15))
  transpiration <- A_fruit * alpha * ro * (RH_fruit - mean(RH)/100)
  
  
  # ========================================================================================================================
  # CELL WALL PROPERTIES OF THE FRUIT
  # ========================================================================================================================
  
  ## -- cell wall extensibility (eq.18) :
  if (is.nan(dd_thresh)) {                                                                                                       # _MODIF 2017-05_1
    ## if not fixed as input, set from an empirical relationship 
    dd_thresh <- a18 * DM_fruit_0 + a19  
  }

  if (dd_cum > dd_thresh) { 
    Phi <- phi_max * tau ^ (dd_cum - dd_thresh) 
  } 
  else { 
    Phi <- phi_max
  }
  
  # -- threshold pressure (eq.15-16) :
  V <- W_fleshpeel_previous / d_W + DM_fleshpeel_previous / d_DM
  Y <- Y_0 + h * (V - V_0)
  
  
  # ========================================================================================================================
  # TURGOR PRESSURE & WATER POTENTIAL IN THE FRUIT
  # ========================================================================================================================
  
  ## -- water potential of the stem :
  water_potential_stem <- a14 + a15 * TM_air + a16 * mean(RH) + a17 * mean(GR)

  ## -- turgor pressure in the fruit (defined by combining eq.11 and eq.13) :
  ALf <- A_fruit * aLf
  numerator <- Phi * V * Y  +  ALf * (water_potential_stem + osmotic_pressure) / d_W - transpiration / d_W + DM_fleshpeel_growth / d_DM
  denominator <- Phi * V + ALf / d_W
  turgor_pressure <- numerator / denominator
  if (turgor_pressure < Y) {
    turgor_pressure <- water_potential_stem + osmotic_pressure - (transpiration - DM_fleshpeel_growth * d_W / d_DM) / ALf
  }
  turgor_pressure <- max(turgor_pressure, Y_0)
  
  ## -- water potential in the fruit (eq.5) :
  water_potential <- turgor_pressure - osmotic_pressure
  
  
  # ========================================================================================================================
  # WATER AND DRY MATTER CHANGES IN FRUIT COMPARTMENTS
  # ========================================================================================================================
  
  ## -- rate of water inflow in the fruit from xylem and phloem (eq.4) :
  flux_xylem_phloem <- ALf * (water_potential_stem - water_potential)

  ## -- changes in dry mass, fresh mass and water mass of fruit compartments :
  DM_fleshpeel <- DM_fleshpeel_previous + DM_fleshpeel_growth 
  W_fleshpeel <- W_fleshpeel_previous + flux_xylem_phloem - transpiration
  FM_stone <- a13 * (DM_fleshpeel + W_fleshpeel)
  FM_fruit <- (DM_fleshpeel + W_fleshpeel) + FM_stone
  DM_flesh <- DM_fleshpeel * a9
  W_flesh <- W_fleshpeel * a10
  
  
  # ========================================================================================================================
  # OUTPUTS
  # ========================================================================================================================
  
  Results_day <- data.frame( water_potential = water_potential,
                             turgor_pressure = turgor_pressure,
                             osmotic_pressure =  osmotic_pressure,
                             flux_xylem_phloem = flux_xylem_phloem,
                             transpiration = transpiration,
                             sucrose = m_suc / (W_flesh_previous + DM_flesh_previous),
                             glucose = m_glc / (W_flesh_previous + DM_flesh_previous),
                             fructose = m_frc / (W_flesh_previous + DM_flesh_previous),
                             soluble_sugars = (m_suc + m_glc + m_frc) / (W_flesh_previous + DM_flesh_previous),
                             starch = m_sta /(W_flesh_previous + DM_flesh_previous),
                             organic_acids = (m_mal + m_cit) / (W_flesh_previous + DM_flesh_previous)
  )
  
  Results_day_next <- data.frame( date = date + 1,
                                  FM_fruit = FM_fruit,
                                  DM_Fruit = DM_fruit,
                                  W_fleshpeel = W_fleshpeel,
                                  DM_fleshpeel = DM_fleshpeel,
                                  W_flesh = W_flesh,
                                  DM_flesh = DM_flesh
  )
  
  Results <- list( Results_day = Results_day,
                   Results_day_next = Results_day_next)
  
  return(Results)
  
}

