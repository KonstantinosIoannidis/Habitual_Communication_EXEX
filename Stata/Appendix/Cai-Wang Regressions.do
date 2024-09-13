** Create adjusted variables for Cai-Wang regressions **
* Compute standard deviations of state, message and action
bysort treatment_past treatment_future late: egen sd_state = sd(state) if bias == 1 & late !=.
bysort treatment_past treatment_future late: egen sd_action = sd(action) if bias == 1 & late !=.
* Compute ratios of standard deviations *
gen r_state_action = (sd_action/sd_state)*0.65
* Generate adjusted variables *
gen action_state = action - r_state_action * state

* Regressions of action on state *
eststo as000: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_past == 0 & treatment_future == 0, cluster(participantcode)
eststo as100: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_past == 0 & treatment_future == 0, cluster(participantcode)
eststo as010: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_past == 1 & treatment_future == 0, cluster(participantcode)
eststo as110: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_past == 1 & treatment_future == 0, cluster(participantcode)
eststo as001: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_past == 0 & treatment_future == 1, cluster(participantcode)
eststo as101: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_past == 0 & treatment_future == 1, cluster(participantcode)
eststo as011: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_past == 1 & treatment_future == 1, cluster(participantcode)
eststo as111: quietly ///
reg action_state state risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_past == 1 & treatment_future == 1, cluster(participantcode)
esttab as000 as100 as010 as110 as001 as101 as011 as111 using "../Tex/cai_wang.tex", ///
mlabels("CR Early" "CR Late" "AR Early" "AR Late" "CF Early" "CF Late" "AF Early" "AF Late" ) ///
indicate(Controls = age gender study) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) b(2) obslast replace type ///
addnotes("Controls: Age Gender Study " ///
"Std. Err. adjusted for 64 subject clusters" ///
"\sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)")

drop sd_state sd_action r_state_action action_state _est_*
sort id_obs
