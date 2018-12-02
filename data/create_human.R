library(dplyr)
library(data.table)
library(testthat)

### First Week 4 part of data wrangling exercise (week 5 below) ###

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

### Week5 ####

# This dataset originates from the United Nations Development Programme. It 195 observations (countries) and 19 variables, 
# out of which two (EduRatio and LabRatio) are self-created. The prior is the ratio of Females with secondary education 
# compared to men. The latter is gender artio of labour participation.
glimpse(hdgii)

## Health and knowledge
# GNI = Gross National Income per capita
# LifeExp = Life expectancy at birth
# ExpectedYearsEdu = Expected years of schooling 
# MaternalMortality = Maternal mortality ratio
# BirthRate = Adolescent birth rate
## Empowerment
# PercentParliament = Percetange of female representatives in parliament
# FemalePopWithSecondaryEdu = Proportion of females with at least secondary education
# MalePopWithSecondaryEdu = Proportion of males with at least secondary education
# FemaleLabourParticipation = Proportion of females in the labour force
# MaleLabourParticipation = Proportion of males in the labour force
# EduRatio = FemalePopWithSecondaryEdu / MalePopWithSecondaryEdu
# LaboRatio = FemaleLabourParticipation / MaleLabourParticipation

# Ex. 1: transform the Gross National Income (GNI) variable to numeric
# Decimal separators are commas, need to change those first into dots
hdgii[,GNI:=as.numeric(sub(",",".",GNI, fixed=T))]
expect_false(any(is.na(hdgii$GNI))) # Unit test

