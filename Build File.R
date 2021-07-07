library(plyr)
library(tidyverse)

path<-"C:/Users/wkayla/OneDrive - The University of Colorado Denver/COSIBS Project 2021/Data/"

#Load in files
clinical=read.csv(paste(path,"MEEP_DataForR_format_delete PHI.csv",sep=""), header = T)
clinical_carpe=read.csv(paste(path,"Copy of CarpeData delete PHI.csv",sep=""), header = T)
metabolites=read.csv(paste(path,"metabolites raw text removed.csv",sep=""),header=T)
nmr_carpe=read.csv(paste(path,"NMR carpe samples sheet1 updated.csv",sep=""),header=T)
nmr_meep=read.csv(paste(path,"Urine samples NMR MEEP Aim 1_2018_04_03.csv",sep=""),header=T)
link_file=read.csv(paste(path,"link file.csv",sep=""),header=T)

#Create a distinct study id for cases and controls
clinical$study_id=paste(clinical$study_id,"Control",sep="")
clinical_carpe$study_id=paste(clinical_carpe$study_id,"Case",sep="")


#Combine the clinical datasets
clinical_full=rbind.fill(clinical,clinical_carpe)

#merge the link file and the urine samples
colnames(nmr_carpe)=c("study_id","Sample.ID","Volume","Timepoint","Shipped","NMR","AIM")
nmr_carpe$Case="Case"
colnames(nmr_meep)=c("study_id","Timepoint","Sample.ID","Volume","Date.Time")
nmr_meep$Case="Control"

samples=rbind.fill(nmr_carpe,nmr_meep)

samples=samples%>%
          filter(Timepoint!="T3" & Timepoint != "T3 ")%>%
          mutate(Timepoint=ifelse(Timepoint=="T1" | 
                                  Timepoint=="T1 " |
                                  Timepoint=="Enrollment","Enrollment","Discharge"))


samples_link=samples%>%
                inner_join(link_file,by=c("Sample.ID"="Study.ID"))%>%
                inner_join(metabolites,by=c("New.CARPEDIEM.NOESY.NMR.exp.no..2"="Experiment.No."))%>%
                dplyr::mutate(study_id=as.character(study_id),
                       study_id=paste0(study_id,Case,sep=""))

clinical_metabolites=inner_join(samples_link,clinical_full)
