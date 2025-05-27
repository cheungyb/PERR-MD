** Simulation to evaluate bias in PERR in the presence of differential mortality/dropout
** First scenario replicates Uddin et al (2015)
** Other scenarios consider alternative patterns
** Uddin_Program.ado

clear 
set more off

capture program drop PERR_Uddin_Program
program define PERR_Uddin_Program, rclass

version 15.1
 syntax [, n(integer 100000) beta(real 2.0) bm0(real -2.5) bmc(real 4.0) bmx(real 1.5)  bmy(real 1.2) ]

drop _all
set obs `n'
 
gen c1 = rbinomial(1,0.25)

gen p_y1 = exp(-1+log(2)*c1)
gen y1 = rbinomial(1,p_y1)

gen c2 = c1
gen p_x0 = exp(-1.5)
*20% exposure at baseline

gen p_x = exp(-1.5+log(1.5)*c1+log(2)*c2)
gen x = rbinomial(1,p_x)

gen p_y2 = exp(-2+log(2)*c2+log(`beta')*x)

gen y2 = rbinomial(1,p_y2)

gen p_m2 = exp(`bm0'+log(`bmc')*c2+log(`bmx')*x+log(`bmy')*y1)

gen m2 = rbinomial(1,p_m2)

if(`bm0'==-99) replace m2 = 0

count if m2==1
return scalar mortality= r(N)/_N

count if x==1
return scalar exposure= r(N)/_N

cs y2 x if m2==0
scalar cRRm = r(rr)

cs y1 x 
scalar cRR1 = r(rr)

cs y1 x if m2==0
scalar cRR1m = r(rr)

return scalar cRR= cRRm
return scalar PERR_U= cRRm/cRR1
return scalar PERR_C= cRRm/cRR1m

eret clear

end


	