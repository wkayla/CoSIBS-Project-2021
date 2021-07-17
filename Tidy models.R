model_function<-function(x){tidy(lm("Write your model function here"))}

model_data=clinical_metabolites%>%
  gather(Outcome,Outcome_value,c("List your metabolites here"))%>% # to do this quickly list the first metabolite in your dataset then add a : and then the last metabolite in your dataset
  group_by(Outcome)%>%
  nest()%>%
  mutate(models=map(data,model_function))%>%
  unnest(models,.drop = F)%>%
  select(Outcome,term,estimate,std.error,p.value)%>%
  mutate(term=gsub("case","",term),
         Percent_change=100*expm1(estimate),
         FDR_p_value=p.adjust(p.value,"BH"))%>% #add the number of metabolites
  mutate_at(vars(estimate,std.error,FDR_p_value,Percent_change),as.character)%>%
  mutate_at(vars(estimate,std.error,FDR_p_value,Percent_change),as.numeric)%>%
  mutate_at(vars(estimate,std.error,FDR_p_value,Percent_change),round,3)%>%
  mutate(FDR_p_value=ifelse(FDR_p_value=="0","<0.01",as.character(FDR_p_value)))%>%
  arrange(FDR_p_value)