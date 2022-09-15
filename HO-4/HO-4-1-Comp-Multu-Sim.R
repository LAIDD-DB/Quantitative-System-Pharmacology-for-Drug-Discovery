############### Load package start ################
library(ncappc)
library(dplyr)
############### Load package end ################

############### Set working directory start ################
##### Manu-Session-Set Working directory-Choose directory (Move Working directory)
############### Set working directory end ################

############### Function for multiple subject ################
############### Load dataset ################
df1 <- read.csv(file="HO-4-1-Comp-RV-10-n20.csv", header=T, na.strings = ".")

############### Load dataset ################
colnames(df1) <- c("TIME",c(1:21))
df2 <- subset(df1, df1$TIME >= 0 & df1$TIME <= 24)
#df2 <- subset(df2, df1$'1' >= 1.5)


IDs <- c(1:20)
min.id <- min(IDs)
for (i in IDs)
{ ID <- c(i)
TIME <- df2$TIME 
TIME <- round(TIME, digits = 2)
DV <- subset(df2, select = c(1+i))
df3 <- cbind(ID, TIME, DV)
colnames(df3) <- c("ID","TIME","DV")
#df3 <- df3[-which(duplicated(df3$TIME)),]
#C2 <- subset(df3, df3$TIME - 1392 ==2, select = DV)
#C6 <- subset(df3, df3$TIME - 1392 ==6, select = DV)

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

if (i==min.id) output <- df4
else output <- rbind(output,df4)
}

write.csv(output,"1-comp-NCA-n20.csv",row.names=FALSE,quote=FALSE)
