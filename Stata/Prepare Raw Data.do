** Recode variables **
* study *
rename study study_old
generate study = study_old == "Economics", after(study_old)
drop study_old
* gender *
rename gender gender_old
generate gender = 0 if gender_old == "Female", after(gender_old)
replace gender = 1 if gender_old == "Male"
replace gender = 2 if gender_old == "Prefer not to answer"
drop gender_old
* role *
rename role role_old
generate role = 0 if role_old == "Receiver", after(role_old)
replace role = 1 if role_old == "Sender"
drop role_old
* treatments *
rename treatment_past treatment_past_old
generate treatment_past = treatment_past_old == "Aligned", after(treatment_past_old)
drop treatment_past_old
rename treatment_future treatment_future_old
generate treatment_future = treatment_future_old == "Frequent", after(treatment_future_old)
drop treatment_future_old
* bias *
rename bias bias_old
generate bias = 0 if bias_old == "Low", after(bias_old)
replace bias = 1 if bias_old == "Medium"
replace bias = 2 if bias_old == "Large"
drop bias_old
* trust sender *
rename trust_sender trust_sender_old
generate trust_sender = 2 if trust_sender_old == "Strongly agree", after(trust_sender_old)
replace trust_sender = 1 if trust_sender_old == "Agree"
replace trust_sender = 0 if trust_sender_old == "Neither agree nor disagree"
replace trust_sender = -1 if trust_sender_old == "Disagree"
replace trust_sender = -2 if trust_sender_old == "Strongly disagree"
drop trust_sender_old
* trust receiver *
rename trust_receiver trust_receiver_old
generate trust_receiver = 2 if trust_receiver_old == "Strongly agree", after(trust_receiver_old)
replace trust_receiver = 1 if trust_receiver_old == "Agree"
replace trust_receiver = 0 if trust_receiver_old == "Neither agree nor disagree"
replace trust_receiver = -1 if trust_receiver_old == "Disagree"
replace trust_receiver = -2 if trust_receiver_old == "Strongly disagree"
drop trust_receiver_old

** Label Variables **
label variable id_obs "Observation index"
label variable id_sub "Participant index"
label variable id_ses "Participant session index"
label variable participantcode "Participant code"
label variable participantlabel "Participant label"
label variable payoff "Payoff (total)"
label variable sessioncode "Session code"
label variable sessionlabel "Session label"
label variable treatment_past "Treatment part one"
label variable treatment_future "Treatment part two"
label variable matching_group "Matching group"
label variable time_questions "Instructions Time"
label variable time_waiting "Waiting Time"
label variable time_decision "Decision Time"
label variable time_results "Feedback Time"
label variable time_crt "CRT Time"
label variable time_total "Duration"
label variable role "Role"
label variable round "Round"
label variable earnings "Earnings"
label variable group_id "Group index"
label variable state "State"
label variable state "State"
label variable message "Message"
label variable action "Action"
label variable bias "Bias"
label variable noise "Noise"
label variable risk "Risk"
label variable risk_payoff "Risk payoff"
label variable crt "CRT"
label variable crt_payoff "CRT payoff"
label variable age "Age"
label variable study "Study"
label variable gender "Gender"
label variable trust_sender "Trust sender"
label variable trust_receiver "Trust receiver"

** Label Values **
label define past_treatments 0 "Conflict" 1 "Aligned"
label values treatment_past past_treatments
label define future_treatments 0 "Rare" 1 "Frequent"
label values treatment_future future_treatments
label define roles 0 "Receiver" 1 "Sender"
label values role roles
label define truths 0 "Lie" 1 "Truth"
label define followeds 0 "Not followed" 1 "Followed"
label define genders 0 "Female" 1 "Male" 2 "Other"
label values gender genders
label define study_fields 0 "Non-econ" 1 "Economics"
label values study study_fields
label define attitudes -2 "Strongly disagree" -1 "Disagree" 0 "Neither agree nor disagree" 1 "Agree" 2 "Strongly agree"
label values trust_sender attitudes
label values trust_receiver attitudes

** Generate temporary indexes **
* Define early and late rounds *
gen random_early = 1 if round <= 45 & treatment_future == 0 & bias == 1
gen random_late = 1 if round >= 45 & treatment_future == 0 & bias == 1
gen permanent_early = 1 if round <= 35 & treatment_future == 1 & bias == 1
gen permanent_late = 1 if round >=36 & round <= 40 & treatment_future == 1 & bias == 1
gen late = .
replace late = 0 if random_early == 1 | permanent_early == 1
replace late = 1 if random_late == 1 | permanent_late == 1
drop random_early random_late permanent_early permanent_late
// gen late_alt = 0 if (round == 31 | round == 35 | round == 39 | round == 42 | round == 43)
// replace late_alt = 1 if (round == 46 | round == 47 | round == 52 | round == 55 | round == 58)
label define rounds 0 "Early" 1 "Late"
label values late rounds
// label values late_alt rounds
* Matching group indexes *
bysort sessioncode: gen matching = 1 if id_ses == 1 & (round == 31 | (round == 46 & treatment_future == 0) | (round == 36 & treatment_future == 1))

sort id_obs
