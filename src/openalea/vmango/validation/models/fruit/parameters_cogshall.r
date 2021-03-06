## FRUIT MODEL PARAMETERS - cultivar Cogshall

## [main]
fruitDM0_weight_1 = 0.97        # specific parameter for fruit dry mass distribution at the end of cell division [dimensionless]
fruitDM0_mu_1 = 13.9	          # specific parameter for fruit dry mass distribution at the end of cell division [g DM]
fruitDM0_sigma_1 = 4.1          # specific parameter for fruit dry mass distribution at the end of cell division [g DM]
fruitDM0_weight_2 = 0.03        # specific parameter for fruit dry mass distribution at the end of cell division [dimensionless]
fruitDM0_mu_2 = 29.2            # specific parameter for fruit dry mass distribution at the end of cell division [g DM]
fruitDM0_sigma_2 = 0.66         # specific parameter for fruit dry mass distribution at the end of cell division [g DM]

## [growth]
sucrose_ripe_thresh = 0.04      # threshold sucrose content in the flesh beyond which fruit is assumed ripe [g g-1 FM]
stop_sim_ddcum = NaN
dd_cum_0 = 352.72               # cumulated degree-days at the end of cell division [dd]
e_fruitDM2FM_1 = 23.647         # specific parameter for fruit fresh mass calculation based on fruit dry mass (for fruits with L < 105 mm) [g1-0,6182 DM]
e_fruitDM2FM_2 = 0.6182         # specific parameter for fruit fresh mass calculation based on fruit dry mass (for fruits with L < 105 mm) [dimensionless]
e_fruit2peelW_1 = 0.4086	      # specific parameter for fruit peel water mass calculation based on fruit water mass [g1-0,7428 H20]
e_fruit2peelW_2 = 0.7428	      # specific parameter for fruit peel water mass calculation based on fruit water mass [dimensionless]
e_fruit2fleshW_1 = 0.5874	      # specific parameter for fruit flesh water mass calculation based on fruit water mass [g1-1,0584 H2O]
e_fruit2fleshW_2 = 1.0584	      # specific parameter for fruit flesh water mass calculation based on fruit water mass [dimensionless]

## [dry_matter]
Tbase_fruit = 16                # base temperature for degree-days calculation [°C]
k = 0.0432                      # conversion factor of leaf photosynthesis (from µmol CO2 s-1 to g C h-1) [g C s h-1 µmol-1 CO2]
k_1 = 0.5                       # fraction of global radiation photosynthetically active [dimensionless]
k_2 = 4.6                       # conversion factor of global radiation (from W m-2 to µmol photon m-2 s-1) [µmol photon W-1 s-1]
k_3 = 0.0529                    # fraction of radiation received by shaded leaves [dimensionless]
Pmax_max = 15                   # maximal threshold of light-saturated leaf photosynthesis [µmol CO2 m-2 s-1]
Pmax_min = 5                    # minimal threshold of light-saturated leaf photosynthesis [µmol CO2 m-2 s-1]
p_1 = 3.85                      # specific parameter for leaf photosynthesis calculation [µmol CO2 day s-1 g-1 C]
p_2 = 33.23                     # specific parameter for leaf photosynthesis calculation [µmol CO2 m-2 s-1]
p_3 = 0.483                     # specific parameter for leaf photosynthesis calculation [µmol CO2 m-2 s-1]
p_4 = 0.034                     # specific parameter for leaf photosynthesis calculation [µmol CO2 µmol-1 photon]
MRR_stem = 0.000858             # maintenance respiration rate of stem at the reference temperature Tref = 20°C [g C g-1 DM day-1]
MRR_leaf = 0.000156             # maintenance respiration rate of leaf at the reference temperature Tref = 20°C [g C g-1 DM h-1]
MRR_fruit = 0.00115             # maintenance respiration rate of fruit at the reference temperature Tref = 20°C [g C g-1 DM day-1]
Q10_stem = 1.96                 # Q10 value for stem [dimensionless]
Q10_leaf = 2.11                 # Q10 value for leaf [dimensionless]
Q10_fruit = 1.9                 # Q10 value for fruit [dimensionless]
Tref = 20                       # reference temperature for maintenance respiration calculation based on Q10 concept [°C]
cc_stem = 0.4387                # carbon content of stem dry matter [g C g-1 DM]
cc_leaf = 0.4051                # carbon content of leaf dry matter [g C g-1 DM]
cc_fruit = 0.4239               # carbon content of fruit dry matter [g C g-1 DM]
GRC_fruit = 0.04                # growth respiration coefficient of fruit [g C g-1 DM]
RGR_fruit_ini = 0.0105          # initial relative growth rate of fruit [dd-1]
r_mobile_stem = 0.0164          # mobile fraction of reserves in stem [dimensionless]
r_mobile_leaf = 0.0162          # mobile fraction of reserves in leaf [dimensionless]
r_DM_stem_ini = 0.1             # initial reserve fraction of dry matter in stem [dimensionless]
r_DM_leaf_ini = 0.074           # initial reserve fraction of dry matter in leaf [dimensionless]
r_storage_leaf_max = 0.3        # maximum reserve fraction of dry matter in leaf [dimensionless]
e_fruitDM02max_1 = 16.736       # specific parameter for maximum fruit dry mass calculation based on fruit dry mass at the end of cell division [g1-0.624 DM]
e_fruitDM02max_2 = 0.624        # specific parameter for maximum fruit dry mass calculation based on fruit dry mass at the end of cell division [dimensionless]
e_nleaf2LA_1 = 0.0051           # specific parameter for leaf area calculation based on leaf number [m2]
e_nleaf2LA_2 = 0.937            # specific parameter for leaf area calculation based on leaf number [dimensionless]
DM_stem = 59.62                 # stem dry mass [g DM]
DM_leaf_unit = 0.8              # leaf dry mass of a single leaf [g DM]
sunlit_ws = rep(0.88,24)        # hourly whithin-shoots sunlit fractions of leaves (i.e not shaded by surrounding shoots) [dimensionless]]

