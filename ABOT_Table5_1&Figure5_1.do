//Armstrong, Barnes, O'Brien and Taylor-Robinson
//Created by Tiffany Barnes
//Appendix Table 5.5 & Figure 5.1 
clear


//bring in data

gen changeXacc = corr_change*accountability
gen changeXpres = corr_change*presidential


	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag  presidential   accountability 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag  presidential if  accountability==1 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag   if  accountability==0 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag  presidential   accountability changeXacc 
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag       if  accountability==1 & presidential==1
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag       if  accountability==1 & presidential==0
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc_lag  presidential  changeXpres   if  accountability==1 
	

	
	
capture drop closeL closeH close closex res*
estsimp  logit femaleminister corr_change date  gdppercapita_lag loggdp_lag   unified   womenrep_lag  presidential   accountability 	
	
	setx mean
	setx presidential 1
	setx accountability 1 
	setx unified 0
	simqi, fd(prval(1)) changex(corr_change -7.23 4.909 ) level(90)
	
	
	setx mean
	setx presidential 1
	setx accountability 1 
	setx unified 0
	simqi,  prval(1) genpr (wom_mean)
	
	setx corr_change -7.23
	simqi,  prval(1) genpr (wom_sd1l)

		
	setx corr_change 4.909
	simqi,  prval(1) genpr (wom_sd1h)

	
capture drop closeL closeH close closex res*
estsimp  logit femaleminister corr_change date  loggdp_lag unified   womenrep_lag  presidential   accountability changeXacc , genname(res) sims(1000)


	setx mean
	setx presidential 1
	setx unified 0
	
	//in autocracies moving from 0 to -8 //becoming cleaner 
	simqi, fd(prval(1)) changex(corr_change -7.23 4.909  accountability 0 0  changeXacc 0 0 ) level(90)
	
	
	
	simqi, fd(prval(1)) changex(corr_change -7.23 4.909  accountability 1 1  changeXacc -7.23 4.909 ) level(95)

	
		setx mean
	setx presidential 1
	setx accountability 1
	setx unified 0
	setx corr_change -7.23
	setx changeXacc -7.23
	simqi,  prval(1) 
	
	
			setx mean
	setx presidential 1
	setx accountability 1
	setx unified 0	
	setx corr_change 4.909	 
	setx changeXacc 4.909
	simqi,  prval(1) 

	
	
	
set type double 
	generate closeL=.
	generate closeH=.
	generate close=.
	generate closex=.

	setx mean
	setx presidential 0
	setx unified 0

