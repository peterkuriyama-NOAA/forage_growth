#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2023-04-24 18:08:53
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
2 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	0	#_recr_dist_pattern1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
3 #_Nblock_Patterns
2 50 1 #_blocks_per_pattern
#_begin and end years of blocks
25 40 41 60
11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20 21 21 22 22 23 23 24 24 25 25 26 26 27 27 28 28 29 29 30 30 31 31 32 32 33 33 34 34 35 35 36 36 37 37 38 38 39 39 40 40 41 41 42 42 43 43 44 44 45 45 46 46 47 47 48 48 49 49 50 50 51 51 52 52 53 53 54 54 55 55 56 56 57 57 58 58 59 59 60 60
11 11
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
0 1 0 0 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.5 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
0 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO  HI  INIT  PRIOR PR_SD PR_type PHASE env_var&link  dev_link  dev_minyr dev_maxyr dev_PH  Block Block_Fxn 
0.2 1 0.7 0 99  0 2  0 0 0 0 0 0 0 #_NatM_p_1_Fem_GP_1
3 15  7 0 99  0 -4  0 0 0 0 0 0 0 #_L_at_Amin_Fem_GP_1
20  30  26  0 99  0 3 0 0 0 0 0 2 2 #_L_at_Amax_Fem_GP_1
0.001 1 0.6 0 99  0 3 0 0 0 0 0 2 2 #_VonBert_K_Fem_GP_1
0.001 0.3 0.13  0 99  0 3 0 0 0 0 0 0 0 #_CV_young_Fem_GP_1
0.001 0.2 0.05  0 99  0 3 0 0 0 0 0 0 0 #_CV_old_Fem_GP_1
-3  3 6.80E-06  0 99  0 -3  0 0 0 0 0 0 0 #_Wtlen_1_Fem_GP_1
-3  5 3.101 0 99  0 -3  0 0 0 0 0 0 0 #_Wtlen_2_Fem_GP_1
10  20  15.44 0 99  0 -99 0 0 0 0 0 0 0 #_Mat50%_Fem_GP_1
-20 3 -0.892  0 99  0 -99 0 0 0 0 0 0 0 #_Mat_slope_Fem_GP_1
-3  3 1 0 99  0 -99 0 0 0 0 0 0 0 #_Eggs_alpha_Fem_GP_1
-3  4 0 0 99  0 -99 0 0 0 0 0 0 0 #_Eggs_beta_Fem_GP_1
-4  4 0 0 99  0 -99 0 0 0 0 0 0 0 #_RecrDist_GP_1
-4  4 0 0 99  0 -99 0 0 0 0 0 0 0 #_RecrDist_Area_1
-4  4 0 0 99  0 -99 0 0 0 0 0 0 0 #_RecrDist_month_1
-4  4 1 0 99  0 -4  0 0 0 0 0 0 0 #_CohortGrowDev
1.00E-06  0.999999  0.5 0 99  0 -99 0 0 0 0 0 0 0 #_FracFemale_GP_1

#_timevary MG parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
#-10	10	1	1	0.5	6	4	#_L_at_Amax_Fem_GP_1_ENV_add
#-10	10	1	1	0.5	6	4	#_VonBert_K_Fem_GP_1_ENV_add
# info on dev vectors created for MGparms are reported with other devs after tag parameter section
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
3 25  17  0 99  0 1 0 0 0 0 0 0 0 #_SR_LN(R0)
0.2 1 0.8 0 99  0 -3  0 0 0 0 0 0 0 #_SR_BH_steep
0 2 0.75  0 99  0 -99 0 0 0 0 0 0 0 #_SR_sigmaR
-5  5 0 0 99  0 -99 0 0 0 0 0 1 2 #_SR_regime
0 0 0 0 99  0 -6  0 0 0 0 0 0 0 #_SR_autocorr

# timevary SR parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
-5	5	-3	0	1	0	-99	#_SR_regime_BLK1repl_25
-5	5	 0	0	1	0	-99	#_SR_regime_BLK1repl_41
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1 # first year of main recr_devs; early devs can preceed this era
60 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase
1 # (0/1) to read 13 advanced options
0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
-4 #_recdev_early_phase
0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1 #_last_yr_nobias_adj_in_MPD; begin of ramp
1 #_first_yr_fullbias_adj_in_MPD; begin of plateau
60 #_last_yr_fullbias_adj_in_MPD
60 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-10 #min rec_dev
10 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
#_Year	recdev
 # 1	  0.299291	#_recdev_input1 
 # 2	  0.295128	#_recdev_input2 
 # 3	  -1.09214	#_recdev_input3 
 # 4	  -1.14776	#_recdev_input4 
 # 5	-0.0922219	#_recdev_input5 
 # 6	  0.159223	#_recdev_input6 
 # 7	 -0.773898	#_recdev_input7 
 # 8	  0.248104	#_recdev_input8 
 # 9	 -0.312029	#_recdev_input9 
