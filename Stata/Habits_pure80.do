** Binary coding of whether each individual decision is consistent with each of strategies **
forval a=1/5 {
    forval b=1/5 {
	    forval c=1/5 {
		    forval d=1/5 {
			    forval e=1/5 {
				    generate strat`a'`b'`c'`d'`e' = ( (cue == 1 & choice == `a') | (cue == 2 & choice == `b') | (cue == 3 & choice == `c') | (cue == 4 & choice == `d') | (cue == 5 & choice == `e'))
				}
			}
		}
	}
}
** Compute percentage of decisions consistent with each of the strategies **
forval a=1/5 {
    forval b=1/5 {
	    forval c=1/5 {
		    forval d=1/5 {
			    forval e=1/5 {
				    bysort id_sub bias part: egen strat`a'`b'`c'`d'`e'_mean = mean(strat`a'`b'`c'`d'`e')
					drop strat`a'`b'`c'`d'`e'
				}
			}
		}
	}
}
** Compute maximum compliance **
egen max_compliance = rowmax(strat11111_mean-strat55555_mean)
** Classify subjects into behavioral types if their compliance is up to 5% close to the maximum compliance **
gen behavioral_types = ""
forval a=1/5 {
    forval b=1/5 {
	    forval c=1/5 {
		    forval d=1/5 {
			    forval e=1/5 {
					replace behavioral_types = behavioral_types + "str`a'`b'`c'`d'`e'" if strat`a'`b'`c'`d'`e'_mean > (max_compliance-0.05)
				}
			}
		}
	}
}
** Generate stable strategy types **
gen stable_strat = behavioral_types if max_compliance >= 0.80
** Drop temporary variables **
drop strat*_mean max_compliance behavioral_type

** Rename strategies with intuitive names **
gen strat_pure80 = "Unclassified"
replace strat_pure80 = "Truth-teller" 		if strmatch(stable_strat, "*str12345*") & role == 1
replace strat_pure80 = "Exaggerate by 1" 	if strmatch(stable_strat, "*str23455*") & role == 1
replace strat_pure80 = "Exaggerate by 2" 	if strmatch(stable_strat, "*str34555*") & role == 1
replace strat_pure80 = "Exaggerate by 3" 	if strmatch(stable_strat, "*str45555*") & role == 1
replace strat_pure80 = "Always send 5" 	if strmatch(stable_strat, "*str55555*") & role == 1
replace strat_pure80 = "Always send 4" 	if strmatch(stable_strat, "*str44444*") & role == 1
replace strat_pure80 = "Believer"			if strmatch(stable_strat, "*str12345*") & role == 0
replace strat_pure80 = "Discount by 1"		if strmatch(stable_strat, "*str11234*") & role == 0
replace strat_pure80 = "Discount by 2"		if strmatch(stable_strat, "*str11123*") & role == 0
replace strat_pure80 = "Discount by 3"		if strmatch(stable_strat, "*str11112*") & role == 0
replace strat_pure80 = "Discount by 4"		if strmatch(stable_strat, "*str11111*") & role == 0
replace strat_pure80 = "Choose 1 more" 	if strmatch(stable_strat, "*str23455*") & role == 0
replace strat_pure80 = "Always choose 4"	if strmatch(stable_strat, "*str44444*") & role == 0
replace strat_pure80 = "Always choose 3"	if strmatch(stable_strat, "*str33333*") & role == 0
** Closer inspection for additional classifications of subjects which fit multiple strategy profiles **
replace strat_pure80 = "Truth-teller" 		if (strmatch(stable_strat, "*str?2345*") | strmatch(stable_strat, "*str1?345*") | strmatch(stable_strat, "*str12?45*") | strmatch(stable_strat, "*str123?5*") | strmatch(stable_strat, "*str1234?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Exaggerate by 1" 	if (strmatch(stable_strat, "*str?3455*") | strmatch(stable_strat, "*str2?455*") | strmatch(stable_strat, "*str23?55*") | strmatch(stable_strat, "*str234?5*") | strmatch(stable_strat, "*str2345?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Exaggerate by 2" 	if (strmatch(stable_strat, "*str?4555*") | strmatch(stable_strat, "*str3?555*") | strmatch(stable_strat, "*str34?55*") | strmatch(stable_strat, "*str345?5*") | strmatch(stable_strat, "*str3455?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Exaggerate by 3" 	if (strmatch(stable_strat, "*str?5555*") | strmatch(stable_strat, "*str4?555*") | strmatch(stable_strat, "*str45?55*") | strmatch(stable_strat, "*str455?5*") | strmatch(stable_strat, "*str4555?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Always send 5" 	if (strmatch(stable_strat, "*str?5555*") | strmatch(stable_strat, "*str5?555*") | strmatch(stable_strat, "*str55?55*") | strmatch(stable_strat, "*str555?5*") | strmatch(stable_strat, "*str5555?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Always send 4" 	if (strmatch(stable_strat, "*str?4444*") | strmatch(stable_strat, "*str4?444*") | strmatch(stable_strat, "*str44?44*") | strmatch(stable_strat, "*str444?4*") | strmatch(stable_strat, "*str4444?*")) & role == 1 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 1"		if (strmatch(stable_strat, "*str?1234*") | strmatch(stable_strat, "*str1?234*") | strmatch(stable_strat, "*str11?34*") | strmatch(stable_strat, "*str112?4*") | strmatch(stable_strat, "*str1123?*")) & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 2"		if (strmatch(stable_strat, "*str?1123*") | strmatch(stable_strat, "*str1?123*") | strmatch(stable_strat, "*str11?23*") | strmatch(stable_strat, "*str111?3*") | strmatch(stable_strat, "*str1112?*")) & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 3"		if (strmatch(stable_strat, "*str?1112*") | strmatch(stable_strat, "*str1?112*") | strmatch(stable_strat, "*str11?12*") | strmatch(stable_strat, "*str111?2*") | strmatch(stable_strat, "*str1111?*"))  & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 4"		if (strmatch(stable_strat, "*str?1111*") | strmatch(stable_strat, "*str1?111*") | strmatch(stable_strat, "*str11?11*") | strmatch(stable_strat, "*str111?1*") | strmatch(stable_strat, "*str1111?*"))  & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Believer" 			if (strmatch(stable_strat, "*str?2345*") | strmatch(stable_strat, "*str1?345*") | strmatch(stable_strat, "*str12?45*") | strmatch(stable_strat, "*str123?5*") | strmatch(stable_strat, "*str1234?*")) & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Always choose 4"	if (strmatch(stable_strat, "*str?4444*") | strmatch(stable_strat, "*str4?444*") | strmatch(stable_strat, "*str44?44*") | strmatch(stable_strat, "*str444?4*") | strmatch(stable_strat, "*str4444?*"))  & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Always choose 3"	if (strmatch(stable_strat, "*str?3333*") | strmatch(stable_strat, "*str3?333*") | strmatch(stable_strat, "*str33?33*") | strmatch(stable_strat, "*str333?3*") | strmatch(stable_strat, "*str3333?*"))  & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 2"			if (strmatch(stable_strat, "*str?1124*") | strmatch(stable_strat, "*str1?12?*") | strmatch(stable_strat, "*str11?24*") | strmatch(stable_strat, "*str111?4*") | strmatch(stable_strat, "*str1112?*")) & role == 0 & strat_pure80 == "Unclassified"
replace strat_pure80 = "Discount by 3"			if (strmatch(stable_strat, "*str?1114*") | strmatch(stable_strat, "*str1?114*") | strmatch(stable_strat, "*str11?14*") | strmatch(stable_strat, "*str111?4*") | strmatch(stable_strat, "*str1111?*")) & role == 0 & strat_pure80 == "Unclassified"

** Identify habitual subjects in pure strategies **
gen strat_one80 = strat_pure80 if round == 30
gen strat_new80 = strat_pure80 if round == 31
gen strat_two80 = strat_pure80 if round == 60
bysort id_sub: ereplace strat_one80 = mode(strat_one80)
bysort id_sub: ereplace strat_new80 = mode(strat_new80)
bysort id_sub: ereplace strat_two80 = mode(strat_two80)
gen habitual_pure80 = (strat_one80 == strat_new80) if (strat_one80 != "Unclassified" | strat_new80 != "Unclassified")
label variable habitual_pure80 "Habitual (pure 80)"
