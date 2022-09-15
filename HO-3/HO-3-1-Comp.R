############### Load package start ################
library(ncappc)
library(dplyr)
############### Load package end ################

############### Set working directory start ################
##### Manu-Session-Set Working directory-Choose directory (Move Working directory)
############### Set working directory end ################

############### Load dataset ################
df1 <- read.csv(file="HO-3-1-Comp.csv", header=T, na.strings = ".")

############### Test for Single ID ################
colnames(df1) <- c("TIME",c(1))
df2 <- subset(df1, df1$TIME >= 0 & df1$TIME <= 24)

ID <- c(1)
TIME <- df2$TIME 
TIME <- round(TIME, digits = 2)

DV <- subset(df2, select = c(2))
df3 <- cbind(ID, TIME, DV)
colnames(df3) <- c("ID","TIME","DV")

###df3 <- df3[-which(duplicated(df3$TIME)),]

sim_auc_db <- tibble(ID = df3$ID, 
                     TIME = df3$TIME,
                     DV = df3$DV)

sim_auc <- ncappc(obsFile = sim_auc_db,
                  onlyNCA = T,
                  extrapolate = T,
                  printOut = F,
                  evid = FALSE,
                  noPlot = T,
                  adminType = "extravascular",
                  doseTime = 0)

nca <- sim_auc$ncaOutput%>% select(c(Cmax, Clast, AUClast))

df4 <- cbind(unique(df3$ID), nca)
colnames(df4) <- c("ID","Cmax","Clast","AUClast")

write.csv(df4,"1-comp-NCA.csv",row.names=FALSE,quote=FALSE)

############### over 1.5 ug/mL ##############
############### Load dataset ################
df1 <- read.csv(file="HO-3-1-Comp.csv", header=T, na.strings = ".")

############### Test for Single ID ################
colnames(df1) <- c("TIME",c(1))
df2 <- subset(df1, df1$TIME >= 0 & df1$TIME <= 24)
df2 <- subset(df2, df1$'1' >= 1.5)

ID <- c(1)
TIME <- df2$TIME 
TIME <- round(TIME, digits = 2)

DV <- subset(df2, select = c(2))
df3 <- cbind(ID, TIME, DV)
colnames(df3) <- c("ID","TIME","DV")

###df3 <- df3[-which(duplicated(df3$TIME)),]

sim_auc_db <- tibble(ID = df3$ID, 
                     TIME = df3$TIME,
                     DV = df3$DV)

sim_auc <- ncappc(obsFile = sim_auc_db,
                  onlyNCA = T,
                  extrapolate = T,
                  printOut = F,
                  evid = FALSE,
                  noPlot = T,
                  adminType = "extravascular",
                  doseTime = 0)

nca <- sim_auc$ncaOutput%>% select(c(Cmax, Clast, AUClast))

df4 <- cbind(unique(df3$ID), nca)
colnames(df4) <- c("ID","Cmax","Clast","AUClast")

write.csv(df4,"1-comp-NCA-1.5over.csv",row.names=FALSE,quote=FALSE)