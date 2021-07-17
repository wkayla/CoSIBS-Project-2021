library("optmatch")
library("tidyverse")

clinical_metabolites_format=clinical_metabolites%>%
                                  group_by(study_id)%>%
                                  filter(!all(Timepoint=="Enrollment") & !all(Timepoint=="Discharge"))%>%
                                  mutate(gender=ifelse(gender==1,"Male","Female"),
                                         age_yr=as.numeric(as.character(age_yr)),
                                         Case_logistic=as.numeric(as.character((ifelse(Case=="Case",1,0)))))

propensity.model <- glm(Case_logistic ~ age_yr + gender, data = clinical_metabolites_format, family = binomial())
propensity <- match_on(propensity.model)

matches <- pairmatch(propensity, data = clinical_metabolites_format) 

df<-cbind(clinical_metabolites_format, matches = matches)

df_subset<-df%>%filter(is.na(matches)==F)

df_subset%>%
ggplot(aes(x=gender,y=age_yr,fill=Case))+
    geom_boxplot()+
    theme_bw()+
    xlab("")+
    ylab("Age in Years")


