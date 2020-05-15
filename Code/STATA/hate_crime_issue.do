// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\immigration_race_regression.csv"
encode state, gen(nstate)
gen crime_indicator = hate_crime > 0
gen date = date(week, "YMD")
format date %td
sort state date
gen hate_cr = hate_crime_rate * 10000
gen user_total = round(related_user_amount/related_user_ratio)
gen FB_ratio = user_total/population

//Summary Statistics
//Calculate state-level mean
bysort state: egen crime_mean_state = mean(hate_crime)
bysort state: egen crime_rate_mean_state = mean(hate_cr)
bysort state: gen k = [_n]
bysort state: egen no_crime_times = sum(crime_indicator)
gen no_crime_rate=no_crime_times/82

//Visualization
twoway scatter hate_crime nstate, msymbol(circle_hollow) || connected crime_mean_state nstate, msymbol(diamond)
twoway scatter hate_cr nstate, msymbol(circle_hollow) || connected crime_rate_mean_state nstate, msymbol(diamond)
twoway connected no_crime_times nstate, msymbol(diamond) || connected crime_mean_state nstate, msymbol(diamond)

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

//Generate log variable
gen ln_pop = ln(population)
gen ln_user_amt = ln(related_user_amount)
gen ln_user_ratio = ln(related_user_ratio)
gen ln_hate_cr = ln(hate_cr)
gen ln_user_total = ln(user_total)
gen ln_FB_ratio = ln(FB_ratio)
gen ln_reaction_amt = ln(related_reaction_amount)

xtset nstate date, delta(7)

// User Amount Regression
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_user_amount i.date population user_total, fe robust
	xtreg `var' related_user_amount i.date population FB_ratio, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_user_total, fe robust
	xtreg `var' related_user_amount i.date ln_pop FB_ratio, fe robust
	xtreg `var' related_user_amount i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_user_amt i.date population user_total, fe robust
	xtreg `var' ln_user_amt i.date population FB_ratio, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' ln_user_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' ln_user_amt i.date ln_pop ln_FB_ratio, fe robust
	
}

// Reaction Amount
foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_reaction_amount i.date population user_total, fe robust
	xtreg `var' related_reaction_amount i.date population FB_ratio, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_user_total, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop FB_ratio, fe robust
	xtreg `var' related_reaction_amount i.date ln_pop ln_FB_ratio, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio, fe robust
	
}

// User Amount lag
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

// Reaction Amount lag
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
















































