** Results related to Table A2 **
* Generate correlations *
bysort sessioncode: egen corr_sa_matching = corr(state action) if round <=30
bysort sessioncode: egen corr_sm_matching = corr(state message) if round <=30
bysort sessioncode: egen corr_ma_matching = corr(message action) if round <=30
* Differences between aligned and conflict *
ranksum corr_sa_matching if round == 1 & id_ses == 1, by(treatment_past)
ranksum corr_sm_matching if round == 1 & id_ses == 1, by(treatment_past)
ranksum corr_ma_matching if round == 1 & id_ses == 1, by(treatment_past)
* Overcommunication *
signrank corr_sa_matching = 0 if round == 1 & id_ses == 1 & treatment_past == 0
signrank corr_sm_matching = 0 if round == 1 & id_ses == 1 & treatment_past == 0
signrank corr_ma_matching = 0 if round == 1 & id_ses == 1 & treatment_past == 0
drop corr*

** Decision and feedback times in part one **
bysort sessioncode: egen mean_time_decision = mean(time_decision) if round <=30
bysort sessioncode: egen mean_time_results = mean(time_results) if round <=30
* Generate regression table for decision and feedback times (Table A3) *
bysort sessioncode round: egen mean_round_time_decision = mean(time_decision) if round <=30
bysort sessioncode round: egen mean_round_time_results = mean(time_results) if round <=30
eststo decision_matching: quietly ///
regress mean_round_time_decision i.treatment_past round if id_ses == 1 & round <=30, vce(cluster sessioncode)
eststo decision_individual: quietly ///
regress time_decision i.treatment_past round risk crt trust_sender trust_receiver age gender study if round<=30, vce(cluster id_sub)
eststo feedback_matching: quietly ///
regress mean_round_time_results i.treatment_past round if id_ses == 1 & round<=30, vce(cluster sessioncode)
eststo feedback_individual: quietly ///
regress time_results i.treatment_past round risk crt trust_sender trust_receiver age gender study if round<=30, vce(cluster id_sub)
esttab decision_matching decision_individual feedback_matching feedback_individual using "../Tex/times_part_one.tex", ///
mlabels(decision_matching decision_individual feedback_matching feedback_individual) ///
indicate(Controls = age gender study) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) b(2) obslast replace type ///
addnotes("Controls: Age, Gender, Study, Risk, CRT, Trust." ///
"Standard errors clustered on matching group level (32 clusters)." ///
"\sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)")

** Drop temporary variables **
drop *mean* _est*
sort id_obs

