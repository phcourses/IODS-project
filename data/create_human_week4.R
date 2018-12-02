library(dplyr)
library(data.table)
library(testthat)

# Read both datasets
hd<-fread("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv")
gii <- fread("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", na.strings = "..")

# Glimpse for dimensions and structure
glimpse(hd)
glimpse(gii)

# Summaries of variables in datasets
summary(hd)
summary(gii)

# Create shorter names
names(hd)<-c("HDIrank","Country","HDI","LifeExp","ExpectedYearsEdu","MeanYearsEdu","GNI","GNIminusHDI")
names(gii)<-c("GIIrank","Country","GII","MaternalMortality","BirthRate","PercentParliament", 
              "FemalePopWithSecondaryEdu", "MalePopWithSecondaryEdu","FemaleLabourParticipation",
              "MaleLabourParticipation")

# Create new variables
gii[,EduRatio := FemalePopWithSecondaryEdu/MalePopWithSecondaryEdu]
gii[,LabRatio := FemaleLabourParticipation/MaleLabourParticipation]

# Inner join datasets
hdgii<-merge(hd, gii, by="Country", all=F)

# Test dimensions
test_that("Resulting dataset dimensions are correct", {expect_true(all(dim(hdgii)==c(195,19)))})

