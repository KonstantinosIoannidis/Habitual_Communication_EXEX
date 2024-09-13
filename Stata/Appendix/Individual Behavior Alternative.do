** Tabulate habitual per treatment (Table 1) **
gen part = 0 if round >10 & round <=30
replace part = 1 if bias == 1 & (treatment_future == 0 | (treatment_future == 1 & round <= 40))
bysort treat*: tabstat habitual80 if round == 1, by(role) stat(sum n)

** Habitual by part two environment **
tabstat habitual80 if round == 30, by(treatment_future) stat(sum n)
prtest habitual80 if round == 30, by(treatment_future)

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
tabstat habitual80 if round == 30, by(notice) stat(sum n)

* Effect of participant role *
tabstat habitual80 if round == 30, by(role) stat(sum n)
prtest habitual80 if round == 30, by(role)

** Differences in decision times **
egen time_mean = mean(time_decision) if part == 1, by(id_sub)
tabstat time_mean if round == 31, by(habitual80) stat(mean n)
ranksum time_mean if round == 31, by(habitual80)

** Differences in cognitive ability **
tabstat crt if round == 31, by(habitual80) stat(mean n)
ranksum crt if round == 31, by(habitual80)

** Effect of part one **
tabstat habitual80 if round == 31, by(treatment_past) stat(sum n)
prtest habitual80 if round == 30, by(treatment_past)