********************
//Democracies//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace closex =`a' in `b'; 	
	setx corr_change `a'; 
	setx accountability 1; 
	setx changeXacc `a'*1; 
	quietly simqi, prval(1) genpr (pi);	
	_pctile pi, p(8 , 92);     
	replace closeL = r(r1) in `b';	
	replace closeH = r(r2) in `b';
	summarize pi;			
	replace close = r(mean) in `b';
	drop pi;	
	local a = `a' + 1;		
	local b = `b' + 1;			
	};	
 #delimit cr




*******************************
*Graph
*******************************
			
		capture graph drop cor_change_dem 
 # delimit ;
twoway rarea closeL closeH closex , color(gs8) ||
 line close closex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Free & Fair Elections", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_dem) 
			xlab(-30(15)30)
			ylab(0(.1).3)
			aspectratio(1)
 			;

			
 #delimit cr
	
	
	
	
		set type double 
	generate AcloseL=.
	generate AcloseH=.
	generate Aclose=.
	generate Aclosex=.
	
	
	setx mean
	setx presidential 0
	setx unified 0


********************
//Autocracies//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace Aclosex =`a' in `b'; 	
	setx corr_change `a'; 
	setx accountability 0; 
	setx changeXacc `a'*0; 
	quietly simqi, prval(1) genpr (pi);	
	_pctile pi, p(8 , 92);     
	replace AcloseL = r(r1) in `b';	
	replace AcloseH = r(r2) in `b';
	summarize pi;			
	replace Aclose = r(mean) in `b';
	drop pi;	
	local a = `a' + 1;		
	local b = `b' + 1;			
	};	
 #delimit cr




*******************************
*Graph
*******************************
			
		capture graph drop cor_change_aut 
 # delimit ;
twoway rarea AcloseL AcloseH Aclosex , color(gs8) ||
 line Aclose Aclosex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Not Free & Fair", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_aut) 
			xlab(-30(15)30)
			ylab(0(.1).3)
			aspectratio(1)


 			;

			
 #delimit cr

****************************************
**Presidential vs. Parliamentary
****************************************
	
capture drop closeL closeH close closex 
capture drop res*
estsimp  logit femaleminister corr_change date  loggdp_lag unified   womenrep_lag  presidential  changeXpres   if  accountability==1  , genname(res) sims(1000)


	setx mean
	setx unified 0 
	


	//from mean to 1sd above mean 
		simqi, fd(prval(1)) changex(corr_change -7.23 4.909 presidential 0 0  changeXpres 0 0 )  level(90)
		simqi, fd(prval(1)) changex(corr_change -7.23 4.909  presidential 1 1  changeXpres -7.23 4.909 )  level(90)

		
		setx mean
		setx unified 0

	setx corr_change -7.23
	setx changeXpres -7.23
	setx presidential 1
		simqi,  prval(1) 
	
	
	setx mean
	setx unified 0

	setx corr_change 4.909	 
	setx changeXpres 4.909
	setx presidential 1
		simqi,  prval(1) 
	


set type double 
	generate closeL=.
	generate closeH=.
	generate close=.
	generate closex=.

	setx mean
	setx unified 0
	

********************
//Presidential//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace closex =`a' in `b'; 	
	setx corr_change `a'; 
	setx presidential 1; 
	setx changeXpres `a'*1; 
	quietly simqi, prval(1) genpr (pi);	
	_pctile pi, p(8 , 92);     
	replace closeL = r(r1) in `b';	
	replace closeH = r(r2) in `b';
	summarize pi;			
	replace close = r(mean) in `b';
	drop pi;	
	local a = `a' + 1;		
	local b = `b' + 1;			
	};	
 #delimit cr




*******************************
*Graph
*******************************
			
		capture graph drop cor_change_pres 
 # delimit ;
twoway rarea closeL closeH closex , color(gs8) ||
 line close closex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Presidential", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_pres) 
			xlab(-30(15)30)
			aspectratio(1)

 			;

			
 #delimit cr
	
	
	
		setx mean
	setx presidential 0
	setx unified 0
	

********************
//Parliamentary//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace closex =`a' in `b'; 	
	setx corr_change `a'; 
	setx presidential 0; 
	setx changeXpres `a'*0; 
	quietly simqi, prval(1) genpr (pi);	
	_pctile pi, p(8 , 92);     
	replace closeL = r(r1) in `b';	
	replace closeH = r(r2) in `b';
	summarize pi;			
	replace close = r(mean) in `b';
	drop pi;	
	local a = `a' + 1;		
	local b = `b' + 1;			
	};	
 #delimit cr




*******************************
*Graph
*******************************
			
		capture graph drop cor_change_par 
 # delimit ;
twoway rarea closeL closeH closex , color(gs8) ||
 line close closex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Parliamentary", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_par) 
			xlab(-30(15)30)
			aspectratio(1)

 			;

			
 
 
 
  #delimit cr
 
 		capture graph drop accountability 

 
  # delimit ;
 graph combine cor_change_dem cor_change_aut, ycommon
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(accountability) 
 			;
  #delimit cr

  
  
 #delimit cr
 
  		capture graph drop presidential 

  # delimit ;
 graph combine cor_change_pres cor_change_par, ycommon
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(presidential) 
 			;
 
		

		
		
		
	  # delimit ;
	    		capture graph drop All_results;  

 graph combine accountability presidential, 
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			col(2)
			name(All_results) 
			ycommon
 			;	
stop 			
			
			
				  # delimit ;
	    		capture graph drop All_results;  

 graph combine cor_change_dem cor_change_aut cor_change_pres cor_change_par, 
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			col(4)
			name(All_results) 
			ycommon
 			;	
