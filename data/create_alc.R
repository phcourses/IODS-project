# IODS Week3 data wranling exercise 2018
# author: PH
# November 18th
# Original data downloaded from: https://archive.ics.uci.edu/ml/datasets/Student+Performance
library(data.table)
library(testthat)

# Read both CSV files
math<-fread("data/student-mat.csv")
port<-fread("data/student-por.csv")

# Check dimensions and structure of datasets
dim(math)
dim(port)
str(math)
str(port)

# Define columns to join by
joinby<-c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# Merge (inner join)
student<-merge(math, port, all=F, by=joinby)

# Structure and dimensions
str(student)
dim(student)

# Identify duplicated columns with set operations: intersect math and port column names, then remove (setdiff) joinby columns
dups<-setdiff(intersect(names(math), names(port)), joinby)
# Identify column numbers of paired columns in the merged table
dup_pairs<-lapply(dups, function(X) which(startsWith(names(student), X)))

# Go through column pairs (vectorized version) -> check if first of these is numeric -> take mean -> otherwise select first column
newcols<-as.data.table(lapply(dup_pairs, function (X) {
  if(is.numeric(student[[X[1]]])) 
    round(rowMeans(student[,X,with=F]))
  else
    student[[X[1]]]
}))

# Assign names for columns
names(newcols)<-dups

# Fix student table (remove duplicated pairs of columns and add new joined versions of them)
newstudent<-cbind(student[,!simplify2array(dup_pairs), with=F], newcols)
str(newstudent)
dim(newstudent)

# Calculate alcohol consumption variables
newstudent[,alc_use:=(Dalc + Walc)/2]
newstudent[,high_use:=alc_use>2]

# (Unit test) Check resulting table dimensions
test_that("joined table dimensions are correct", {expect_true(all(dim(newstudent)==c(382,35)))})

# Write wrangled data
fwrite(newstudent, "data/student.txt")
