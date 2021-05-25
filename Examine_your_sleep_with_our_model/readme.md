# Examine your sleep with our model

- How our model is created?
    - 1. Using E4, we have access to four physiological signals of Heart Rate Variability, Electrodermal Activity, Temperature, and Body Movement
    - 2. We extracted 20 quantitative features from the physiological signals. The list of these features and their descriptions are accessible Appendix A of the sleep quality paper. For your continence, I attached the paper to this email.
    - 3. We trained a random forest model using the data described in our paper. You can access the final models at "Sleep-quality-in-caregivers/Final models/"
    - For more information please refere to the main directory
    
- How can you evaluate your sleep with our model?
    - 1. Put your E4 data in distinct folder of .\Data\Participant Number\Week Number\#night, E.g. .\Data\Participant 1\Week 1\1
    - 2. Replace the directory of traind sleep quality model and traind feeling refreshed model in lines 3 and 6 of ExamineSleep.R. You can find them on "Sleep-quality-in-caregivers-master/Final models/"
    - 3. Replace the direcory in line 10 with your desired directory, which contains Data folder and other functions used in ExaminSleep.R
    - 4. Change numberPerson, numberWeek, numberDay on lines 11 to 13 based on your data stored in Data folder.
    - 5. Change p_i, w_i, d_i on lines 201 to 203 to analyze your desired sleeping night record with the training data.
    - 6. Run ExamineSleep.R

- The sample of feature analysis provided from line 199 to 294:

![Heart rate variability Features](https://github.com/RezaSadeghiWSU/Sleep-quality-in-caregivers/tree/master/Demos/Test1.pdf)

![Electrodermal activity Features](https://github.com/RezaSadeghiWSU/Sleep-quality-in-caregivers/tree/master/Demos/Test2.pdf)

![Body movement Features](https://github.com/RezaSadeghiWSU/Sleep-quality-in-caregivers/tree/master/Demos/Test3.pdf)

![Temperature Features]https://github.com/RezaSadeghiWSU/Sleep-quality-in-caregivers/tree/master/Demos/Test4.pdf)
