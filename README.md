## Description

This repository includes the data and the Stata code used in Ioannidis K. (2025). [Habitual communication](https://www.sciencedirect.com/science/article/pii/S2214804323000861). *Experimental Economics*, 106(1): 1-7

### Abstract

This paper studies habitual communication in a sender-receiver setting with information asymmetry. We investigate how habits formed in familiar environments affect communication in an unfamiliar environment. Using a controlled experiment with varying levels of preference alignment, we test two hypotheses: (i) whether familiarity with common-interest compared to conflicting-interest environments leads to more informative communication in an unfamiliar environment, and (ii) how reliance on communication habits varies based on the frequency of interacting in an unfamiliar environment. We find evidence for habitual communication only when the unfamiliar environment occurs rarely. Analysis of individual decisions provides suggestive evidence on the mechanisms.

### Software

The analysis was conducted using ```Stata 18```.

### Files

The files are stored in two folders: Data, which contains data from the experiment, and Stata, which contains the Stata code to produce every result in the paper.

1. Data
   * Experimental Data.csv (*The raw data from the experiment in csv format*)
   * Experimental Codebook.md (*Codebook for ```Experimental Data.csv```*)
2. Stata
   * Data Analysis.do (*Calls and executes all other files*)
   * Prepare Raw Data.do (*Cleans raw experimental data and prepares it for analysis*)
   * Treatment Design.do (*Produces Figure 1 in Section 2.2*)
   * Treatment Effects.do (*Produces Results 1,2,3 and Figure 2 in Sections 3.1-3.2*)
   * Individual Behaviour.do (*Produces results in Section 3.3*)
   * Classification 
      * Habits_classify.do (*Classifies habitual participants with 60% threshold*)
      * Habits_pure60.do (*Classifies pure strategies with 60% threshold*)
      * Habits_classify80.do (*Classifies habitual participants with 80% threshold*)
      * Habits_pure80.do (*Classifies pure strategies with 80% threshold*)
      * Habits_mixed.do (*Classifies mixed strategies*)
   * Appendix 
      * Manipulation.do (*Produces results in appendix A.2*)
      * Treatment Regressions.do (*Produces results in appendix A.3*)
      * Cai-Wang Regressions.do (*Produces results in appendix A.4*)
      * Individual Behaviour Alternative.do (*Produces results in appendix A.5*)
    
     
### Instructions
To run the code, you only need to run **Data Analysis.do**.

## Contributing

**[Konstantinos Ioannidis](http://konstantinosioannidis.com/)** 
For any questions, please email me here **ioannidis.a.konstantinos@gmail.com**.
