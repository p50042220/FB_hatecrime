// Basic Preprocessing
import delimited "D:\FB_hatecrime\Data\Hate Crime\Regression\polarization_issue.csv", clear
gen date = date(week, "YMD")
gen ln_std_whole = ln(std_whole_x)
gen ln_post_amount = ln(related_post_amount)
gen ln_reaction_amount = ln(related_reaction_amount)

log using "D:\FB_hatecrime\Result\polarization issue\result.log", replace
reg ln_std_whole related_post_amount, robust
reg std_whole_x ln_post_amount, robust
reg std_whole_x ln_reaction_amount, robust
reg std_all ln_post_amount, robust
reg std_all ln_reaction_amount, robust
reg std_new ln_post_amount, robust
reg std_new ln_reaction_amount, robust
reg std_quit ln_post_amount, robust
reg std_quit ln_reaction_amount, robust
log close