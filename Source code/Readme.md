# The source code of paper "Sleep quality prediction in caregivers using physiological signals"


%%% The functionality, inputs, and outputs of each individual file are described as follows:%%%



File name: main.R

Description: It contains all procedures and runs them in order.

Input: all modules

Output: predicted models

---------------------------------------------------------------------------------------------------------------------------------

File name: CatchDataFromE4_CaregiverSleep.R

Description: It aggregates data of different sensors and stores recorded data in the form of dataframe.

Input: heart rate, IBI, temperature, EDA of sleep records in the form of csv files.

Output: a dataframe in the form of data[[participant ID]][[week number]][[day number]]$ signal_type

---------------------------------------------------------------------------------------------------------------------------------

File name: CatchDataFromSurvery_CaregiverSleep.R

Description: Aggregating the survey information with signals

Input: recorded signals and survey information in the forms of dataframe and .xlsx, respectively.

Output: a dataframe with the name of survey contains both signals and corresponding recorded signals.

---------------------------------------------------------------------------------------------------------------------------------

File name: Survey Analysis.R

Description: It aggregates data of different sensors and stores recorded data in the form of dataframe.

Input: survey dataframe

Output: visualization of data distributions in the forms of figures 5 and 6,and Table 3.

---------------------------------------------------------------------------------------------------------------------------------

File name: HRV_SWS.R

Description: computing features relevant to heart rate variability

Input: IBI from survey dataframe

Output: relevant features to heart rate variability

---------------------------------------------------------------------------------------------------------------------------------

File name: Temp_Sleep.R

Description: computing features relevant to temperature

Input: Temp from survey dataframe

Output: relevant features to temperature

---------------------------------------------------------------------------------------------------------------------------------

File name: EDA.R

Description: computing features relevant to Electrodermal activity

Input: EDA from survey dataframe

Output: relevant features to Electrodermal activity

---------------------------------------------------------------------------------------------------------------------------------

File name: Classification.R

Description: Feature selection and classification

Input: survey dataframe

Output: the final models and their performances
