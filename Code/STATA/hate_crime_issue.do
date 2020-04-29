// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\immigration_race_regression.csv"
encode state, gen(nstate)
gen crime_indicator = hate_crime > 0
gen date = date(week, "YMD")
format date %td
xtset nstate date, delta(7)
sort state date
gen hate_cr = hate_crime_rate * 10000

//Summary Statistics
//Calculate state-level mean
bysort state: egen crime_mean=mean(hate_crime)
bysort state: egen crime_rate_mean=mean(hate_crime_rate)
bysort state: gen k=[_n]
bysort state: egen no_crime=sum(crime_indicator)
gen no_crime_rate=no_crime/82

//State-level mean statistics
sum crime_mean if k==1, detail
sum crime_rate_mean if k==1, detail
count if crime_mean > 0.7 & k==1
sum no_crime if k==1, detail
tab no_crime if k==1 
tab state if no_crime < 30

//Heterogeneity of state-level mean
tab hate_crime if crime_mean > 0.7
sum hate_crime if crime_mean > 0.7
tab hate_crime_rate if crime_mean > 0.7
sum hate_crime_rate if crime_mean > 0.7
twoway scatter hate_crime nstate, msymbol(circle_hollow) || connected crime_mean nstate, msymbol(diamond)

//Calculate week-level mean
bysort week: egen crime_mean_week=mean(hate_crime)
bysort week: egen crime_rate_mean_week=mean(hate_crime_rate)
bysort week: gen week_k=[_n]

//State-level mean statistics
sum crime_mean if k==1, detail
sum crime_rate_mean if k==1, detail
count if crime_mean > 0.7 & k==1
sum no_crime if k==1, detail
tab no_crime if k==1 
tab state if no_crime < 30

//Heterogeneity of state-level mean
tab hate_crime if crime_mean > 0.7
sum hate_crime if crime_mean > 0.7
tab hate_crime_rate if crime_mean > 0.7
sum hate_crime_rate if crime_mean > 0.7
twoway scatter hate_crime date, msymbol(circle_hollow) || connected crime_mean_week date, msymbol(diamond)

//Generate lag variable
by state: gen user_amount_lag1 = related_user_amount[_n-1]
by state: gen user_amount_pre1 = related_user_amount[_n+1]
by state: gen user_ratio_lag1 = related_user_ratio[_n-1]
by state: gen user_ratio_pre1 = related_user_ratio[_n+1]

//Generate log variable
gen ln_pop = ln(population)
gen ln_user_amt = ln(related_user_amount)
gen ln_user_ratio = ln(related_user_ratio)
gen ln_user_amt_lag1 = ln(user_amount_lag1)
gen ln_user_amt_pre1 = ln(user_amount_pre1)
gen ln_user_ratio_lag1 = ln(user_ratio_lag1)
gen ln_user_ratio_pre1 = ln(user_ratio_pre1)
gen ln_hate_cr = ln(hate_cr)
















































