#C file created using an r4ss function
#C file write time: 2025-04-02  16:44:26
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
2 #_Nblock_Patterns
50 1 #_blocks_per_pattern
#_begin and end years of blocks
11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20 21 21 22 22 23 23 24 24 25 25 26 26 27 27 28 28 29 29 30 30 31 31 32 32 33 33 34 34 35 35 36 36 37 37 38 38 39 39 40 40 41 41 42 42 43 43 44 44 45 45 46 46 47 47 48 48 49 49 50 50 51 51 52 52 53 53 54 54 55 55 56 56 57 57 58 58 59 59 60 60
11 11
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 0 0 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
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
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
  0.2	       1	    0.8	0	99	0	 -3	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1  
    3	      15	    8.5	0	99	0	  0	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1 
   20	      30	     23	0	99	0	  0	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1 
0.001	       1	  0.655	0	99	0	  0	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1 
0.001	     0.3	    0.2	0	99	0	  5	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1  
0.001	     0.2	   0.05	0	99	0	  5	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1    
   -3	       3	6.8e-06	0	99	0	 -3	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1   
   -3	       5	  3.101	0	99	0	 -3	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1   
   10	      20	  15.44	0	99	0	-99	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1    
  -20	       3	 -0.892	0	99	0	-99	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1 
   -3	       3	      1	0	99	0	-99	0	0	0	0	0	0	0	#_Eggs_alpha_Fem_GP_1
   -3	       4	      0	0	99	0	-99	0	0	0	0	0	0	0	#_Eggs_beta_Fem_GP_1 
   -4	       4	      0	0	99	0	-99	0	0	0	0	0	0	0	#_RecrDist_GP_1      
   -4	       4	      0	0	99	0	-99	0	0	0	0	0	0	0	#_RecrDist_Area_1    
   -4	       4	      0	0	99	0	-99	0	0	0	0	0	0	0	#_RecrDist_month_1   
   -4	       4	      1	0	99	0	 -4	0	0	0	0	0	0	0	#_CohortGrowDev      
1e-06	0.999999	    0.5	0	99	0	-99	0	0	0	0	0	0	0	#_FracFemale_GP_1    
#_timevary MG parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
#-4	8	 7.602	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_11
#-4	8	 7.462	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_12
#-4	8	 7.293	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_13
#-4	8	 7.582	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_14
#-4	8	 8.005	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_15
#-4	8	  8.09	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_16
#-4	8	  7.91	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_17
#-4	8	  7.98	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_18
#-4	8	 7.831	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_19
#-4	8	 7.816	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_20
#-4	8	 7.965	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_21
#-4	8	 8.199	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_22
#-4	8	 8.334	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_23
#-4	8	 8.025	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_24
#-4	8	  7.98	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_25
#-4	8	 8.329	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_26
#-4	8	 8.388	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_27
#-4	8	 8.209	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_28
#-4	8	 7.915	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_29
#-4	8	  8.02	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_30
#-4	8	 8.015	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_31
#-4	8	 7.985	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_32
#-4	8	 7.711	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_33
#-4	8	 7.407	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_34
#-4	8	 7.482	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_35
#-4	8	 8.383	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_36
#-4	8	 8.876	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_37
#-4	8	 9.036	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_38
#-4	8	 9.135	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_39
#-4	8	  9.18	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_40
#-4	8	 9.225	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_41
#-4	8	  9.26	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_42
#-4	8	 9.265	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_43
#-4	8	 9.265	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_44
#-4	8	 9.275	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_45
#-4	8	  9.28	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_46
#-4	8	  9.28	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_47
#-4	8	  9.28	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_48
#-4	8	  9.28	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_49
#-4	8	 9.285	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_50
#-4	8	 9.285	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_51
#-4	8	  9.28	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_52
#-4	8	  9.25	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_53
#-4	8	 9.245	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_54
#-4	8	 9.235	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_55
#-4	8	 9.041	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_56
#-4	8	 8.866	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_57
#-4	8	 8.832	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_58
#-4	8	 8.712	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_59
#-4	8	 8.418	0	0	0	-4	#_L_at_Amin_Fem_GP_1_BLK1repl_60
#-4	8	21.653	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_11
#-4	8	21.443	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_12
#-4	8	21.189	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_13
#-4	8	21.623	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_14
#-4	8	22.257	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_15
#-4	8	22.384	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_16
#-4	8	22.116	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_17
#-4	8	 22.22	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_18
#-4	8	21.996	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_19
#-4	8	21.974	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_20
#-4	8	22.198	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_21
#-4	8	22.549	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_22
#-4	8	 22.75	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_23
#-4	8	22.287	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_24
#-4	8	 22.22	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_25
#-4	8	22.743	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_26
#-4	8	22.833	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_27
#-4	8	22.564	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_28
#-4	8	22.123	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_29
#-4	8	 22.28	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_30
#-4	8	22.272	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_31
#-4	8	22.228	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_32
#-4	8	21.817	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_33
#-4	8	21.361	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_34
#-4	8	21.473	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_35
#-4	8	22.825	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_36
#-4	8	23.564	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_37
#-4	8	23.803	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_38
#-4	8	23.953	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_39
#-4	8	 24.02	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_40
#-4	8	24.087	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_41
#-4	8	 24.14	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_42
#-4	8	24.147	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_43
#-4	8	24.147	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_44
#-4	8	24.162	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_45
#-4	8	24.169	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_46
#-4	8	24.169	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_47
#-4	8	24.169	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_48
#-4	8	24.169	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_49
#-4	8	24.177	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_50
#-4	8	24.177	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_51
#-4	8	24.169	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_52
#-4	8	24.125	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_53
#-4	8	24.117	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_54
#-4	8	24.102	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_55
#-4	8	23.811	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_56
#-4	8	 23.55	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_57
#-4	8	23.497	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_58
#-4	8	23.318	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_59
#-4	8	22.877	0	0	0	-4	#_L_at_Amax_Fem_GP_1_BLK1repl_60
#-4	8	 0.475	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_11
#-4	8	 0.447	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_12
#-4	8	 0.414	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_13
#-4	8	 0.471	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_14
#-4	8	 0.556	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_15
#-4	8	 0.573	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_16
#-4	8	 0.537	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_17
#-4	8	 0.551	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_18
#-4	8	 0.521	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_19
#-4	8	 0.518	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_20
#-4	8	 0.548	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_21
#-4	8	 0.595	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_22
#-4	8	 0.622	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_23
#-4	8	  0.56	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_24
#-4	8	 0.551	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_25
#-4	8	 0.621	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_26
#-4	8	 0.633	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_27
#-4	8	 0.597	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_28
#-4	8	 0.538	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_29
#-4	8	 0.559	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_30
#-4	8	 0.558	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_31
#-4	8	 0.552	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_32
#-4	8	 0.497	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_33
#-4	8	 0.436	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_34
#-4	8	 0.451	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_35
#-4	8	 0.632	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_36
#-4	8	  0.73	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_37
#-4	8	 0.762	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_38
#-4	8	 0.782	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_39
#-4	8	 0.791	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_40
#-4	8	   0.8	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_41
#-4	8	 0.807	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_42
#-4	8	 0.808	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_43
#-4	8	 0.808	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_44
#-4	8	  0.81	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_45
#-4	8	 0.811	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_46
#-4	8	 0.811	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_47
#-4	8	 0.811	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_48
#-4	8	 0.811	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_49
#-4	8	 0.812	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_50
#-4	8	 0.812	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_51
#-4	8	 0.811	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_52
#-4	8	 0.805	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_53
#-4	8	 0.804	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_54
#-4	8	 0.802	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_55
#-4	8	 0.763	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_56
#-4	8	 0.728	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_57
#-4	8	 0.721	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_58
#-4	8	 0.697	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_59
#-4	8	 0.639	0	0	0	-4	#_VonBert_K_Fem_GP_1_BLK1repl_60
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
  3	25	16.4	0	99	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.2	 1	 0.8	0	99	0	 -3	0	0	0	0	0	0	0	#_SR_BH_steep
  0	 2	0.75	0	99	0	-99	0	0	0	0	0	0	0	#_SR_sigmaR  
 -5	 5	   0	0	99	0	-99	0	0	0	0	0	0	0	#_SR_regime  
  0	 0	   0	0	99	0	 -6	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1 # first year of main recr_devs; early devs can preceed this era
