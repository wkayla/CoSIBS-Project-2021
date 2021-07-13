# CoSIBS-Project-2021

## Background

Assessing changes in metabolites across time between healthy controls and children diagnosed with CAP.

## Merging Analytic Files 

Notes I things I wanted the group to notice and think through:

•	The study IDs for the case and control samples were the same and needed to be manipulated to be distinct

  - This was pointed out by Nathan

•	The metabolites raw data had a section at the bottom with text that when read in would cause issues in merging

•	The column names for the cases and controls were different and in order to merge samples together needed to be manipulated

•	The timepoint labels were different for cases and controls

  - Not only were the timepoints different there was white space causing issues in grouping


#Functions used in this Script

- read.csv is a part of a suite of "read" functions. In this case I use all of the defaults except header which I update to True because all of our variable names are named in the CSV file

- paste() this funtion wil concatenate two inputs on an element by element bases. 

	- If you were to use c() which is the concatenating function in R you would get a list instead, one element for the word "control" and one element for the vector of studyIDs

- rbind.fill() this is found in the plyr library and differs from rbind() in base R. 

	- rbind() will combine variables with exactly the same name by stacking them on top of each other. 

	- rbind() will throw an error if two variables name don't exactly match

	- rbind.fill() will take the two variables and create columns for each variable that don't exactly match

	- rbind.fill() will then assign missing values to the observations in the matrix/dataframe that didn't have that variable name

	- white space and Case sensitivity are huge issues make sure they match or that they very intentionally don't

- %>% this is a piping operater. There is loads to say about this little guy because pipes in R hold a lot of power, but I will keep it short for our purposes. I highly encourage you to read Hadley Wickham's R for Data Science to learn more. 
	
	- They are apart of the tidyverse and in general make for much cleaner code, this same script in base R would be very long. 
	
	- That's not to say that there isn't a good reason to program in base R. Package development for example should be done in base R because it is independent of version updates
	
	- this operator says remember everything that happened before the operator and pull it into everything that is going on behind it
	
	- so for example samples%>%mutate() says I am going to use the mutate function by pulling in data from samples

- filter() this simply subsets the data. It takes the data of interest the variable(s) you want to subset on and the logic statement.

	- for example filter(Timepoint=="T1") says keep only the data for which the observations timepoint is equal to T1

- Mutate() this allows you to change your variable in any way. this is where you can change to numeric, character, add things, ect

- ifelse() this allows you to manipulate variables based on a logic statement. 
	
	- ifelse(Timepoint=="T1","Enrollment","Discharge") this says if the timepoint is "T1" then change the timepoint name to enrollment and discharge if it is not.

-full_join() this is a part of the _join() suite 

	- this says match all of the sample IDs and if they are an exact match then add all of their data into one row.
 
	- If they don't match then keep the observation but assign NAs to the variables in the dataset the observation isn't in
	
	- The other types of joins are inner, left, and right. You can also read about these in R for data science



