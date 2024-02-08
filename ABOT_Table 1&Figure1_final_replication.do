
//Armstrong, Barnes, O'Brien and Taylor-Robinson
//Created by Tiffany Barnes
//Results in Main Text
clear


//bring in data

//generate interaction terms
gen changeXacc = corr_change*accountability
gen changeXpres = corr_change*presidential

	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential   accountability 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential if  accountability==1 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc   if  accountability==0 	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential   accountability changeXacc 
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc       if  accountability==1 & presidential==1
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc       if  accountability==1 & presidential==0
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential  changeXpres   if  accountability==1 
	
	
	
	

//Estimate model so I can get some descriptive stats based on model sample. 
logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential   accountability 	

//Summarize corruption variable to find a 1 SD increase/decrease 
sum corr_change if e(sample), d 
sum femaleminister if e(sample), d 


//estimate full sample model with estsimp to calculate the change in predicted probability when we move from 1 SD below teh mean to 1 SD above mean. 
//this value is reported in first paragraph of results section.	
capture drop res*
estsimp  logit femaleminister corr_change date  gdppercapita_lag loggdp_lag  unified    pwc  presidential   accountability 	
	
	//set all values to mean or mode. 
	setx mean
	setx presidential 1
	setx accountability 1 
	setx unified 0
	simqi, fd(prval(1)) changex(corr_change -7.202213 5.005153 ) level(95)

	
	setx mean
	setx presidential 1
	setx accountability 1 
	setx unified 0
	
	setx corr_change -7.202213
	simqi,  prval(1) 
		
	setx corr_change 5.005153
	simqi,  prval(1) 


	
//estimate full sample model with estsimp to calculate the change in predicted probability when we move from 1 SD below teh mean to 1 SD above mean. 
//this value is reported in the 3rd paragraph of results section; it is the results for the full sample comparing countries w/ & w/o free & fair elecitons. 	
capture drop closeL closeH close closex res*
estsimp  logit femaleminister corr_change date gdppercapita_lag loggdp_lag unified   pwc  presidential   accountability changeXacc , genname(res) sims(1000)


	setx mean
	setx presidential 1
	setx unified 0
	
	simqi, fd(prval(1)) changex(corr_change -7.202213 5.005153   accountability 0 0  changeXacc 0 0 ) level(95)
	
	simqi, fd(prval(1)) changex(corr_change -7.202213 5.005153   accountability 1 1  changeXacc -7.202213 5.005153  ) level(95)

	
	setx mean
	setx presidential 1
	setx accountability 1
	setx unified 0
	setx corr_change -7.202213
	setx changeXacc -7.202213
	simqi,  prval(1) 
	
	
	setx mean
	setx presidential 1
	setx accountability 1
	setx unified 0	
	setx corr_change 5.005153	 
	setx changeXacc 5.005153
	simqi,  prval(1) 

	
	
	
set type double 
	generate closeL=.
	generate closeH=.
	generate close=.
	generate closex=.

	setx mean
	setx presidential 1
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
			aspectratio(1)
 			;

			
 #delimit cr
	
	
	
	
		set type double 
	generate AcloseL=.
	generate AcloseH=.
	generate Aclose=.
	generate Aclosex=.
	
	
	setx mean
	setx presidential 1
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
			aspectratio(1)


 			;

			
 #delimit cr

****************************************
**Presidential vs. Parliamentary
****************************************
	
//summarize data for footnote 4	
logit femaleminister corr_change date gdppercapita_lag loggdp_lag unified   pwc  presidential  changeXpres   if  accountability==1	

sum corr_change if presidential==1 & e(sample)==1
sum corr_change if presidential==0 & e(sample)==1
	
	
//estimate full sample model with estsimp to calculate the change in predicted probability when we move from 1 SD below teh mean to 1 SD above mean. 
//this value is reported in the 5th paragraph of results section; it is the results for the free&fair election sample. 
capture drop closeL closeH close closex 
capture drop res*
estsimp  logit femaleminister corr_change date gdppercapita_lag loggdp_lag unified   pwc  presidential  changeXpres   if  accountability==1  , genname(res) sims(1000)




	setx mean
	setx unified 0 
	


	//from mean to 1sd above mean 
		simqi, fd(prval(1)) changex(corr_change -7.209892 5.005153 presidential 0 0  changeXpres 0 0 )  level(95)
		simqi, fd(prval(1)) changex(corr_change -7.209892 5.005153  presidential 1 1  changeXpres -7.209892 5.005153 )  level(95)

		
		setx mean
		setx unified 0

	setx corr_change -7.209892
	setx changeXpres -7.209892
	setx presidential 1
		simqi,  prval(1) 
	
	
	setx mean
	setx unified 0

	setx corr_change 5.005153	 
	setx changeXpres 5.005153
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
