
//Armstrong, Barnes, O'Brien and Taylor-Robinson
//Created by Tiffany Barnes
//Appendix Table & Figure 2

clear


//bring in data

//generate interaction terms
gen changeXacc = corr_change*accountability
gen changeXpres = corr_change*presidential


********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************


//USE THIS////

logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc presidential   accountability       	
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc presidential  if  accountability  ==1  
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc  if  accountability  ==0      
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc presidential   accountability changeXacc      	
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc if  accountability==1 & presidential==1
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc if  accountability==1 & presidential==0
logit new_appointment2 corr_change date  gdppercapita_lag loggdp_lag  unified pwc presidential  changeXpres if accountability==1    



	

capture drop closeL closeH close closex 
capture drop res*
estsimp  logit new_appointment2 corr_change date  loggdp_lag unified   pwc  presidential   accountability changeXacc , genname(res) sims(1000)

	
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
estsimp  logit new_appointment2 corr_change date  loggdp_lag unified   pwc  presidential  changeXpres   if  accountability==1  , genname(res) sims(1000)



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
