** Ordered logistic regressions for decisions (individual level) **
gen state_new = state*treatment_past
label variable state_new "State*Aligned"
eststo as00: quietly ///
ologit action state state_new round risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_future == 0, cluster(sessioncode)
eststo as10: quietly ///
ologit action state state_new round risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_future == 0, cluster(sessioncode)
eststo as01: quietly ///
ologit action state state_new round risk crt trust_sender trust_receiver age study gender if late == 0 & treatment_future == 1, cluster(sessioncode)
eststo as11: quietly ///
ologit action state state_new round risk crt trust_sender trust_receiver age study gender if late == 1 & treatment_future == 1, cluster(sessioncode)
esttab as00 as10 as01 as11, ///
mlabels("Rare Early" "Rare Late" "Frequent Early" "Frequent Late") ///
indicate(Controls = age gender study) se pr2 label nonumber nonotes noomitted nobaselevels interaction(*) b(2) obslast replace type ///
addnotes("Controls: Age, Gender, Study, Risk, CRT, Trust." ///
"Standard errors clustered on matching group level (16 clusters)." ///
"\sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)")

drop _est* state_new

** Generate Figure A.1 **
* Create correlations *
bysort round treatment_past treatment_future: egen corr_sa_round = corr(state action)
* Generate graph of correlation over rounds for Rare *
twoway 	///
	(line corr_sa_round round if treatment_past == 1, sort lpattern(solid) lcolor(navy)) ///
	(line corr_sa_round round if treatment_past == 0, sort lpattern(dash) lcolor(maroon)) ///
	(scatter corr_sa round if bias == 1, sort mcolor(black) msize(tiny) msymbol(.)) ///
	(function y = 0.65, ra(0 60) lcolor(black)) ///
	if treatment_future == 0, ///
	ytitle(Correlation) ///
	xtitle(Round) ///
	xlabel(5 10 15 20 25 30 35 40 45 50 55 60, nogrid) ///
	ylabel(0 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8" 1, nogrid) ///
	legend(order(1 "Aligned-Rare" 2 "Conflict-Rare") pos(6) region(lcolor(black)) row(1)) ///
	name(rare_time)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
* Generate graph of correlation over rounds for Conflict *
twoway 	///
	(line corr_sa_round round if treatment_past == 1, sort lpattern(solid) lcolor(navy)) ///
	(line corr_sa_round round if treatment_past == 0, sort lpattern(dash) lcolor(maroon)) ///
	(function y = 0.65, ra(0 60) lcolor(black)) ///
	if treatment_future == 1, ///
	ytitle(Correlation) ///
	xtitle(Round) ///
	xlabel(5 10 15 20 25 30 35 40 45 50 55 60, nogrid) ///
	ylabel(0 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8" 1, nogrid) ///
	legend(order(1 "Aligned-Frequent" 2 "Conflict-Frequent") pos(6) region(lcolor(black)) row(1)) ///
	name(frequent_time)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph combine rare_time frequent_time, rows(2) name(Figure_A1)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph2.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .note.text = {}
gr_edit .note.text.Arrpush In the upper figure for Aligned-Rare and Conflict-Rare, black dots indicate the rounds when b=1.
drop corr*
graph drop rare_time frequent_time 