## [fresh_matter]
h = 0.002027                    # coeffcient of "cell wall hardening" [MPa cm-3]
phi_max = 0.414                 # maximal cell wall extensibility [MPa-1 day-1]
tau = 0.966                     # rate of decrease in cell wall extensibility [dimensionless]
aLf = 0.3732                    # product of the ratio of the area of the vascular network to the fruit area (a) by the hydraulic conductivity between the stem and the fruit for water transport (Lf)  [g H2O cm-2 MPa-1 day-1]
osmotic_pressure_aa = 0.2       # osmotic pressure in fruit flesh due to amino acids [MPa]
ro = 5544                       # fruit surface conductance [cm day-1]
RH_fruit = 0.996                # relative humidity of air space in fruit [dimensionless]
Y_0 = 0                         # threshold pressure at full bloom beyond which growth could occur [MPa]
V_0 = 0                         # fruit flesh volume at full bloom [cm3]
psat_1 = 0.008048               # specific parameter for saturation vapor pressure calculation based on air temperature [bar]
psat_2 = 0.0547                 # specific parameter for saturation vapor pressure calculation based on air temperature [°C-1]
density_DM = 1.6                # density of dry matter [g cm-3]
e_fruit2peelDM_1 = 0.4086       # specific parameter for fruit peel dry mass calculation based on fruit dry mass [g1-0.7641 DM]
e_fruit2peelDM_2 = 0.7641       # specific parameter for fruit peel dry mass calculation based on fruit dry mass [dimensionless]
e_fruit2fleshDM_1 = 0.5219      # specific parameter for fruit flesh dry mass calculation based on fruit dry mass [g1-1.0584 DM]
e_fruit2fleshDM_2 = 1.0584      # specific parameter for fruit flesh dry mass calculation based on fruit dry mass [dimensionless]
e_fleshpeel2fleshDM = 0.8226    # proportion of flesh in fruit flesh and peel dry mass [dimensionless]
e_fleshpeel2fleshW = 0.8958     # proportion of flesh in fruit flesh and peel water mass [dimensionless]
e_fruitFM2surface_1 = 3.65      # specific parameter for fruit surface calculation based on fruit fresh mass [cm2 g-0.73 FM]
e_fruitFM2surface_2 = 0.73      # specific parameter for fruit surface calculation based on fruit fresh mass [dimensionless]
e_flesh2stoneFM = 0.1167        # ratio of fruit stone fresh mass to fruit flesh and peel fresh mass [dimensionless]
swp_1 = -0.6617105              # specific parameter for stem water potential calculation based on air temperature, air relative humidity and global radiation [MPa]
swp_2 = -0.006940179            # specific parameter for stem water potential calculation based on air temperature, air relative humidity and global radiation [MPa °C-1]
swp_3 = 0.007888208             # specific parameter for stem water potential calculation based on air temperature, air relative humidity and global radiation [MPa]
swp_4 = 0.0000198265            # specific parameter for stem water potential calculation based on air temperature, air relative humidity and global radiation [MPa J-1 cm2 h]
ddthres_1 = 20.769              # specific paramater for cell wall degree-days threshold calculation based on fruit dry mass at the end of cell division [dd g-1 DM]
ddthres_2 = 518.87              # specific paramater for cell wall degree-days threshold calculation based on fruit dry mass at the end of cell division [dd]
                                # specific parameters for calculation of mass proportion of malic acid in fruit flesh based on degree-days and fruit flesh dry mass [g g-1 DM] [g g-1 DM dd-1] [g g-2 DM] [g g-2 DM dd-1] :
delta_mal = c( 0.06620651,  -0.0000538797,  -0.002464413,    2.406565e-06)   # malic acid
delta_cit = c( 0.1625024,   -0.0000640754,   0.003906348,   -4.784292e-06)   # citric acid
delta_pyr = c( 0.0006896104, 1.613387e-06,   0.00005063595, -6.912509e-08)   # pyruvic acid
delta_oxa = c( 0.004750718, -2.113094e-06,  -0.00002965687,  0.0)            # oxalic acid
delta_K =   c( 0.01394964,  -5.234608e-06,  -0.000288464,    2.682089e-07)   # K+
delta_Mg =  c( 0.00115595,  -7.937479e-07,  -0.00002320017,  2.344528e-08)   # Mg2+
delta_Ca =  c( 0.001588606, -6.625787e-07,  -0.0000228527,   1.514343e-08)   # Ca2+
delta_NH4 = c( 0.000246011,  3.741743e-07,   0.00002495255, -3.010081e-08)   # NH4+
delta_Na =  c( 0.0001279568, 8.15203e-08,   -1.468235e-06,   0.0)            # Na+
delta_glc = c( 0.08074145,  -0.00006325543, -0.001161846,    1.161344e-06)   # glucose
delta_frc = c( 0.04972199,   0.0000966001,  -0.001078579,    0.0)            # fructose
delta_suc = c( 0.0,          0.00017695,    -0.007249,       9.03e-06)       # sucrose
delta_sta = c(-0.1708815,    0.0004380411,   0.01923022,    -0.00002059459)  # starch