# 10	 -0.612281	#_recdev_input10
# 11	  -1.01504	#_recdev_input11
# 12	 -0.542889	#_recdev_input12
# 13	  0.410156	#_recdev_input13
# 14	 -0.665295	#_recdev_input14
# 15	  -1.44673	#_recdev_input15
# 16	 -0.108558	#_recdev_input16
# 17	0.00847582	#_recdev_input17
# 18	  0.222143	#_recdev_input18
# 19	 -0.403916	#_recdev_input19
# 20	 -0.266868	#_recdev_input20
# 21	  0.150506	#_recdev_input21
# 22	  0.501474	#_recdev_input22
# 23	  0.288263	#_recdev_input23
# 24	  0.471196	#_recdev_input24
# 25	 -0.944474	#_recdev_input25
# 26	 -0.234684	#_recdev_input26
# 27	 -0.237117	#_recdev_input27
# 28	  0.499158	#_recdev_input28
# 29	  0.283169	#_recdev_input29
# 30	-0.0484676	#_recdev_input30
# 31	 -0.669209	#_recdev_input31
# 32	  0.184619	#_recdev_input32
# 33	  0.234829	#_recdev_input33
# 34	 -0.173405	#_recdev_input34
# 35	   -1.5006	#_recdev_input35
# 36	  0.485785	#_recdev_input36
# 37	  -1.38256	#_recdev_input37
# 38	  0.384074	#_recdev_input38
# 39	  -1.32099	#_recdev_input39
# 40	 -0.635431	#_recdev_input40
# 41	  -1.12584	#_recdev_input41
# 42	   1.33652	#_recdev_input42
# 43	   -2.4457	#_recdev_input43
# 44	  -1.73446	#_recdev_input44
# 45	  0.456057	#_recdev_input45
# 46	 -0.143503	#_recdev_input46
# 47	  -1.33106	#_recdev_input47
# 48	  -0.40022	#_recdev_input48
# 49	  0.171546	#_recdev_input49
# 50	   -1.4267	#_recdev_input50
# 51	 -0.397917	#_recdev_input51
# 52	 -0.549952	#_recdev_input52
# 53	 -0.876811	#_recdev_input53
# 54	  0.246185	#_recdev_input54
# 55	 -0.012493	#_recdev_input55
# 56	 -0.344996	#_recdev_input56
# 57	   -1.2986	#_recdev_input57
# 58	 -0.303483	#_recdev_input58
# 59	  0.896748	#_recdev_input59
# 60	  -0.87295	#_recdev_input60
# 61	 -0.330471	#_recdev_input61
#
#Fishing Mortality info
0.3 # F ballpark
-2001 # F ballpark year (neg value to disable)
2 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
#_overall start F value; overall phase; N detailed inputs to read
0 1 0 #_F_setup
#_fleet	yr	seas	Fvalue	se	phase
# 1	11	1	     0.02	0.005	1	#_F_setup21 
# 1	12	1	0.0608333	0.005	1	#_F_setup22 
# 1	13	1	 0.101667	0.005	1	#_F_setup23 
# 1	14	1	   0.1425	0.005	1	#_F_setup24 
# 1	15	1	 0.183333	0.005	1	#_F_setup25 
# 1	16	1	 0.224167	0.005	1	#_F_setup26 
# 1	17	1	    0.265	0.005	1	#_F_setup27 
# 1	18	1	 0.305833	0.005	1	#_F_setup28 
# 1	19	1	 0.346667	0.005	1	#_F_setup29 
# 1	20	1	   0.3875	0.005	1	#_F_setup210
# 1	21	1	 0.428333	0.005	1	#_F_setup211
# 1	22	1	 0.469167	0.005	1	#_F_setup212
# 1	23	1	     0.51	0.005	1	#_F_setup213
# 1	24	1	 0.550833	0.005	1	#_F_setup214
# 1	25	1	 0.591667	0.005	1	#_F_setup215
# 1	26	1	   0.6325	0.005	1	#_F_setup216
# 1	27	1	 0.673333	0.005	1	#_F_setup217
# 1	28	1	 0.714167	0.005	1	#_F_setup218
# 1	29	1	    0.755	0.005	1	#_F_setup219
# 1	30	1	 0.795833	0.005	1	#_F_setup220
# 1	31	1	 0.836667	0.005	1	#_F_setup221
# 1	32	1	   0.8775	0.005	1	#_F_setup222
# 1	33	1	 0.918333	0.005	1	#_F_setup223
# 1	34	1	 0.959167	0.005	1	#_F_setup224
# 1	35	1	        1	0.005	1	#_F_setup225
# 1	36	1	      0.6	0.005	1	#_F_setup226
# 1	37	1	 0.575833	0.005	1	#_F_setup227
# 1	38	1	 0.551667	0.005	1	#_F_setup228
# 1	39	1	   0.5275	0.005	1	#_F_setup229
# 1	40	1	 0.503333	0.005	1	#_F_setup230
# 1	41	1	 0.479167	0.005	1	#_F_setup231
# 1	42	1	    0.455	0.005	1	#_F_setup232
# 1	43	1	 0.430833	0.005	1	#_F_setup233
# 1	44	1	 0.406667	0.005	1	#_F_setup234
# 1	45	1	   0.3825	0.005	1	#_F_setup235
# 1	46	1	 0.358333	0.005	1	#_F_setup236
# 1	47	1	 0.334167	0.005	1	#_F_setup237
# 1	48	1	     0.31	0.005	1	#_F_setup238
# 1	49	1	 0.285833	0.005	1	#_F_setup239
# 1	50	1	 0.261667	0.005	1	#_F_setup240
# 1	51	1	   0.2375	0.005	1	#_F_setup241
# 1	52	1	 0.213333	0.005	1	#_F_setup242
# 1	53	1	 0.189167	0.005	1	#_F_setup243
# 1	54	1	    0.165	0.005	1	#_F_setup244
# 1	55	1	 0.140833	0.005	1	#_F_setup245
# 1	56	1	 0.116667	0.005	1	#_F_setup246
# 1	57	1	   0.0925	0.005	1	#_F_setup247
# 1	58	1	0.0683333	0.005	1	#_F_setup248
# 1	59	1	0.0441667	0.005	1	#_F_setup249
# 1	60	1	     0.02	0.005	1	#_F_setup250
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    2	1	0	0	0	0	#_SURVEY    
-9999	0	0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-20	20	0	0	99	0	-5	0	0	0	0	0	0	0	#_LnQ_base_SURVEY(2)
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
1	0	0	0	#_1 FISHERY
0	0	0	0	#_2 SURVEY 
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
17	0	0	9	#_1 FISHERY
17	0	0	1	#_2 SURVEY 
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
0	30	11.6753	0	99	0	3	0	0	0	0	0	0	0	#_SizeSel_P_1_FISHERY(1)
0	10	1.42288	0	99	0	3	0	0	0	0	0	0	0	#_SizeSel_P_2_FISHERY(1)
#_AgeSelex
-5  9 -0.5  0 0 0 -2  0 0 0 0 0 0 0 #_AgeSel_P_1_FISHERY(1) 
-5  9 0.2 0 0 0 2 0 0 0 0 0 0 0 #_AgeSel_P_2_FISHERY(1) 
-5  9 0.8 0 0 0 2 0 0 0 0 0 0 0 #_AgeSel_P_3_FISHERY(1) 
-5  9 0.25  0 0 0 2 0 0 0 0 0 0 0 #_AgeSel_P_4_FISHERY(1) 
-5  9 -0.1  0 0 0 2 0 0 0 0 0 0 0 #_AgeSel_P_5_FISHERY(1) 
-5  9 -0.4  0 0 0 2 0 0 0 0 0 0 0 #_AgeSel_P_6_FISHERY(1) 
-5  9 -0.9  0 0 0 -2  0 0 0 0 0 0 0 #_AgeSel_P_7_FISHERY(1) 
-5  9 -0.65 0 0 0 -2  0 0 0 0 0 0 0 #_AgeSel_P_8_FISHERY(1) 
-5  9 -0.7  0 0 0 -2  0 0 0 0 0 0 0 #_AgeSel_P_9_FISHERY(1) 
-5  9 -0.45 0 0 0 -2  0 0 0 0 0 0 0 #_AgeSel_P_10_FISHERY(1)
 0	9	        0	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_1_SURVEY(2)  
 0	9	  1.03234	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_2_SURVEY(2)  
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE

# info on dev vectors created for selex parms are reported with other devs after tag parameter section
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_Data_type Fleet Value
-9999 1 0 # terminator
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
