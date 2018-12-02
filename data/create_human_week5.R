# Data wrangling exercise for week 5
# Introduction to Open Data Science 2018 course
# Author: PH

library(data.table)
library(testthat)
library(dplyr)

# Load data:
human<-fread("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

glimpse(human)

# Description of 'human' dataset variables. 
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi
# The data combines several indicators from most countries in the world
# "Country" = Country name
## Health and knowledge
# "GNI" = Gross National Income per capita
# "Life.Exp" = Life expectancy at birth
# "Edu.Exp" = Expected years of schooling 
# "Mat.Mor" = Maternal mortality ratio
# "Ado.Birth" = Adolescent birth rate
## Empowerment
# "Parli.F" = Percetange of female representatives in parliament
# "Edu2.F" = Proportion of females with at least secondary education
# "Edu2.M" = Proportion of males with at least secondary education
# "Labo.F" = Proportion of females in the labour force
# "Labo.M" " Proportion of males in the labour force
# "Edu2.FM" = Edu2.F / Edu2.M
# "Labo.FM" = Labo2.F / Labo2.M

# Task 1: transform the Gross National Income (GNI) variable to numeric
# Decimal separators are commas, need to change those first into dots
human[,GNI:=as.numeric(sub(",",".",GNI, fixed=T))]
expect_false(any(is.na(human$GNI))) # Unit test that no conversion failed

# Task 2: include only given columns
human<-human[,.(Country, Edu2.FM, Labo.FM, Edu.Exp, Life.Exp, GNI, Mat.Mor, Ado.Birth, Parli.F)]

# Task 3: Remove rows with missing values
human<-na.omit(human)

# Task 4: Remove the observations which relate to regions instead of countries.
# Last seven rows (156-162) are regions, let's remove them.
human<-human[-(156:162)]

# Task 5: Define the row names of the data by the country names and remove the country name column from the data
# Data.table intentionally doesn't have (counterproductive) row names, so let's move to data.frame world.
human.df<-as.data.frame(human[,! "Country"])
row.names(human.df)<-human$Country

# Write data, including row.names
write.table(human.df, "data/human.tsv", sep="\t", quote=F, row.names=T, col.names=T)