60 # last year of main recr_devs; forecast devs start in following year
-2 #_recdev phase
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
61 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
#_Year	recdev
 1	  1.42284	#_recdev_input1 
 2	  1.19951	#_recdev_input2 
 3	 0.979635	#_recdev_input3 
 4	  2.09147	#_recdev_input4 
 5	  1.17967	#_recdev_input5 
 6	  1.20662	#_recdev_input6 
 7	 0.850499	#_recdev_input7 
 8	  1.78955	#_recdev_input8 
 9	  1.21372	#_recdev_input9 
10	  1.49078	#_recdev_input10
11	 0.863276	#_recdev_input11
12	 0.847761	#_recdev_input12
13	 0.686251	#_recdev_input13
14	 0.705105	#_recdev_input14
15	 0.805976	#_recdev_input15
16	 0.937668	#_recdev_input16
17	 0.887138	#_recdev_input17
18	 0.733515	#_recdev_input18
19	 0.938335	#_recdev_input19
20	  0.81384	#_recdev_input20
21	 0.805976	#_recdev_input21
22	 0.699717	#_recdev_input22
23	 0.677345	#_recdev_input23
24	 0.686251	#_recdev_input24
25	 0.817515	#_recdev_input25
26	-0.681618	#_recdev_input26
27	-0.267009	#_recdev_input27
28	-0.512137	#_recdev_input28
29	 -1.32969	#_recdev_input29
30	 -1.80776	#_recdev_input30
31	 -2.84508	#_recdev_input31
32	 -1.39339	#_recdev_input32
33	 -2.24086	#_recdev_input33
34	 -2.25236	#_recdev_input34
35	 -2.28099	#_recdev_input35
36	-0.890994	#_recdev_input36
37	 -1.63342	#_recdev_input37
38	-0.846293	#_recdev_input38
39	 -1.15989	#_recdev_input39
40	-0.848027	#_recdev_input40
41	 -1.60081	#_recdev_input41
42	 -1.40385	#_recdev_input42
43	 -1.13242	#_recdev_input43
44	 -1.10796	#_recdev_input44
45	-0.818144	#_recdev_input45
46	 -2.31282	#_recdev_input46
47	 -1.20246	#_recdev_input47
48	-0.877745	#_recdev_input48
49	-0.342148	#_recdev_input49
50	-0.445674	#_recdev_input50
51	-0.725473	#_recdev_input51
52	-0.681618	#_recdev_input52
53	-0.512137	#_recdev_input53
54	  0.81384	#_recdev_input54
55	  1.20216	#_recdev_input55
56	 0.733515	#_recdev_input56
57	  0.34892	#_recdev_input57
58	 0.699717	#_recdev_input58
59	 0.887138	#_recdev_input59
60	  1.09347	#_recdev_input60
61	 0.525171	#_recdev_input61
#
#Fishing Mortality info
0.3 # F ballpark
-2001 # F ballpark year (neg value to disable)
2 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
#_overall start F value; overall phase; N detailed inputs to read
0 1 50 #_F_setup
#_fleet	year	seas	Fvalue	se	phase
1	11	1	     0.02	0.1	1	#_F_setup21 
1	12	1	0.0608333	0.1	1	#_F_setup22 
1	13	1	 0.101667	0.1	1	#_F_setup23 
1	14	1	   0.1425	0.1	1	#_F_setup24 
1	15	1	 0.183333	0.1	1	#_F_setup25 
1	16	1	 0.224167	0.1	1	#_F_setup26 
1	17	1	    0.265	0.1	1	#_F_setup27 
1	18	1	 0.305833	0.1	1	#_F_setup28 
1	19	1	 0.346667	0.1	1	#_F_setup29 
1	20	1	   0.3875	0.1	1	#_F_setup210
1	21	1	 0.428333	0.1	1	#_F_setup211
1	22	1	 0.469167	0.1	1	#_F_setup212
1	23	1	     0.51	0.1	1	#_F_setup213
1	24	1	 0.550833	0.1	1	#_F_setup214
1	25	1	 0.591667	0.1	1	#_F_setup215
1	26	1	   0.6325	0.1	1	#_F_setup216
1	27	1	 0.673333	0.1	1	#_F_setup217
1	28	1	 0.714167	0.1	1	#_F_setup218
1	29	1	    0.755	0.1	1	#_F_setup219
1	30	1	 0.795833	0.1	1	#_F_setup220
1	31	1	 0.836667	0.1	1	#_F_setup221
1	32	1	   0.8775	0.1	1	#_F_setup222
1	33	1	 0.918333	0.1	1	#_F_setup223
1	34	1	 0.959167	0.1	1	#_F_setup224
1	35	1	        1	0.1	1	#_F_setup225
1	36	1	      0.6	0.1	1	#_F_setup226
1	37	1	 0.575833	0.1	1	#_F_setup227
1	38	1	 0.551667	0.1	1	#_F_setup228
1	39	1	   0.5275	0.1	1	#_F_setup229
1	40	1	 0.503333	0.1	1	#_F_setup230
1	41	1	 0.479167	0.1	1	#_F_setup231
1	42	1	    0.455	0.1	1	#_F_setup232
1	43	1	 0.430833	0.1	1	#_F_setup233
1	44	1	 0.406667	0.1	1	#_F_setup234
1	45	1	   0.3825	0.1	1	#_F_setup235
1	46	1	 0.358333	0.1	1	#_F_setup236
1	47	1	 0.334167	0.1	1	#_F_setup237
1	48	1	     0.31	0.1	1	#_F_setup238
1	49	1	 0.285833	0.1	1	#_F_setup239
1	50	1	 0.261667	0.1	1	#_F_setup240
1	51	1	   0.2375	0.1	1	#_F_setup241
1	52	1	 0.213333	0.1	1	#_F_setup242
1	53	1	 0.189167	0.1	1	#_F_setup243
1	54	1	    0.165	0.1	1	#_F_setup244
1	55	1	 0.140833	0.1	1	#_F_setup245
1	56	1	 0.116667	0.1	1	#_F_setup246
1	57	1	   0.0925	0.1	1	#_F_setup247
1	58	1	0.0683333	0.1	1	#_F_setup248
1	59	1	0.0441667	0.1	1	#_F_setup249
1	60	1	     0.02	0.1	1	#_F_setup250
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
-5	9	   -0.5	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_1_FISHERY(1) 
-5	9	    0.2	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_2_FISHERY(1) 
-5	9	    0.8	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_3_FISHERY(1) 
-5	9	   0.25	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_4_FISHERY(1) 
-5	9	   -0.1	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_5_FISHERY(1) 
-5	9	   -0.4	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_6_FISHERY(1) 
-5	9	   -0.9	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_7_FISHERY(1) 
-5	9	  -0.65	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_8_FISHERY(1) 
-5	9	   -0.7	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_9_FISHERY(1) 
-5	9	  -0.45	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_10_FISHERY(1)
 0	9	      0	0	0	0	-2	0	0	0	0	0	0	0	#_AgeSel_P_1_SURVEY(2)  
 0	9	1.03234	0	0	0	 2	0	0	0	0	0	0	0	#_AgeSel_P_2_SURVEY(2)  
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
#-5.34994	8.65006	         0	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_11 
#-5.34994	8.65006	-0.0916667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_12 
#-5.34994	8.65006	 -0.183333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_13 
#-5.34994	8.65006	    -0.275	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_14 
#-5.34994	8.65006	 -0.366667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_15 
#-5.34994	8.65006	 -0.458333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_16 
#-5.34994	8.65006	     -0.55	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_17 
#-5.34994	8.65006	 -0.641667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_18 
#-5.34994	8.65006	 -0.733333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_19 
#-5.34994	8.65006	    -0.825	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_20 
#-5.34994	8.65006	 -0.916667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_21 
#-5.34994	8.65006	  -1.00833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_22 
#-5.34994	8.65006	      -1.1	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_23 
#-5.34994	8.65006	  -1.19167	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_24 
#-5.34994	8.65006	  -1.28333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_25 
#-5.34994	8.65006	    -1.375	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_26 
#-5.34994	8.65006	  -1.46667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_27 
#-5.34994	8.65006	  -1.55833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_28 
#-5.34994	8.65006	     -1.65	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_29 
#-5.34994	8.65006	  -1.74167	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_30 
#-5.34994	8.65006	  -1.83333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_31 
#-5.34994	8.65006	    -1.925	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_32 
#-5.34994	8.65006	  -2.01667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_33 
#-5.34994	8.65006	  -2.10833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_34 
#-5.34994	8.65006	      -2.2	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_35 
#-5.34994	8.65006	      -2.2	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_36 
#-5.34994	8.65006	  -2.10833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_37 
#-5.34994	8.65006	  -2.01667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_38 
#-5.34994	8.65006	    -1.925	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_39 
#-5.34994	8.65006	  -1.83333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_40 
#-5.34994	8.65006	  -1.74167	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_41 
#-5.34994	8.65006	     -1.65	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_42 
#-5.34994	8.65006	  -1.55833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_43 
#-5.34994	8.65006	  -1.46667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_44 
#-5.34994	8.65006	    -1.375	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_45 
#-5.34994	8.65006	  -1.28333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_46 
#-5.34994	8.65006	  -1.19167	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_47 
#-5.34994	8.65006	      -1.1	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_48 
#-5.34994	8.65006	  -1.00833	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_49 
#-5.34994	8.65006	 -0.916667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_50 
#-5.34994	8.65006	    -0.825	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_51 
#-5.34994	8.65006	 -0.733333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_52 
#-5.34994	8.65006	 -0.641667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_53 
#-5.34994	8.65006	     -0.55	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_54 
#-5.34994	8.65006	 -0.458333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_55 
#-5.34994	8.65006	 -0.366667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_56 
#-5.34994	8.65006	    -0.275	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_57 
#-5.34994	8.65006	 -0.183333	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_58 
#-5.34994	8.65006	-0.0916667	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_59 
#-5.34994	8.65006	         0	0	3.5	6	4	#_AgeSel_P_2_FISHERY(1)_BLK1add_60 
 #-5.7788	 8.2212	         0	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_11 
 #-5.7788	 8.2212	   -0.0625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_12 
 #-5.7788	 8.2212	    -0.125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_13 
 #-5.7788	 8.2212	   -0.1875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_14 
 #-5.7788	 8.2212	     -0.25	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_15 
 #-5.7788	 8.2212	   -0.3125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_16 
 #-5.7788	 8.2212	    -0.375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_17 
 #-5.7788	 8.2212	   -0.4375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_18 
 #-5.7788	 8.2212	      -0.5	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_19 
 #-5.7788	 8.2212	   -0.5625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_20 
 #-5.7788	 8.2212	    -0.625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_21 
 #-5.7788	 8.2212	   -0.6875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_22 
 #-5.7788	 8.2212	     -0.75	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_23 
 #-5.7788	 8.2212	   -0.8125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_24 
 #-5.7788	 8.2212	    -0.875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_25 
 #-5.7788	 8.2212	   -0.9375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_26 
 #-5.7788	 8.2212	        -1	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_27 
 #-5.7788	 8.2212	   -1.0625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_28 
 #-5.7788	 8.2212	    -1.125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_29 
 #-5.7788	 8.2212	   -1.1875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_30 
 #-5.7788	 8.2212	     -1.25	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_31 
 #-5.7788	 8.2212	   -1.3125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_32 
 #-5.7788	 8.2212	    -1.375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_33 
 #-5.7788	 8.2212	   -1.4375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_34 
 #-5.7788	 8.2212	      -1.5	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_35 
 #-5.7788	 8.2212	      -1.5	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_36 
 #-5.7788	 8.2212	   -1.4375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_37 
 #-5.7788	 8.2212	    -1.375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_38 
 #-5.7788	 8.2212	   -1.3125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_39 
 #-5.7788	 8.2212	     -1.25	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_40 
 #-5.7788	 8.2212	   -1.1875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_41 
 #-5.7788	 8.2212	    -1.125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_42 
 #-5.7788	 8.2212	   -1.0625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_43 
 #-5.7788	 8.2212	        -1	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_44 
 #-5.7788	 8.2212	   -0.9375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_45 
 #-5.7788	 8.2212	    -0.875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_46 
 #-5.7788	 8.2212	   -0.8125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_47 
 #-5.7788	 8.2212	     -0.75	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_48 
 #-5.7788	 8.2212	   -0.6875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_49 
 #-5.7788	 8.2212	    -0.625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_50 
 #-5.7788	 8.2212	   -0.5625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_51 
 #-5.7788	 8.2212	      -0.5	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_52 
 #-5.7788	 8.2212	   -0.4375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_53 
 #-5.7788	 8.2212	    -0.375	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_54 
 #-5.7788	 8.2212	   -0.3125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_55 
 #-5.7788	 8.2212	     -0.25	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_56 
 #-5.7788	 8.2212	   -0.1875	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_57 
 #-5.7788	 8.2212	    -0.125	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_58 
 #-5.7788	 8.2212	   -0.0625	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_59 
 #-5.7788	 8.2212	         0	0	3.5	6	4	#_AgeSel_P_3_FISHERY(1)_BLK1add_60 
      #-6	      8	         0	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_11 
      #-6	      8	-0.0354167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_12 
      #-6	      8	-0.0708333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_13 
      #-6	      8	  -0.10625	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_14 
      #-6	      8	 -0.141667	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_15 
      #-6	      8	 -0.177083	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_16 
      #-6	      8	   -0.2125	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_17 
      #-6	      8	 -0.247917	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_18 
      #-6	      8	 -0.283333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_19 
      #-6	      8	  -0.31875	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_20 
      #-6	      8	 -0.354167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_21 
      #-6	      8	 -0.389583	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_22 
      #-6	      8	    -0.425	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_23 
      #-6	      8	 -0.460417	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_24 
      #-6	      8	 -0.495833	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_25 
      #-6	      8	  -0.53125	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_26 
      #-6	      8	 -0.566667	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_27 
      #-6	      8	 -0.602083	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_28 
      #-6	      8	   -0.6375	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_29 
      #-6	      8	 -0.672917	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_30 
      #-6	      8	 -0.708333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_31 
      #-6	      8	  -0.74375	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_32 
      #-6	      8	 -0.779167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_33 
      #-6	      8	 -0.814583	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_34 
      #-6	      8	     -0.85	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_35 
      #-6	      8	     -0.85	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_36 
      #-6	      8	 -0.814583	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_37 
      #-6	      8	 -0.779167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_38 
      #-6	      8	  -0.74375	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_39 
      #-6	      8	 -0.708333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_40 
      #-6	      8	 -0.672917	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_41 
      #-6	      8	   -0.6375	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_42 
      #-6	      8	 -0.602083	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_43 
      #-6	      8	 -0.566667	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_44 
      #-6	      8	  -0.53125	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_45 
      #-6	      8	 -0.495833	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_46 
      #-6	      8	 -0.460417	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_47 
      #-6	      8	    -0.425	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_48 
      #-6	      8	 -0.389583	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_49 
      #-6	      8	 -0.354167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_50 
      #-6	      8	  -0.31875	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_51 
      #-6	      8	 -0.283333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_52 
      #-6	      8	 -0.247917	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_53 
      #-6	      8	   -0.2125	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_54 
      #-6	      8	 -0.177083	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_55 
      #-6	      8	 -0.141667	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_56 
      #-6	      8	  -0.10625	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_57 
      #-6	      8	-0.0708333	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_58 
      #-6	      8	-0.0354167	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_59 
      #-6	      8	         0	0	3.5	6	4	#_AgeSel_P_4_FISHERY(1)_BLK1add_60 
