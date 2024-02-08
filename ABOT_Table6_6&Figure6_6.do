//Armstrong, Barnes, O'Brien and Taylor-Robinson
//Created by Tiffany Barnes
//Appendix Table 6.6 & Figure 6.6  

clear


//bring in data
	
	gen changeXunified = corr_change*unified

	
	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag      pwc  presidential if unified==1 &  accountability ==1	
	logit femaleminister corr_change date  gdppercapita_lag loggdp_lag      pwc  presidential if unified==0 &  accountability ==1	
	logit femaleminister corr_change date gdppercapita_lag loggdp_lag    pwc unified presidential  changeXunified if  accountability==1  




****************************************
**Unified vs. Divided
****************************************
	
capture drop closeL closeH close closex res*
estsimp  logit femaleminister corr_change date gdppercapita_lag loggdp_lag    pwc unified presidential  changeXunified if  accountability==1   , genname(res) sims(1000)


set type double 
	generate closeL=.
	generate closeH=.
	generate close=.
	generate closex=.

	setx mean
	setx presidential 0
	

********************
//Unified//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace closex =`a' in `b'; 	
	setx corr_change `a'; 
	setx unified 1; 
	setx changeXunified `a'*1; 
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
			
		capture graph drop cor_change_unified 
 # delimit ;
twoway rarea closeL closeH closex , color(gs8) ||
 line close closex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Unified Government", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_unified) 
			xlab(-30(15)30)
			aspectratio(1)

 			;

			
 #delimit cr
	
	
	
		setx mean
	setx presidential 0
	setx unified 0
	

********************
//Divided//
********************
# delimit ;	
	local a =  -27;  
	local b = 1; 

# delimit ;
set more off;	
	while `a' <=27 {;
	replace closex =`a' in `b'; 	
	setx corr_change `a'; 
	setx unified 0; 
	setx changeXunified `a'*0; 
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
			
		capture graph drop cor_change_divided 
 # delimit ;
twoway rarea closeL closeH closex , color(gs8) ||
 line close closex, symbol(triangle) color(black) msize(small) ||
,
   			legend(order(- )

  			row(1) col(2)  symx(tiny) lwidth(0) size(small) colgap(vsmall) region(lwidth(none)))
  			xtitle("Increases in Corruption", size(medium))
  			ytitle("Pr(Woman)", size(small))
  			title("Divided Government", size(medium) color(black))
            graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(cor_change_divided) 
			xlab(-30(15)30)
			aspectratio(1)

 			;

			
 
 
 
  #delimit cr
 
 		capture graph drop unified 

 
  # delimit ;
 graph combine cor_change_unified cor_change_divided, ycommon
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			name(unified) 
 			;
  #delimit cr

  
  
		
		
		
	  # delimit ;
	    		capture graph drop unifiedX2;  

 graph combine unified unified, 
      graphregion(fcolor(white))
 			plotregion(fcolor(white))
 			graphregion(color(white))
			col(2)
			name(unifiedX2) 
			ycommon
 			;	
stop 			
			
			
