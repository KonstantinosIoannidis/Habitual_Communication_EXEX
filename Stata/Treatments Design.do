** Generate treatments per round (Figure 1)
rename bias bias_new
gen bias = bias_new
replace bias = 0.2 if bias_new == 0
egen noise_mean = mean(noise), by(round)
replace noise_mean = noise_mean/10
replace bias = bias + noise_mean
* Top subfigure for Rare treatments *
twoway (scatter bias round if treatment_past == 0 & treatment_future == 0 & bias_new != 1, sort mcolor(red*.5) msize(large) msymbol(t)) /*
*/ (scatter bias round if treatment_past == 1 & treatment_future == 0 & bias_new != 1, sort mcolor(blue*.5) msize(large) msymbol(d)) /*
*/ (scatter bias round if treatment_past == 1 & treatment_future == 0 & bias_new == 1, sort mcolor(purple*.5) msize(large) msymbol(+)), /*
*/ xlabel(10 20 30 40 50 60, nogrid) ylabel(0.2 1 2, format(%03.1f) nogrid) ysize(1.5) /*
*/ legend(order(1 "Conflict-Rare" 2 "Aligned-Rare" 3 "Both (Conflict-Rare, Aligned-Rare)") rows(1) position(6) size(medium)) name(rare_full)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
* Top subfigure for Frequent treatments *
twoway (scatter bias round if treatment_past == 0 & treatment_future == 1 & bias_new != 1, sort mcolor(red*.5) msize(large) msymbol(t)) /*
*/ (scatter bias round if treatment_past == 1 & treatment_future == 1 & bias_new != 1, sort mcolor(blue*.5) msize(large) msymbol(d)) /*
*/ (scatter bias round if treatment_past == 1 & treatment_future == 1 & bias_new == 1, sort mcolor(purple*.5) msize(large) msymbol(+)), /*
*/ xlabel(10 20 30 40 50 60, nogrid) ylabel(0.2 1 2, format(%03.1f) nogrid) ysize(1.5) /*
*/ legend(order(1 "Conflict-Frequent" 2 "Aligned-Frequent" 3 "Both (Conflict-Frequent, Aligned-Frequent)") rows(1) position(6) size(medium)) name(frequent_full)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
* Combine subfigures *
graph combine rare_full frequent_full, rows(2) name(Figure_1)
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph2.style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph drop rare_full frequent_full

drop bias noise_mean
rename bias_new bias
order bias, before(state)
