# Run some test scripts on the Bchron R package

# Clear the workspace if required
# rm(list=ls())

# Choice of installations:
# Cran version
#install.packages('Bchron')
# github master
devtools::install_github('andrewcparnell/Bchron',build_vignettes=TRUE)
# github develop
#devtools::install_github('andrewcparnell/Bchron',ref='develop')#,build_vignettes=TRUE)

# Load in
library(Bchron)

## Check the vignette if required (doesn't work if installing from github)
#vignette('Bchron')

# Note that you can source individual scripts from github via, e.g.
# devtools::source_url("https://raw.githubusercontent.com/andrewcparnell/Bchron/develop/R/Bchron_mcmc.R")

#####

# A single age
ages1 = BchronCalibrate(ages=11553,ageSds=230,calCurves='intcal13',ids='Date-1')
summary(ages1)
plot(ages1)

# Multiple ages
ages2 = BchronCalibrate(ages=c(3445,11553,7456), ageSds=c(50,230,110), calCurves=c('intcal13','intcal13','shcal13'))
summary(ages2)
plot(ages2)

# With depths
ages3 = BchronCalibrate(ages=c(3445,11553), 
                        ageSds=c(50,230), 
                        positions=c(100,150), 
                        calCurves=c('intcal13','normal'))
summary(ages3)
plot(ages3,withDepths=TRUE)

#####

# Running Bchronology

# Get Glendalough data
data(Glendalough)
print(Glendalough)

# Run Bchronlogy
GlenOut = Bchronology(ages=Glendalough$ages,ageSds=Glendalough$ageSds, calCurves=Glendalough$calCurves,positions=Glendalough$position, positionThicknesses=Glendalough$thickness,ids=Glendalough$id, predictPositions=seq(0,1500,by=10))

# Summary
summary(GlenOut)
summary(GlenOut, type='convergence')
summary(GlenOut, type='outliers')

# Plot
plot(GlenOut,main="Glendalough",xlab='Age (cal years BP)',ylab='Depth (cm)',las=1)

# Predict
predictAges = predict(GlenOut, newPositions = c(150,725,1500), newPositionThicknesses=c(5,0,20))

####

# RSl rate estimation

# Data
data(TestChronData)
data(TestRSLData)

# Run Bchron RSL
RSLrun = Bchronology(ages=TestChronData$ages,ageSds=TestChronData$ageSds, positions=TestChronData$position,positionThicknesses=TestChronData$thickness, ids=TestChronData$id,calCurves=TestChronData$calCurves, predictPositions=TestRSLData$Depth)
RSLrun2 = BchronRSL(RSLrun,RSLmean=TestRSLData$RSL,RSLsd=TestRSLData$Sigma,degree=3)

# Summary and plot
summary(RSLrun2)
plot(RSLrun2)

######

# Phase estimation
data(Sluggan)
SlugDens = BchronDensity(ages=Sluggan$ages,ageSds=Sluggan$ageSds,calCurves=Sluggan$calCurves,
                         numMix=50)
plot(SlugDens)

# Fast version
SlugDensFast = BchronDensityFast(ages=Sluggan$ages,ageSds=Sluggan$ageSds, calCurves=Sluggan$calCurves)

