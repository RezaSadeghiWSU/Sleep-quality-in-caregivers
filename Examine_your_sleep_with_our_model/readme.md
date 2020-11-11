# Examine your sleep with our model

- How our model is created?
    - 1. Using E4, we have access to four physiological signals of Heart Rate Variability, Electrodermal Activity, Temperature, and Body Movement
    - 2.	We extracted 20 quantitative features from the physiological signals. The list of these features and their descriptions are accessible Appendix A of the sleep quality paper. For your continence, I attached the paper to this email.
    - 3.	We trained a random forest model using the data of 100 sleep nights of 8 caregivers.
    - For more information please refere to the main directory
    
- How you can evaluate your sleep with our model?
    - 1. Put your E4 data in distinct folder of .\Data\Participant Number\Week Number\night, E.g. .\Data\Participant 1\Week 1\1
    - 2. Replace the directory of traind sleep quality model and feeling refreshed model in lines 3 and 6 of ExamineSleep.R
    - 3. Replace the direcory in line 10 with your desired directory, which contains Data folder and other functions used in ExaminSleep.R
    - 4. Change numberPerson, numberWeek, numberDay on lines 11 to 13 based on your data stored in Data folder.
    - 5. Run ExamineSleep.R
