//Whole Data
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_racial_reg.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week

sort state_name week
//Summary Statistics
by state: gen lag1 = mean_diff[_n-1]
by state: gen pre1 = mean_diff[_n+1]
bysort state_name: egen crime_mean=mean(n)
bysort state_name: gen k=_n
sum crime_mean if k==1
sum crime_mean if k==1, detail
count if crime_mean >1 & n==0
tab n if crime_mean>1
tab state_name if crime_mean<1
tab n if crime_mean>0.7
tab state_name if crime_mean<0.7
gen cr= (n/population)*10000
bysort state_name: egen cr_mean=mean(cr)
tab n if cr_mean>0.0033
tab state_name if cr_mean <0.0033 
tab state_name if cr <0.0016 & k==1
tab n if cr_mean>0.0016
sum cr_mean if k==1, detail
gen ln_pop = ln(population)

translate @Results Summary2.txt


//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate, robust cluster(nstate)
poisson n mean_diff ln_pop i.ncandidate i.week i.nstate, robust cluster(nstate)
poisson n mean_diff population i.week i.nstate trump_ratio, robust cluster(nstate)
poisson n mean_diff ln_pop i.week i.nstate trump_ratio, robust cluster(nstate)
xtpoisson n mean_diff population i.ncandidate i.week posts, fe vce(robust)

poisson n lag1 population i.ncandidate i.week i.nstate, robust cluster(nstate)
poisson n lag1 ln_pop i.ncandidate i.week i.nstate, robust cluster(nstate)
poisson n lag1 population i.week i.nstate trump_ratio, robust cluster(nstate)
poisson n lag1 ln_pop i.week i.nstate trump_ratio, robust cluster(nstate)

poisson n mean_diff population i.ncandidate i.week i.nstate if crime_mean > 1, robust cluster(nstate) 
poisson n mean_diff population i.ncandidate i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)
poisson n mean_diff population trump_ratio i.week i.nstate if crime_mean > 1, robust cluster(nstate) 
poisson n mean_diff population trump_ratio i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)
poisson n mean_diff ln_pop i.ncandidate i.week i.nstate if crime_mean > 1, robust cluster(nstate) 
poisson n mean_diff ln_pop i.ncandidate i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)
poisson n mean_diff ln_pop trump_ratio i.week i.nstate if crime_mean > 1, robust cluster(nstate) 
poisson n mean_diff ln_pop trump_ratio i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)

poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate) 
poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)
poisson n mean_diff population trump_ratio i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate) 
poisson n mean_diff population trump_ratio i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)
poisson n mean_diff ln_pop i.ncandidate i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate) 
poisson n mean_diff ln_pop i.ncandidate i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)
poisson n mean_diff ln_pop trump_ratio i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate) 
poisson n mean_diff ln_pop trump_ratio i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)

poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate)
xtpoisson n mean_diff population i.ncandidate i.week if cr_mean > 0.0033, fe vce(robust) 
poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)
xtpoisson n mean_diff population i.ncandidate i.week if cr_mean > 0.0016, fe vce(robust) 

poisson n mean_diff population i.ncandidate i.week i.nstate if crime_mean < 1
xtpoisson n mean_diff population i.ncandidate i.week if crime_mean < 1, fe vce(robust) 
poisson n mean_diff population i.ncandidate i.week i.nstate if crime_mean < 0.7
xtpoisson n mean_diff population i.ncandidate i.week if crime_mean < 0.7, fe vce(robust) 

poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean < 0.0033
xtpoisson n mean_diff population i.ncandidate i.week if cr_mean < 0.0033, fe vce(robust) 
poisson n mean_diff population i.ncandidate i.week i.nstate if cr_mean < 0.0016
xtpoisson n mean_diff population i.ncandidate i.week if cr_mean < 0.0016, fe vce(robust) 

//OLS
reg n mean_diff population i.ncandidate i.week i.nstate, cluster(nstate) robust
xtreg n mean_diff population i.ncandidate i.week, fe robust
reg cr mean_diff i.ncandidate i.week i.nstate, cluster(nstate) robust

reg n mean_diff population i.ncandidate i.week i.nstate if crime_mean > 1, robust cluster(nstate)
reg n mean_diff population i.ncandidate i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)
reg n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate)
reg n mean_diff population i.ncandidate i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)

