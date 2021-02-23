// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\immigration_race_regression_with_ideology_daily.csv", clear
encode state, gen(nstate)
gen crime_indicator = hate_crime > 0
gen racial_crime_indicator = racial_crime > 0
gen racial_broad_crime_indicator = racial_broad_crime > 0
rename date day
gen date = date(day, "YMD")
format date %td
sort state date
gen FB_ratio = total/population
gen month = month(date)
gen year = year(date)
gen hate_cr = hate_crime * 10000/population 
gen Week = date(week, "YMD")
format Week %td

//Summary Statistics
//Calculate state-level mean
bysort state: egen crime_mean = mean(hate_crime)
bysort state: egen crime_rate_mean_state = mean(hate_cr)
bysort state: gen k = [_n]
bysort state: egen crime_times = sum(crime_indicator)
bysort state: egen racial_crime_times = sum(racial_crime_indicator)
bysort state: egen racial_broad_crime_times = sum(racial_broad_crime_indicator)


//State-level mean statistics
sum crime_mean if k==1, detail
sum crime_rate_mean if k==1, detail
sum crime_times if k==1, detail
tab crime_times if k==1 
tab state if crime_times > 72

//Week total
bysort date: egen total_crime = sum(hate_crime)

//Heterogeneity of state-level mean
tab hate_crime if crime_mean > 0.7
sum hate_crime if crime_mean > 0.7
tab hate_cr if crime_mean > 0.7
sum hate_cr if crime_mean > 0.7
twoway scatter hate_crime nstate, msymbol(circle_hollow) || connected crime_mean nstate, msymbol(diamond)

// gen penetration = FB_ratio * post_total
//Generate log variable
gen ln_pop = ln(population)
gen ln_user_amt = ln(state_use)
// gen ln_hate_cr = ln(hate_cr)
gen ln_user_total = ln(total)
gen ln_reaction_amt = ln(state_reaction)
gen ln_post_amt = ln(post_total)

//Generate Candidate Indicator
gen Trump = 0
replace Trump = 1 if trump_share > 0.5
tabstat hate_crime, by(Trump) s(mean median min max N)
tab state if Trump == 1
// tab week if Trump == 1 & state == "California"


xtset nstate date


// Reaction Amount lag
log using "D:\FB_hatecrime\Result\Hate Crime Issue\reaction_amount.log", replace

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share l.ln_post_amt, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share l.ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtpoisson `var' l(0/2).ln_reaction_amt population FB_ratio trump_share i.Week, fe robust 
	xtpoisson `var' l(0/2).ln_reaction_amt ln_pop FB_ratio  trump_share i.Week, fe robust
	
}

xtreg racial_crime l(2/3).ln_reaction_amt ln_pop FB_ratio trump_share post_total i.Week if crime_times > 70, fe robust cluster(nstate)
xtreg racial_crime l(0/2).ln_user_amt ln_pop FB_ratio  trump_share i.Week, fe robust

xtreg state_user l(0/2).racial_crime ln_pop FB_ratio  trump_share i.Week, fe robust

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

//Subsample

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share if crime_times >=30, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share if crime_times >=30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_reaction_amt i.date population FB_ratio trump_share ln_post_amt if crime_times >=30, fe robust
	xtreg `var' l.ln_reaction_amt i.date ln_pop FB_ratio trump_share ln_post_amt if crime_times >=30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt l.ln_reaction_amt i.date population FB_ratio trump_share if crime_times >=30, fe robust
	xtreg `var' ln_reaction_amt l.ln_reaction_amt i.date ln_pop FB_ratio trump_share if crime_times >=30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share if crime_times >=30, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share if crime_times >=30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population FB_ratio trump_share ln_post_amt if crime_times >=30, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio trump_share ln_post_amt if crime_times >=30, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.FB_ratio i.date population trump_share if crime_times >=30, fe robust
	xtreg `var' l.FB_ratio i.date ln_pop trump_share if crime_times >=30, fe robust
	
}

log close

//Comment amount
log using "D:\FB_hatecrime\Result\Hate Crime Issue\comment_amount.log", replace

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_comment_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.ln_comment_amt i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.ln_comment_amt i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' l.ln_comment_amt i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_comment_amt l.ln_comment_amt i.date population FB_ratio trump_share, fe cluster(nstate) robust
	xtreg `var' ln_comment_amt l.ln_comment_amt i.date ln_pop FB_ratio trump_share, fe cluster(nstate) robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_comment_amt i.date population FB_ratio trump_share, fe robust
	xtreg `var' ln_comment_amt i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_comment_amt i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' ln_comment_amt i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

log close

//Comment length
log using "D:\FB_hatecrime\Result\Hate Crime Issue\comment_length.log", replace

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_length i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.related_comment_length i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_length i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' l.related_comment_length i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_length l.related_comment_length i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_length l.related_comment_length i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_length i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_length i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_length i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' related_comment_length i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

log close

//Comment Sentiment
log using "D:\FB_hatecrime\Result\Hate Crime Issue\comment_sentiment.log", replace

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_sentiment i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.related_comment_sentiment i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_sentiment i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' l.related_comment_sentiment i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_sentiment l.related_comment_sentiment i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_sentiment l.related_comment_sentiment i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_sentiment i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_sentiment i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_sentiment i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' related_comment_sentiment i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

log close

//Comment Sentiment
log using "D:\FB_hatecrime\Result\Hate Crime Issue\comment_negative_ratio.log", replace

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_negative_ratio i.date population FB_ratio trump_share, fe robust
	xtreg `var' l.related_comment_negative_ratio i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' l.related_comment_negative_ratio i.date population FB_ratio trump_share ln_post_amt, fe robust
	xtreg `var' l.related_comment_negative_ratio i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_negative_ratio l.related_comment_negative_ratio i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_negative_ratio l.related_comment_negative_ratio i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_negative_ratio i.date population FB_ratio trump_share, fe robust
	xtreg `var' related_comment_negative_ratio i.date ln_pop FB_ratio trump_share, fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' related_comment_negative_ratio i.date population FB_ratio trump_share ln_post_amt , fe robust
	xtreg `var' related_comment_negative_ratio i.date ln_pop FB_ratio trump_share ln_post_amt, fe robust
	
}

log close


