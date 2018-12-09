# IODS: Data wrangling exercise 6
# Author: PH
# Dec 9th, 2018

library(data.table)
library(dplyr)

BPRS<-fread("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt")
RATS<-fread("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")[,-1,with=F] # RATS has row numbers, remove

# Data summaries
str(BPRS)
str(RATS)
head(BPRS)
head(RATS)
summary(BPRS)
summary(RATS)

# Convert factors
BPRS[,treatment:=as.factor(treatment)]
BPRS[,subject:=as.factor(subject)]

RATS[,ID:=as.factor(ID)]
RATS[,Group:=as.factor(Group)]

# Convert into long format
BPRSL<-melt(BPRS,id.vars = c("treatment", "subject"), value.name = "bprs", variable.name = "COL")
BPRSL[,Week:=as.integer(substr(COL, 5, length(COL)))]

RATSL<-melt(RATS, id.vars=c("ID", "Group"), value.name="Weight", variable.name="COL")
RATSL[,Time:=as.integer(substr(COL, 3, length(COL)))]

# Check long format
glimpse(BPRSL)
glimpse(RATSL)

# Save files
fwrite(BPRSL, "data/BPRSL.txt", sep="\t")
fwrite(RATSL, "data/RATSL.txt", sep="\t")

# Save as R objects
saveRDS(BPRSL, "data/BPRSL.rds")
saveRDS(RATSL, "data/RATSL.rds")
