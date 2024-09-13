** Generate correlations **
bysort sessioncode late: egen corr_sa = corr(state action)
** Ranksum tests for correlations (Result 1) **
bysort treatment_future late: ranksum corr_sa if matching == 1, by(treatment_past)
** Overcommunication (Result 2) **
bysort treatment_future late treatment_past: signtest corr_sa = 0.65 if matching == 1
** Produce treatment effect bar graph (Figure 3) **
preserve
** Store aggregate values **
statsby n=r(N) hicorr=r(ub) meancorr=r(mean) locorr=r(lb) ///
if id_ses == 1 & (round == 31 | (round == 46 & treatment_future == 0) | (round == 36 & treatment_future == 1)), ///
by(late treatment_past treatment_future) clear : ci mean corr_sa
** Create graph (Figure 3) **
generate round_past = treatment_past if late == 0
replace round_past = treatment_past+3 if late == 1
sort round_past
twoway (bar meancorr round_past if treatment_past==0, color(maroon)) ///
       (bar meancorr round_past if treatment_past==1, color(navy)) ///
       (rcap hicorr locorr round_past) ///
	   (function y = 0.65, ra(-0.5 1.5) lcolor(black)) ///
	   (function y = 0.65, ra(2.5 4.5) lcolor(black)) ///
	   if treatment_future == 0, ///
	   ylabel(0 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8" 1, nogrid) ///
	   legend(order(1 "Conflict" 2 "Aligned") pos(6) region(lcolor(black)) row(1)) ///
	   xlabel(0.5 "Early" 3.5 "Late", noticks nogrid) ///
	   ytitle("Correlation between state and action") ///	
	   title("Rare") ysize(2) xsize(2) name(rare)
twoway (bar meancorr round_past if treatment_past==0, color(maroon)) ///
       (bar meancorr round_past if treatment_past==1, color(navy)) ///
       (rcap hicorr locorr round_past) ///
	   (function y = 0.65, ra(-0.5 1.5) lcolor(black)) ///
	   (function y = 0.65, ra(2.5 4.5) lcolor(black)) ///	   
	   if treatment_future == 1, ///
	   ylabel(0 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8" 1, nogrid) ///
	   legend(order(1 "Conflict" 2 "Aligned") pos(6) region(lcolor(black)) row(1)) ///
	   xlabel(0.5 "Early" 3.5 "Late", noticks nogrid) ///
	   ytitle("Correlation between state and action") ///	
	   title("Frequent") ysize(2) xsize(2) name(frequent)

graph combine rare frequent
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph2.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .note.text = {}
gr_edit .note.text.Arrpush Lines in each bar indicate 95% confidence intervals. Horizontal lines indicate perfect Bayesian equilibrium correlation (0.650). 
graph export "../Graphs/treatment_effects.png", replace
graph drop rare frequent 
restore



