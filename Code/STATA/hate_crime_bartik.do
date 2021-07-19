// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\bartik.csv", clear
encode state, gen(nstate)
gen date = date(week, "YMD")
gen d = date(dates, "YMD") 
gen FB_ratio = total/population
gen ln_pop = ln(population)
sort state date

xtset nstate d

// first stage
xtreg state_reaction total_avg FB_ratio ln_pop i.date, fe robust

predict reaction, xb

// second stage
xtreg hate_crime reaction FB_ratio ln_pop i.date, fe robust
xtreg racial_crime reaction FB_ratio ln_pop i.date, fe robust
xtreg racial_broad_crime reaction FB_ratio ln_pop i.date, fe robust