reg cr mean_diff i.ncandidate i.week i.nstate if crime_mean > 1, robust cluster(nstate)
reg cr mean_diff i.ncandidate i.week i.nstate if crime_mean > 0.7, robust cluster(nstate)
reg cr mean_diff i.ncandidate i.week i.nstate if cr_mean > 0.0033, robust cluster(nstate)
reg cr mean_diff i.ncandidate i.week i.nstate if cr_mean > 0.0016, robust cluster(nstate)


//Weighted OLS
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population]
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg cr mean_diff ln_pop i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg cr mean_diff population trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust
reg cr mean_diff ln_pop trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust

reg pre1 cr population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 cr ln_pop i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 cr population trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 cr ln_pop trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust

reg pre1 n population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 n ln_pop i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 n population trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust
reg pre1 n ln_pop trump_ratio i.week i.nstate [aweight = population], cluster(nstate) robust


reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust
reg cr mean_diff ln_pop i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust
reg cr mean_diff population trump_ratio i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust
reg cr mean_diff ln_pop trump_ratio i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust

reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust
reg cr mean_diff ln_pop i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust
reg cr mean_diff population trump_ratio i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust
reg cr mean_diff ln_pop trump_ratio i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust

reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust
reg cr mean_diff trump_ratio i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust
reg cr mean_diff ln_pop trump_ratio i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust

reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust
reg cr mean_diff ln_pop i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust
reg cr mean_diff population trump_ratio i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust
reg cr mean_diff ln_pop trump_ratio i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust


reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust


//Weighted OLS (crime rate)
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population]
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 1, cluster(nstate) robust
reg cr mean_diff population i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if crime_mean > 0.7, cluster(nstate) robust
reg cr mean_diff population i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0033, cluster(nstate) robust
reg cr mean_diff i.ncandidate i.week i.nstate [aweight = population] if cr_mean > 0.0016, cluster(nstate) robust

translate @Results Reg_whole.txt

//Poisson Model with last
poisson n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1
xtpoisson n mean_diff mean_diff_last population i.ncandidate i.week if week > 1, fe vce(robust)

//OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1, cluster(nstate) robust
xtreg n mean_diff mean_diff_last i.ncandidate i.year#i.month_year if week > 1, fe robust

//Weighted OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate [aweight = population] if week > 1, cluster(nstate) robust

//Weighted OLS with last (crime rate)
reg crime_rate mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1 [aweight = population], cluster(nstate) robust

translate @Results Reg_whole_last.txt

clear 

//

//Crime posts
//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate, robust cluster(nstate)
xtpoisson n mean_diff population i.ncandidate i.week, fe vce(robust)
//
//Racial Data
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_racial_reg.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week

//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate
xtpoisson n mean_diff population i.ncandidate i.week, fe vce(robust)

//OLS
reg n mean_diff population i.ncandidate i.week i.nstate
xtreg n mean_diff population i.ncandidate i.week, fe robust

//Weighted OLS
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population]
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust


//Weighted OLS (crime rate)
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population]
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_racial.txt

cls

//Poisson Model with last
poisson n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1
xtpoisson n mean_diff mean_diff_last population i.ncandidate i.week if week > 1, fe vce(robust)

//OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1, cluster(nstate) robust
xtreg n mean_diff mean_diff_last i.ncandidate i.year#i.month_year if week > 1, fe robust

//Weighted OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate [aweight = population] if week > 1, cluster(nstate) robust

//Weighted OLS with last (crime rate)
reg crime_rate mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1 [aweight = population], cluster(nstate) robust

translate @Results Reg_racial_last.txt

clear
cls

//
//
//Whole Data filtering out states with maximum < 5
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_reg_state.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week

//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate
xtpoisson n mean_diff population i.ncandidate i.week, fe vce(robust)

//OLS
reg n mean_diff population i.ncandidate i.week i.nstate
xtreg n mean_diff population i.ncandidate i.week, fe robust

//Weighted OLS
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population]
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust


//Weighted OLS (crime rate)
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population]
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_state.txt

cls

//Poisson Model with last
poisson n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1
xtpoisson n mean_diff mean_diff_last population i.ncandidate i.week if week > 1, fe vce(robust)

//OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1, cluster(nstate) robust
xtreg n mean_diff mean_diff_last i.ncandidate i.year#i.month_year if week > 1, fe robust

//Weighted OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate [aweight = population] if week > 1, cluster(nstate) robust

//Weighted OLS with last (crime rate)
reg crime_rate mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1 [aweight = population], cluster(nstate) robust

translate @Results Reg_state_last.txt

clear
cls
//
//
//Racial Data filtering out states with maximum < 5
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_racial_reg_state.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week

//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate
xtpoisson n mean_diff population i.ncandidate i.week, fe vce(robust)

//OLS
reg n mean_diff population i.ncandidate i.week i.nstate
xtreg n mean_diff population i.ncandidate i.week, fe robust

//Weighted OLS
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population]
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust


//Weighted OLS (crime rate)
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population]
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_racial_state.txt

cls

//Poisson Model with last
poisson n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1
xtpoisson n mean_diff mean_diff_last population i.ncandidate i.week if week > 1, fe vce(robust)

//OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1, cluster(nstate) robust
xtreg n mean_diff mean_diff_last i.ncandidate i.year#i.month_year if week > 1, fe robust

//Weighted OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate [aweight = population] if week > 1, cluster(nstate) robust

//Weighted OLS with last (crime rate)
reg crime_rate mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1 [aweight = population], cluster(nstate) robust

translate @Results Reg__racial_state_last.txt

clear
cls
//
//
//Whole Data filtering out states with maximum >= 5
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_reg_low.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week

//Poisson Model
poisson n mean_diff population i.ncandidate i.week i.nstate
xtpoisson n mean_diff population i.ncandidate i.week, fe vce(robust)

//OLS
reg n mean_diff population i.ncandidate i.week i.nstate
xtreg n mean_diff population i.ncandidate i.week, fe robust

//Weighted OLS
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population]
reg n mean_diff population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust


//Weighted OLS (crime rate)
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population]
reg crime_rate mean_diff i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_whole_low.txt
cls

//Poisson Model with last
poisson n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1
xtpoisson n mean_diff mean_diff_last population i.ncandidate i.week if week > 1, fe vce(robust)

//OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1, cluster(nstate) robust
xtreg n mean_diff mean_diff_last i.ncandidate i.year#i.month_year if week > 1, fe robust

//Weighted OLS with last
reg n mean_diff mean_diff_last population i.ncandidate i.week i.nstate [aweight = population] if week > 1, cluster(nstate) robust

//Weighted OLS with last (crime rate)
reg crime_rate mean_diff mean_diff_last population i.ncandidate i.week i.nstate if week > 1 [aweight = population], cluster(nstate) robust

translate @Results Reg_whole_last_low.txt

clear
cls
//
//
//Whole Data reverse
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_reg.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week
 
//OLS
reg mean_diff n population i.ncandidate i.week i.nstate
xtreg mean_diff n population i.ncandidate i.week, fe robust

//Weighted OLS
reg mean_diff n population i.ncandidate i.week i.nstate [aweight = population]
reg mean_diff n population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

//Weighted OLS (crime rate)
reg mean_diff crime_rate i.ncandidate i.week i.nstate [aweight = population]
reg mean_diff crime_rate i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_whole_reverse.txt

clear
cls
//
//
//Whole Data filtering out states with maximum < 5
cd"/Users/penny/Desktop/"
import delimited "/Users/penny/Desktop/hatecrime_reg_state.csv", encoding(ISO-8859-1)
encode state_name, gen(nstate)
encode candidate, gen(ncandidate)
gen crime = n > 0
xtset nstate week
 
//OLS
reg mean_diff n population i.ncandidate i.week i.nstate
xtreg mean_diff n population i.ncandidate i.week, fe robust
reg mean_diff crime_rate i.ncandidate i.week i.nstate
xtreg mean_diff crime_rate population i.ncandidate i.week, fe robust


//Weighted OLS
reg mean_diff n population i.ncandidate i.week i.nstate [aweight = population]
reg mean_diff n population i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

//Weighted OLS (crime rate)
reg mean_diff crime_rate i.ncandidate i.week i.nstate [aweight = population]
reg mean_diff crime_rate i.ncandidate i.week i.nstate [aweight = population], cluster(nstate) robust

translate @Results Reg_whole_reverse.txt

clear
cls
