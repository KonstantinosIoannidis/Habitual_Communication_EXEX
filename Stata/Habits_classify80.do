** Generate different part for classifications **
gen part = 0 if round >10 & round <=30
replace part = 1 if bias == 1 & (treatment_future == 0 | (treatment_future == 1 & round <= 40))
** Rename decisions into cues and choices for easier coding **
generate cue = state if role == 1
replace cue = message if role == 0
generate choice = message if role == 1
replace choice = action if role == 0
** Identify pure strategy profiles **
run "../Stata/Classification/Habits_pure80.do"
** Identify mixed strategy profiles **
run "../Stata/Classification/Habits_mixed.do"
** Identify overall habitual **
gen habitual80 = habitual_pure80
replace habitual80 = habitual_mixed if habitual_pure80 == .
label variable habitual80 "Habitual"
** Rename habitual mixing **
replace strat_one80 = "Mixing (same)" if habitual_pure80 == . & habitual_mixed == 1
replace strat_new80 = "Mixing (same)" if habitual_pure80 == . & habitual_mixed == 1
* Encode strategy names *
encode strat_one80, gen(strategy_one80)
label variable strategy_one80 "Strategy (part one)"
encode strat_new80, gen(strategy_two80)
label variable strategy_two80 "Strategy (new)"
encode strat_two80, gen(strategy_second80)
label variable strategy_second80 "Strategy (part two)"
** Drop temporary variables **
drop cue part choice new_cue strat_* stable_strat
drop habitual_pure80 habitual_mixed
