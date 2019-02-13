# The source code of paper "Sleep quality prediction in caregivers using physiological signals"


%%% The functionality, inputs, and outputs of each individual files are described as follows:%%%



File name: main.R

Description: It contains the whole proceduress and run them by order

Input: all mudules

Output: predicted models

---------------------------------------------------------------------------------------------------------------------------------

File name: CatchDataFromE4_CaregiverSleep.R

Description: It aggregates data of different sensors and, stores recorded data in form of datafram

Input: heart rate, IBI, temperature, EDA of sleep records in form of csv files

Output: a datafram in the form of data[[participant ID]][[week number]][[day number]]$ signal_type

---------------------------------------------------------------------------------------------------------------------------------

File name: CatchDataFromSurvery_CaregiverSleep.R

Description: Aggregating the survey information with signals

Input: recorded signals and survey information in the forms of datafram and .xlsx, respectively.

Output: a datafram with the name of survey contains both signals and corresponding recorded signals

---------------------------------------------------------------------------------------------------------------------------------

File name: Survey Analysis.R

Description: It aggregates data of different sensors and, stores recorded data in form of datafram

Input: survey datafram

Output: visualization of data destributions in the forms of figures 5 and 6, Table 3

---------------------------------------------------------------------------------------------------------------------------------

File name: Survey Analysis.R

Description: It aggregates data of different sensors and, stores recorded data in form of datafram

Input: survey datafram

Output: visualization of data destributions in the forms of figures 5 and 6, Table 3

---------------------------------------------------------------------------------------------------------------------------------

File name: HRV_SWS.R

Description: computing features relevant to heart rate variability

Input: IBI from survey datafram

Output: relevant features to heart rate variability

---------------------------------------------------------------------------------------------------------------------------------

File name: Temp_Sleep.R

Description: computing features relevant to temperature

Input: Temp from survey datafram

Output: relevant features to temperature

---------------------------------------------------------------------------------------------------------------------------------

File name: EDA.R

Description: computing features relevant to Electrodermal activity

Input: EDA from survey datafram

Output: relevant features to Electrodermal activity

---------------------------------------------------------------------------------------------------------------------------------

File name: Classification.R

Description: Feature selection and classification

Input: survey datafram

Output: the final models and their performances
