** Prepare raw data **
import delimited "../Data/Experimental Data.csv", clear
run "../Stata/Prepare Raw Data.do"

** Descriptives **
do "../Stata/Treatments Design.do"
sum age gender study payoff time_total if round == 1

** Treatment effects (sections 3.1 and 3.2) **
do "../Stata/Treatment Effects.do"
run "../Stata/Classification/Habits_classify.do"
do "../Stata/Individual Behaviour.do"

** Appendix **
* Behaviour in part one (appendix A.2) *
do "../Stata/Appendix/Manipulation.do"
* Treatment effects with regression (appendix A.3)
do "../Stata/Appendix/Treatment Regressions.do"
* Cai-Wang regressions (appendix A.4)
do "../Stata/Appendix/Cai-Wang Regressions.do"
* Classification habitual with threshold 80 (appendix A.5)
run "../Stata/Classification/Habits_classify80.do"
do "../Stata/Individual Behaviour Alternative.do"

