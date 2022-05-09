######################
# Functions used in this Script
#####################
#
# - read.csv is a part of a suite of "read" functions. In this case I use all of the defaults except header which I update to True because all of our variable names are named in the CSV file
#
# - paste() this funtion wil concatenate two inputs on an element by element bases. 
#
#	    - If you were to use c() which is the concatenating function in R you would get a list instead, one element for the word "control" and one element for the vector of studyIDs
#
# - rbind.fill() this is found in the plyr library and differs from rbind() in base R. 
#
# 	  - rbind() will combine variables with exactly the same name by stacking them on top of each other. 
#
#   	- rbind() will throw an error if two variables name don't exactly match
#
#   	- rbind.fill() will take the two variables and create columns for each variable that don't exactly match
#
#   	- rbind.fill() will then assign missing values to the observations in the matrix/dataframe that didn't have that variable name
#
#	- white space and Case sensitivity are huge issues make sure they match or that they very intentionally don't
#
# - %>% this is a piping operater. There is loads to say about this little guy because pipes in R hold a lot of power, but I will keep it short for our purposes. I highly encourage you to read Hadley Wickham's R for Data Science to learn more. 
#
#	- They are apart of the tidyverse and in general make for much cleaner code, this same script in base R would be very long. 
#	
#	- That's not to say that there isn't a good reason to program in base R. Package development for example should be done in base R because it is independent of version updates
#	
#	- this operator says remember everything that happened before the operator and pull it into everything that is going on behind it
#	
#	- so for example samples%>%mutate() says I am going to use the mutate function by pulling in data from samples
#
# - filter() this simply subsets the data. It takes the data of interest the variable(s) you want to subset on and the logic statement.
#
#	- for example filter(Timepoint=="T1") says keep only the data for which the observations timepoint is equal to T1
#
# - Mutate() this allows you to change your variable in any way. this is where you can change to numeric, character, add things, ect
#
# - ifelse() this allows you to manipulate variables based on a logic statement. 
#	
#	- ifelse(Timepoint=="T1","Enrollment","Discharge") this says if the timepoint is "T1" then change the timepoint name to enrollment and discharge if it is not.
#
# - full_join() this is a part of the _join() suite 
#
#	- this says match all of the sample IDs and if they are an exact match then add all of their data into one row.
# 
#	- If they don't match then keep the observation but assign NAs to the variables in the dataset the observation isn't in
#	
#	- The other types of joins are inner, left, and right. You can also read about these in R for data science
################

library(plyr)
library(tidyverse)

path<-"" #update this for where the data is stored at in your computer

#Load in files
clinical<-read.csv(paste(path,"MEEP_DataForR_format_delete PHI.csv",sep=""), header = T) 
clinical_carpe<-read.csv(paste(path,"Copy of CarpeData delete PHI.csv",sep=""), header = T)
metabolites<-read.csv(paste(path,"metabolites raw text removed.csv",sep=""),header=T)
nmr_carpe<-read.csv(paste(path,"NMR carpe samples sheet1 updated.csv",sep=""),header=T)
nmr_meep<-read.csv(paste(path,"Urine samples NMR MEEP Aim 1_2018_04_03.csv",sep=""),header=T)
link_file<-read.csv(paste(path,"link file.csv",sep=""),header=T)

#Create a distinct study id for cases and controls
clinical$study_id<-paste(clinical$study_id,"Control",sep="")
clinical_carpe$study_id<-paste(clinical_carpe$study_id,"Case",sep="")


#Combine the clinical datasets
clinical_full=rbind.fill(clinical,clinical_carpe)

#merge the link file and the urine samples

nmr_carpe=nmr_carpe%>%
    mutate(Sample=ifelse(Sample=="Disharge","Discharge",as.character(Sample)))%>%
    distinct(Study.ID,Sample,.keep_all=T)

colnames(nmr_carpe)<-c("study_id","Sample.ID","Volume.x","Timepoint","Shipped","NMR","AIM")
nmr_carpe$Case<-"Case"
colnames(nmr_meep)<-c("study_id","Timepoint","Sample.ID","Volume.y","Date.Time")
nmr_meep$Case<-"Control"

samples<-rbind.fill(nmr_carpe,nmr_meep)

samples<-samples%>%
    filter(Timepoint!="T3" & Timepoint != "T3 ")%>%
    mutate(Timepoint=ifelse(Timepoint=="T1" |
                            Timepoint=="T1 " |
                            Timepoint=="Enrollment","Enrollment","Discharge"))


samples_link<-samples%>%
    full_join(link_file,by=c("Sample.ID"="Study.ID"))%>%
    full_join(metabolites,by=c("New.CARPEDIEM.NOESY.NMR.exp.no..2"="Experiment.No."))%>%
    dplyr::mutate(study_id=as.character(study_id),
                  study_id=paste0(study_id,Case,sep=""))

clinical_metabolites<-inner_join(samples_link,clinical_full)