#-5.90484	8.09516	         0	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_11 
#-5.90484	8.09516	-0.0729167	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_12 
#-5.90484	8.09516	 -0.145833	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_13 
#-5.90484	8.09516	  -0.21875	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_14 
#-5.90484	8.09516	 -0.291667	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_15 
#-5.90484	8.09516	 -0.364583	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_16 
#-5.90484	8.09516	   -0.4375	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_17 
#-5.90484	8.09516	 -0.510417	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_18 
#-5.90484	8.09516	 -0.583333	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_19 
#-5.90484	8.09516	  -0.65625	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_20 
#-5.90484	8.09516	 -0.729167	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_21 
#-5.90484	8.09516	 -0.802083	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_22 
#-5.90484	8.09516	    -0.875	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_23 
#-5.90484	8.09516	 -0.947917	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_24 
#-5.90484	8.09516	  -1.02083	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_25 
#-5.90484	8.09516	  -1.09375	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_26 
#-5.90484	8.09516	  -1.16667	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_27 
#-5.90484	8.09516	  -1.23958	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_28 
#-5.90484	8.09516	   -1.3125	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_29 
#-5.90484	8.09516	  -1.38542	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_30 
#-5.90484	8.09516	  -1.45833	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_31 
#-5.90484	8.09516	  -1.53125	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_32 
#-5.90484	8.09516	  -1.60417	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_33 
#-5.90484	8.09516	  -1.67708	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_34 
#-5.90484	8.09516	     -1.75	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_35 
#-5.90484	8.09516	     -1.75	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_36 
#-5.90484	8.09516	  -1.67708	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_37 
#-5.90484	8.09516	  -1.60417	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_38 
#-5.90484	8.09516	  -1.53125	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_39 
#-5.90484	8.09516	  -1.45833	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_40 
#-5.90484	8.09516	  -1.38542	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_41 
#-5.90484	8.09516	   -1.3125	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_42 
#-5.90484	8.09516	  -1.23958	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_43 
#-5.90484	8.09516	  -1.16667	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_44 
#-5.90484	8.09516	  -1.09375	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_45 
#-5.90484	8.09516	  -1.02083	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_46 
#-5.90484	8.09516	 -0.947917	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_47 
#-5.90484	8.09516	    -0.875	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_48 
#-5.90484	8.09516	 -0.802083	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_49 
#-5.90484	8.09516	 -0.729167	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_50 
#-5.90484	8.09516	  -0.65625	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_51 
#-5.90484	8.09516	 -0.583333	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_52 
#-5.90484	8.09516	 -0.510417	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_53 
#-5.90484	8.09516	   -0.4375	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_54 
#-5.90484	8.09516	 -0.364583	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_55 
#-5.90484	8.09516	 -0.291667	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_56 
#-5.90484	8.09516	  -0.21875	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_57 
#-5.90484	8.09516	 -0.145833	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_58 
#-5.90484	8.09516	-0.0729167	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_59 
#-5.90484	8.09516	         0	0	3.5	6	4	#_AgeSel_P_5_FISHERY(1)_BLK1add_60 
#-5.60653	8.39347	         0	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_11 
#-5.60653	8.39347	-0.0145833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_12 
#-5.60653	8.39347	-0.0291667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_13 
#-5.60653	8.39347	  -0.04375	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_14 
#-5.60653	8.39347	-0.0583333	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_15 
#-5.60653	8.39347	-0.0729167	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_16 
#-5.60653	8.39347	   -0.0875	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_17 
#-5.60653	8.39347	 -0.102083	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_18 
#-5.60653	8.39347	 -0.116667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_19 
#-5.60653	8.39347	  -0.13125	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_20 
#-5.60653	8.39347	 -0.145833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_21 
#-5.60653	8.39347	 -0.160417	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_22 
#-5.60653	8.39347	    -0.175	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_23 
#-5.60653	8.39347	 -0.189583	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_24 
#-5.60653	8.39347	 -0.204167	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_25 
#-5.60653	8.39347	  -0.21875	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_26 
#-5.60653	8.39347	 -0.233333	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_27 
#-5.60653	8.39347	 -0.247917	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_28 
#-5.60653	8.39347	   -0.2625	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_29 
#-5.60653	8.39347	 -0.277083	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_30 
#-5.60653	8.39347	 -0.291667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_31 
#-5.60653	8.39347	  -0.30625	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_32 
#-5.60653	8.39347	 -0.320833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_33 
#-5.60653	8.39347	 -0.335417	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_34 
#-5.60653	8.39347	     -0.35	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_35 
#-5.60653	8.39347	     -0.35	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_36 
#-5.60653	8.39347	 -0.335417	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_37 
#-5.60653	8.39347	 -0.320833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_38 
#-5.60653	8.39347	  -0.30625	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_39 
#-5.60653	8.39347	 -0.291667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_40 
#-5.60653	8.39347	 -0.277083	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_41 
#-5.60653	8.39347	   -0.2625	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_42 
#-5.60653	8.39347	 -0.247917	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_43 
#-5.60653	8.39347	 -0.233333	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_44 
#-5.60653	8.39347	  -0.21875	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_45 
#-5.60653	8.39347	 -0.204167	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_46 
#-5.60653	8.39347	 -0.189583	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_47 
#-5.60653	8.39347	    -0.175	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_48 
#-5.60653	8.39347	 -0.160417	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_49 
#-5.60653	8.39347	 -0.145833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_50 
#-5.60653	8.39347	  -0.13125	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_51 
#-5.60653	8.39347	 -0.116667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_52 
#-5.60653	8.39347	 -0.102083	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_53 
#-5.60653	8.39347	   -0.0875	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_54 
#-5.60653	8.39347	-0.0729167	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_55 
#-5.60653	8.39347	-0.0583333	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_56 
#-5.60653	8.39347	  -0.04375	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_57 
#-5.60653	8.39347	-0.0291667	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_58 
#-5.60653	8.39347	-0.0145833	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_59 
#-5.60653	8.39347	         0	0	3.5	6	4	#_AgeSel_P_6_FISHERY(1)_BLK1add_60 
 #-5.2466	 8.7534	         0	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_11 
 #-5.2466	 8.7534	  -0.03125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_12 
 #-5.2466	 8.7534	   -0.0625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_13 
 #-5.2466	 8.7534	  -0.09375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_14 
 #-5.2466	 8.7534	    -0.125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_15 
 #-5.2466	 8.7534	  -0.15625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_16 
 #-5.2466	 8.7534	   -0.1875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_17 
 #-5.2466	 8.7534	  -0.21875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_18 
 #-5.2466	 8.7534	     -0.25	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_19 
 #-5.2466	 8.7534	  -0.28125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_20 
 #-5.2466	 8.7534	   -0.3125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_21 
 #-5.2466	 8.7534	  -0.34375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_22 
 #-5.2466	 8.7534	    -0.375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_23 
 #-5.2466	 8.7534	  -0.40625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_24 
 #-5.2466	 8.7534	   -0.4375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_25 
 #-5.2466	 8.7534	  -0.46875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_26 
 #-5.2466	 8.7534	      -0.5	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_27 
 #-5.2466	 8.7534	  -0.53125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_28 
 #-5.2466	 8.7534	   -0.5625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_29 
 #-5.2466	 8.7534	  -0.59375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_30 
 #-5.2466	 8.7534	    -0.625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_31 
 #-5.2466	 8.7534	  -0.65625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_32 
 #-5.2466	 8.7534	   -0.6875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_33 
 #-5.2466	 8.7534	  -0.71875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_34 
 #-5.2466	 8.7534	     -0.75	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_35 
 #-5.2466	 8.7534	     -0.75	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_36 
 #-5.2466	 8.7534	  -0.71875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_37 
 #-5.2466	 8.7534	   -0.6875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_38 
 #-5.2466	 8.7534	  -0.65625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_39 
 #-5.2466	 8.7534	    -0.625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_40 
 #-5.2466	 8.7534	  -0.59375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_41 
 #-5.2466	 8.7534	   -0.5625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_42 
 #-5.2466	 8.7534	  -0.53125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_43 
 #-5.2466	 8.7534	      -0.5	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_44 
 #-5.2466	 8.7534	  -0.46875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_45 
 #-5.2466	 8.7534	   -0.4375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_46 
 #-5.2466	 8.7534	  -0.40625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_47 
 #-5.2466	 8.7534	    -0.375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_48 
 #-5.2466	 8.7534	  -0.34375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_49 
 #-5.2466	 8.7534	   -0.3125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_50 
 #-5.2466	 8.7534	  -0.28125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_51 
 #-5.2466	 8.7534	     -0.25	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_52 
 #-5.2466	 8.7534	  -0.21875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_53 
 #-5.2466	 8.7534	   -0.1875	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_54 
 #-5.2466	 8.7534	  -0.15625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_55 
 #-5.2466	 8.7534	    -0.125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_56 
 #-5.2466	 8.7534	  -0.09375	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_57 
 #-5.2466	 8.7534	   -0.0625	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_58 
 #-5.2466	 8.7534	  -0.03125	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_59 
 #-5.2466	 8.7534	         0	0	3.5	6	4	#_AgeSel_P_7_FISHERY(1)_BLK1add_60 
