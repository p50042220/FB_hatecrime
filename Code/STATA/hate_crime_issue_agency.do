// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\immigration_race_regression_with_ideology_agency.csv", clear
encode agency, gen(nagency)
gen crime_indicator = hate_crime > 0
gen racial_crime_indicator = racial_crime > 0
gen racial_broad_crime_indicator = racial_broad_crime > 0
gen date = date(week, "YMD")
format date %td
sort agency date
gen hate_cr = hate_crime_rate * 10000
gen user_total = round(related_user_amount/related_user_ratio)
gen FB_ratio = user_total/population

//Summary Statistics
//Calculate agency-level mean
bysort agency: egen crime_mean_state = mean(hate_crime)
bysort agency: egen crime_rate_mean_state = mean(hate_cr)
bysort agency: gen k = [_n]
bysort agency: egen crime_times = sum(crime_indicator)
bysort agency: egen racial_crime_times = sum(racial_crime_indicator)
bysort agency: egen racial_broad_crime_times = sum(racial_broad_crime_indicator)

//Visualization
twoway scatter hate_crime nagency, msymbol(circle_hollow) || connected crime_mean_state nagency, msymbol(diamond)
twoway scatter hate_cr nstate, msymbol(circle_hollow) || connected crime_rate_mean_state nstate, msymbol(diamond)
twoway connected no_crime_times nstate, msymbol(diamond) || connected crime_mean_state nstate, msymbol(diamond)

//State-level mean statistics
sum crime_mean if k==1, detail
sum crime_rate_mean if k==1, detail
count if crime_mean > 0.7 & k==1
sum crime_times if k==1, detail
tab crime_times if k==1 
tab agency if crime_times > 30

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

//Generate Candidate Indicator
gen Trump = 0
replace Trump = 1 if trump_share > 0.5
tabstat hate_crime, by(Trump) s(mean median min max N)
tab state if Trump == 1
tab week if Trump == 1 & state == "California"

xtset nagency date, delta(7)

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total if core_city == "Y", fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio if core_city == "Y", fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total if core_city == "Y", fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio if core_city == "Y", fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio if core_city == "Y", fe robust
	
}

foreach var in hate_crime racial_crime racial_broad_crime{
	
	xtreg `var' ln_reaction_amt i.date population user_total if crime_times > 5, fe robust
	xtreg `var' ln_reaction_amt i.date population FB_ratio if crime_times > 5, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_user_total if crime_times > 5, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop FB_ratio if crime_times > 5, fe robust
	xtreg `var' ln_reaction_amt i.date ln_pop ln_FB_ratio if crime_times > 5, fe robust
	
}