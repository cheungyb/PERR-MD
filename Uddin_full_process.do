** Simulation to evaluate bias in PERR in the presence of differential mortality/dropout
** First scenario replicates Uddin et al (2015)
** Other scenarios consider alternative patterns
** call Uddin_Program.ado
  
clear 
set more off
version 15.1
capture log close

cd "C:\Users\Stat\PERR\Uddin"

log using SimResults,replace text

run Uddin_Program.ado

global reps=10000

*********************************************
** M2 follows a Bernoulli distribution with parameter p_M2 determined by C2, X and Y1

disp c(current_time) "  " c(current_date)

foreach a in -2.49 -2.78 -3.18 -3.88 -99 {

simulate,reps($reps) seed(20250509) nodots: ///
	PERR_Uddin_Program, bm0(`a')
su

qui su mortality
gen rate = round(r(mean),0.01)

foreach x in cRR PERR_U PERR_C   {

	_pctile `x', p(2.5 97.5)
	gen p25_`x'=r(r1)
	gen p975_`x'=r(r2)
}

disp c(current_time) "  " c(current_date)

}

*********************************************
** M2 follows a Bernoulli distribution with parameter p_M2 determined by C2 and Y1
disp c(current_time) "  " c(current_date)

foreach a in -2.27 -2.57 -2.95 -3.65 -99 {

simulate,reps($reps) seed(20250509) nodots: ///
	PERR_Uddin_Program, bm0(`a') bmx(1.0)
su

qui su mortality
gen rate = round(r(mean),0.01)

foreach x in cRR PERR_U PERR_C   {

	_pctile `x', p(2.5 97.5)
	gen p25_`x'=r(r1)
	gen p975_`x'=r(r2)
}

disp c(current_time) "  " c(current_date)

}

*********************************************
** M2 follows a Bernoulli distribution with parameter p_M2 determined by C2 and X
disp c(current_time) "  " c(current_date)

foreach a in -2.38 -2.68 -3.08 -3.78 -99 {

simulate,reps($reps) seed(20250509) nodots: ///
	PERR_Uddin_Program, bm0(`a') bmy(1.0)
su

qui su mortality
gen rate = round(r(mean),0.01)

foreach x in cRR PERR_U PERR_C   {

	_pctile `x', p(2.5 97.5)
	gen p25_`x'=r(r1)
	gen p975_`x'=r(r2)
}

disp c(current_time) "  " c(current_date)

}


*********************************************
** M2 follows a Bernoulli distribution with parameter p_M2 determined by C2 alone

disp c(current_time) "  " c(current_date)

foreach a in -2.16 -2.45 -2.85 -3.55 -99 {

simulate,reps($reps) seed(20250509) nodots: ///
	PERR_Uddin_Program, bm0(`a') bmx(1.0) bmy(1.0)
su

qui su mortality
gen rate = round(r(mean),0.01)

foreach x in cRR PERR_U PERR_C   {

	_pctile `x', p(2.5 97.5)
	gen p25_`x'=r(r1)
	gen p975_`x'=r(r2)
}

disp c(current_time) "  " c(current_date)

}

*********************************************
*the end! 

log close
