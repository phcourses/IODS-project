# create_learning2014.R
# Week 2 exercise, author PH, 9.11.2018
library(data.table)
library(car)
library(testthat)

# Read data in
in_data<-fread("data/JYTOPKYS3-data.txt")

dim(in_data)
# 183 rows x 60 variables table

str(in_data)
# Mostly numeric values, gender is a character variable

# Deep
in_data[,d_sm:=D03+D11+D19+D27]
in_data[,d_ri:=D07+D14+D22+D30]
in_data[,d_ue:=D06+D15+D23+D31]
#in_data[,Deep:=scale(d_sm+d_ri+d_ue)]
in_data[,Deep:=(d_sm+d_ri+d_ue)/12]

# Stra
in_data[,st_os:=ST01+ST09+ST17+ST25]
in_data[,st_tm:=ST04+ST12+ST20+ST28]
#in_data[,Stra:=scale(st_os+st_tm)]
in_data[,Stra:=(st_os+st_tm)/8]

# Surf
in_data[,su_lp:=SU02+SU10+SU18+SU26]
in_data[,su_um:=SU05+SU13+SU21+SU29]
in_data[,su_sb:=SU08+SU16+SU24+SU32]
#in_data[,Surf:=scale(su_lp+su_um+su_sb)]
in_data[,Surf:=(su_lp+su_um+su_sb)/12]

# Gender
in_data[,Gender:=as.numeric(recode(gender, "'M'=1;'F'=2;else=NA"))]

# Create learning2014 dataset
learning2014<-in_data[Points!=0,.(Gender, Age, Attitude, Deep, Stra, Surf, Points)]

# Unit test that dimensions are correct
test_that("learning2014 dimensions are correct", {expect_true(all(dim(learning2014)==c(166,7)))})

# Write file
fwrite(learning2014, "learning2014.txt")

# Test that learning2014 file can be read identically
in_test<-fread("learning2014.txt")
test_that("learning2014 read is identical in dimensions", {expect_true(all(dim(learning2014)==dim(in_test)))})

