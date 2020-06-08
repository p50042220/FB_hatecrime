// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\immigration_race_regression_with_ideology.csv", clear
encode state, gen(nstate)
gen crime_indicator = hate_crime > 0
gen racial_crime_indicator = racial_crime > 0
gen racial_broad_crime_indicator = racial_broad_crime > 0
gen date = date(week, "YMD")
format date %td
sort state date
gen hate_cr = hate_crime_rate * 10000
gen user_total = round(related_user_amount/related_user_ratio)
gen FB_ratio = user_total/population
gen reaction_post_ratio = related_reaction_amount/related_post_amount

//Summary Statistics
//Calculate state-level mean
bysort state: egen crime_mean_state = mean(hate_crime)
bysort state: egen crime_rate_mean_state = mean(hate_cr)
bysort state: gen k = [_n]
bysort state: egen crime_times = sum(crime_indicator)
bysort state: egen racial_crime_times = sum(racial_crime_indicator)
bysort state: egen racial_broad_crime_times = sum(racial_broad_crime_indicator)

//Visualization
twoway scatter hate_crime nstate, msymbol(circle_hollow) || connected crime_mean_state nstate, msymbol(diamond)
twoway scatter hate_cr nstate, msymbol(circle_hollow) || connected crime_rate_mean_state nstate, msymbol(diamond)
twoway connected no_crime_times nstate, msymbol(diamond) || connected crime_mean_state nstate, msymbol(diamond)

//State-level mean statistics
sum crime_mean if k==1, detail
sum crime_rate_mean if k==1, detail
count if crime_mean > 0.7 & k==1
sum crime_times if k==1, detail
tab crime_times if k==1 
tab state if crime_times > 30

//Heterogeneity of state-level mean
tab hate_crime if crime_mean > 0.7
sum hate_crime if crime_mean > 0.7
tab hate_crime_rate if crime_mean > 0.7
sum hate_crime_rate if crime_mean > 0.7
twoway scatter hate_crime nstate, msymbol(circle_hollow) || connected crime_mean nstate, msymbol(diamond)

//Generate log variable
gen ln_pop = ln(population)
gen ln_user_amt = ln(related_user_amount)
gen ln_user_ratio = ln(related_user_ratio)
gen ln_hate_cr = ln(hate_cr)
gen ln_user_total = ln(user_total)
gen ln_FB_ratio = ln(FB_ratio)
gen ln_reaction_amt = ln(related_reaction_amount)
gen ln_post_amt = ln(related_post_amount)
gen ln_reaction_post_ratio = ln(reaction_post_ratio)

//Generate Candidate Indicator
gen Trump = 0
replace Trump = 1 if trump_share > 0.5
tabstat hate_crime, by(Trump) s(mean median min max N)
tab state if Trump == 1
tab week if Trump == 1 & state == "California"

xtset nstate date, delta(7)

// User Amount Regression
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount.log"
foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' related_user_amount i.date population user_total, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' ln_user_amt i.date population user_total, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio, fe robust
	
}
log close

// Reaction Amount
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount.log", replace
foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total related_post_amount, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio related_post_amount, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total related_post_amount, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio related_post_amount, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio related_post_amount, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total ln_post_amt, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio ln_post_amt, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total ln_post_amt, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio ln_post_amt, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' ln_reaction_post_ratio i.date population user_total, fe robust
	xtreg `var' ln_reaction_post_ratio i.date population FB_ratio, fe robust
	xtreg `var' ln_reaction_post_ratio i.date ln_pop ln_user_total, fe robust
	xtreg `var' ln_reaction_post_ratio i.date ln_pop FB_ratio, fe robust
	xtreg `var' ln_reaction_post_ratio i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime sexual_crime{
	
	xtreg `var' reaction_post_ratio i.date population user_total, fe robust
	xtreg `var' reaction_post_ratio i.date population FB_ratio, fe robust
	xtreg `var' reaction_post_ratio i.date ln_pop ln_user_total, fe robust
	xtreg `var' reaction_post_ratio i.date ln_pop FB_ratio, fe robust
	xtreg `var' reaction_post_ratio i.date ln_pop ln_FB_ratio, fe robust
	
}
log close

// User Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_lag.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio, fe robust
	
}
log close
// Reaction Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_lag.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio, fe robust
	
}
log close

// User Amount Regression with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total Trump, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total Trump, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total trump_share, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total trump_share, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// Reaction Amount with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total Trump, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total Trump, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total trump_share, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// User Amount lag with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_lag_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total Trump, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total trump_share, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// Reaction Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_lag_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// Subsample
// User Amount Regression
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total if crime_times >= 30, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio if crime_times >= 30, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total if crime_times >= 30, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio if crime_times >= 30, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total if crime_times >= 30, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio if crime_times >= 30, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total if crime_times >= 30, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio if crime_times >= 30, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio if crime_times >= 30, fe robust
	
}
log close

// Reaction Amount
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total if crime_times >= 30, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio if crime_times >= 30, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total if crime_times >= 30, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio if crime_times >= 30, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total if crime_times >= 30, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio if crime_times >= 30, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total if crime_times >= 30, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio if crime_times >= 30, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio if crime_times >= 30, fe robust
	
}
log close

// User Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_lag.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total if crime_times >= 30, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total if crime_times >= 30, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio if crime_times >= 30, fe robust
	
}
log close

// Reaction Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_lag.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total if crime_times >= 30, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total if crime_times >= 30, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total if crime_times >= 30, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio if crime_times >= 30, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio if crime_times >= 30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio, fe robust
	
}
log close

// User Amount Regression with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total Trump, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total Trump, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total trump_share, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total trump_share, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// Reaction Amount with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total Trump, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total Trump, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total trump_share, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// User Amount lag with Trump
log using "D:\FB_hatecrime\Result\Hate Crime Issue\user_amount_lag_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total Trump, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_user_amount i.date population l.user_total trump_share, fe robust
	xtreg `var' l.related_user_amount i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_user_amount i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population l.user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_user_amt i.date population user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' l.ln_user_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close

// Reaction Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount_lag_ideo.log"
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio Trump, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio Trump, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_reaction_amount i.date population l.user_total trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.related_reaction_amount i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population l.user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date population l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop l.ln_FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_user_total trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop ln_FB_ratio trump_share, fe robust
	
}
log close










