#-5.12873	8.87127	         0	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_11 
#-5.12873	8.87127	0.00833333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_12 
#-5.12873	8.87127	 0.0166667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_13 
#-5.12873	8.87127	     0.025	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_14 
#-5.12873	8.87127	 0.0333333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_15 
#-5.12873	8.87127	 0.0416667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_16 
#-5.12873	8.87127	      0.05	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_17 
#-5.12873	8.87127	 0.0583333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_18 
#-5.12873	8.87127	 0.0666667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_19 
#-5.12873	8.87127	     0.075	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_20 
#-5.12873	8.87127	 0.0833333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_21 
#-5.12873	8.87127	 0.0916667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_22 
#-5.12873	8.87127	       0.1	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_23 
#-5.12873	8.87127	  0.108333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_24 
#-5.12873	8.87127	  0.116667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_25 
#-5.12873	8.87127	     0.125	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_26 
#-5.12873	8.87127	  0.133333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_27 
#-5.12873	8.87127	  0.141667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_28 
#-5.12873	8.87127	      0.15	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_29 
#-5.12873	8.87127	  0.158333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_30 
#-5.12873	8.87127	  0.166667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_31 
#-5.12873	8.87127	     0.175	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_32 
#-5.12873	8.87127	  0.183333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_33 
#-5.12873	8.87127	  0.191667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_34 
#-5.12873	8.87127	       0.2	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_35 
#-5.12873	8.87127	       0.2	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_36 
#-5.12873	8.87127	  0.191667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_37 
#-5.12873	8.87127	  0.183333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_38 
#-5.12873	8.87127	     0.175	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_39 
#-5.12873	8.87127	  0.166667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_40 
#-5.12873	8.87127	  0.158333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_41 
#-5.12873	8.87127	      0.15	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_42 
#-5.12873	8.87127	  0.141667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_43 
#-5.12873	8.87127	  0.133333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_44 
#-5.12873	8.87127	     0.125	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_45 
#-5.12873	8.87127	  0.116667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_46 
#-5.12873	8.87127	  0.108333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_47 
#-5.12873	8.87127	       0.1	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_48 
#-5.12873	8.87127	 0.0916667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_49 
#-5.12873	8.87127	 0.0833333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_50 
#-5.12873	8.87127	     0.075	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_51 
#-5.12873	8.87127	 0.0666667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_52 
#-5.12873	8.87127	 0.0583333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_53 
#-5.12873	8.87127	      0.05	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_54 
#-5.12873	8.87127	 0.0416667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_55 
#-5.12873	8.87127	 0.0333333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_56 
#-5.12873	8.87127	     0.025	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_57 
#-5.12873	8.87127	 0.0166667	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_58 
#-5.12873	8.87127	0.00833333	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_59 
#-5.12873	8.87127	         0	0	3.5	6	4	#_AgeSel_P_8_FISHERY(1)_BLK1add_60 
#-5.06393	8.93607	         0	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_11 
#-5.06393	8.93607	 0.0270833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_12 
#-5.06393	8.93607	 0.0541667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_13 
#-5.06393	8.93607	   0.08125	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_14 
#-5.06393	8.93607	  0.108333	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_15 
#-5.06393	8.93607	  0.135417	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_16 
#-5.06393	8.93607	    0.1625	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_17 
#-5.06393	8.93607	  0.189583	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_18 
#-5.06393	8.93607	  0.216667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_19 
#-5.06393	8.93607	   0.24375	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_20 
#-5.06393	8.93607	  0.270833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_21 
#-5.06393	8.93607	  0.297917	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_22 
#-5.06393	8.93607	     0.325	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_23 
#-5.06393	8.93607	  0.352083	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_24 
#-5.06393	8.93607	  0.379167	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_25 
#-5.06393	8.93607	   0.40625	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_26 
#-5.06393	8.93607	  0.433333	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_27 
#-5.06393	8.93607	  0.460417	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_28 
#-5.06393	8.93607	    0.4875	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_29 
#-5.06393	8.93607	  0.514583	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_30 
#-5.06393	8.93607	  0.541667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_31 
#-5.06393	8.93607	   0.56875	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_32 
#-5.06393	8.93607	  0.595833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_33 
#-5.06393	8.93607	  0.622917	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_34 
#-5.06393	8.93607	      0.65	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_35 
#-5.06393	8.93607	      0.65	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_36 
#-5.06393	8.93607	  0.622917	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_37 
#-5.06393	8.93607	  0.595833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_38 
#-5.06393	8.93607	   0.56875	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_39 
#-5.06393	8.93607	  0.541667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_40 
#-5.06393	8.93607	  0.514583	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_41 
#-5.06393	8.93607	    0.4875	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_42 
#-5.06393	8.93607	  0.460417	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_43 
#-5.06393	8.93607	  0.433333	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_44 
#-5.06393	8.93607	   0.40625	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_45 
#-5.06393	8.93607	  0.379167	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_46 
#-5.06393	8.93607	  0.352083	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_47 
#-5.06393	8.93607	     0.325	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_48 
#-5.06393	8.93607	  0.297917	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_49 
#-5.06393	8.93607	  0.270833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_50 
#-5.06393	8.93607	   0.24375	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_51 
#-5.06393	8.93607	  0.216667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_52 
#-5.06393	8.93607	  0.189583	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_53 
#-5.06393	8.93607	    0.1625	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_54 
#-5.06393	8.93607	  0.135417	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_55 
#-5.06393	8.93607	  0.108333	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_56 
#-5.06393	8.93607	   0.08125	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_57 
#-5.06393	8.93607	 0.0541667	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_58 
#-5.06393	8.93607	 0.0270833	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_59 
#-5.06393	8.93607	         0	0	3.5	6	4	#_AgeSel_P_9_FISHERY(1)_BLK1add_60 
#-5.04076	8.95924	         0	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_11
#-5.04076	8.95924	 0.0604167	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_12
#-5.04076	8.95924	  0.120833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_13
#-5.04076	8.95924	   0.18125	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_14
#-5.04076	8.95924	  0.241667	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_15
#-5.04076	8.95924	  0.302083	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_16
#-5.04076	8.95924	    0.3625	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_17
#-5.04076	8.95924	  0.422917	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_18
#-5.04076	8.95924	  0.483333	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_19
#-5.04076	8.95924	   0.54375	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_20
#-5.04076	8.95924	  0.604167	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_21
#-5.04076	8.95924	  0.664583	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_22
#-5.04076	8.95924	     0.725	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_23
#-5.04076	8.95924	  0.785417	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_24
#-5.04076	8.95924	  0.845833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_25
#-5.04076	8.95924	   0.90625	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_26
#-5.04076	8.95924	  0.966667	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_27
#-5.04076	8.95924	   1.02708	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_28
#-5.04076	8.95924	    1.0875	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_29
#-5.04076	8.95924	   1.14792	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_30
#-5.04076	8.95924	   1.20833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_31
#-5.04076	8.95924	   1.26875	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_32
#-5.04076	8.95924	   1.32917	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_33
#-5.04076	8.95924	   1.38958	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_34
#-5.04076	8.95924	      1.45	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_35
#-5.04076	8.95924	      1.45	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_36
#-5.04076	8.95924	   1.38958	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_37
#-5.04076	8.95924	   1.32917	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_38
#-5.04076	8.95924	   1.26875	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_39
#-5.04076	8.95924	   1.20833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_40
#-5.04076	8.95924	   1.14792	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_41
#-5.04076	8.95924	    1.0875	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_42
#-5.04076	8.95924	   1.02708	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_43
#-5.04076	8.95924	  0.966667	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_44
#-5.04076	8.95924	   0.90625	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_45
#-5.04076	8.95924	  0.845833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_46
#-5.04076	8.95924	  0.785417	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_47
#-5.04076	8.95924	     0.725	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_48
#-5.04076	8.95924	  0.664583	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_49
#-5.04076	8.95924	  0.604167	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_50
#-5.04076	8.95924	   0.54375	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_51
#-5.04076	8.95924	  0.483333	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_52
#-5.04076	8.95924	  0.422917	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_53
#-5.04076	8.95924	    0.3625	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_54
#-5.04076	8.95924	  0.302083	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_55
#-5.04076	8.95924	  0.241667	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_56
#-5.04076	8.95924	   0.18125	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_57
#-5.04076	8.95924	  0.120833	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_58
#-5.04076	8.95924	 0.0604167	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_59
#-5.04076	8.95924	         0	0	3.5	6	4	#_AgeSel_P_10_FISHERY(1)_BLK1add_60
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
