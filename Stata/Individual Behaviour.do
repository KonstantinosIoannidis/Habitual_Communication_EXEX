** Tabulate habitual per treatment (Table 1) **
gen part = 0 if round >10 & round <=30
replace part = 1 if bias == 1 & (treatment_future == 0 | (treatment_future == 1 & round <= 40))
bysort treat*: tabstat habitual60 if round == 1, by(role) stat(sum n)

** Habitual by part two environment **
tabstat habitual60 if round == 30, by(treatment_future) stat(sum n)
prtest habitual60 if round == 30, by(treatment_future)

** Individual mechanisms **
* Difference in decision time between part one and part two *
egen time_first = mean(time_decision) if part == 0 & round > 20, by(id_sub)
sort id_sub time_first
replace time_first = time_first[_n-1] if time_first == .
egen time_new = mean(time_decision) if part == 1, by(id_sub)
sort id_sub time_new
replace time_new = time_new[_n-1] if time_new == .
gen time_diff = time_new - time_first
gen notice = time_diff > 0
tabstat habitual60 if round == 30, by(notice) stat(sum n)
* Effect of participant role *
tabstat habitual60 if round == 30, by(role) stat(sum n)
prtest habitual60 if round == 30, by(role)

** Differences in decision times **
egen time_mean = mean(time_decision) if part == 1, by(id_sub)
tabstat time_mean if round == 31, by(habitual60) stat(mean n)
ranksum time_mean if round == 31, by(habitual60)

** Differences in cognitive ability **
tabstat crt if round == 31, by(habitual60) stat(mean n)
ranksum crt if round == 31, by(habitual60)

** Effect of part one **
tabstat habitual60 if round == 31, by(treatment_past) stat(sum n)
prtest habitual60 if round == 30, by(treatment_past)
* Footnote 25 *
egen time_dec_one = mean(time_decision) if part == 0, by(id_sub)
tabstat time_dec_one if round == 30, by(treatment_past) stat(mean n)
ranksum time_dec_one if round == 30, by(treatment_past)
egen time_res_one = mean(time_results) if part == 0, by(id_sub)
tabstat time_res_one if round == 30, by(treatment_past) stat(mean n)
ranksum time_res_one if round == 30, by(treatment_past)

** Tabulate strategies in part one and part two **
version 16: bysort treatment_past treatment_future role: table strategy_one60 strategy_two60 if round == 1

drop part time_first time_new time_mean time_diff notice time_dec_one time_res_one



