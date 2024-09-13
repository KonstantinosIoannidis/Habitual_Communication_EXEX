** Identify habitual subjects in mixed strategies **
gen new_cue = cue*part
gen habitual_mixed = .
label variable habitual_mixed "Habitual (mixed)"
forval i=1/256 {
	quietly: regress choice part cue new_cue if id_sub == `i'
	quietly: replace habitual_mixed = (2*ttail(e(df_r),abs(_b[new_cue]/_se[new_cue]))>0.05 & 2*ttail(e(df_r),abs(_b[part]/_se[part]))>0.05) if _se[new_cue] > 0 & _se[part] > 0 & id_sub == `i' & strat_one == "Unclassified" & strat_new == "Unclassified"
}
replace habitual_mixed = 1 if habitual_mixed == .
