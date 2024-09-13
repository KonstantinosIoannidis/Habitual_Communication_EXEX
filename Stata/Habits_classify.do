** Generate different part for classifications **
gen part = 0 if round >10 & round <=30
replace part = 1 if bias == 1 & (treatment_future == 0 | (treatment_future == 1 & round <= 40))
** Rename decisions into cues and choices for easier coding **
generate cue = state if role == 1
replace cue = message if role == 0
generate choice = message if role == 1
replace choice = action if role == 0
** Identify pure strategy profiles **
run "../Stata/Classification/Habits_pure60.do"
** Identify mixed strategy profiles **
run "../Stata/Classification/Habits_mixed.do"
** Identify overall habitual **
gen habitual60 = habitual_pure60
replace habitual60 = habitual_mixed if habitual_pure60 == .
label variable habitual60 "Habitual"
** Rename habitual mixing **
replace strat_one60 = "Mixing (same)" if habitual_pure60 == . & habitual_mixed == 1
replace strat_new60 = "Mixing (same)" if habitual_pure60 == . & habitual_mixed == 1
* Encode strategy names *
encode strat_one60, gen(strategy_one60)
label variable strategy_one "Strategy (part one)"
encode strat_new60, gen(strategy_two60)
label variable strategy_two "Strategy (new)"
encode strat_two60, gen(strategy_second60)
label variable strategy_second "Strategy (part two)"
** Drop temporary variables **
drop cue part choice new_cue strat_* stable_strat
drop habitual_pure60 habitual_mixed
