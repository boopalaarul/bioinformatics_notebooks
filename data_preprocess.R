#Script that reads in, filters, and cbinds together the requested datasets.
library(data.table)
library(lubridate)

final.data <- data.frame()

#could kep adding more files as long as they have the same format
#however, older cruises don't have flow cytometry counts for bacteria
for (file in c("hot318-325.pp", "hot326-334.pp", "hot335-339.pp")) {

    #each file has 8 lines of header info; will cut this out and manually supply colnames
  prelim.data <- fread(file, skip = 8, header = F)
  
  #want the following columns: Cruise #, Date, Depth, Salinity, Prochlorococcus, 
  #Heterotrophic Bacteria, Synechococcus, (Pico-)Eukaryotes
  relevant.data <- prelim.data[,c(1, 4, 7, 18:22)]
  
  final.data <- rbind(final.data, relevant.data) 
}

#add column names
colnames(final.data) <- c("CruiseID", "Date", "Depth", "Salinity", "Prochlorococcus",
                          "HeterotrophBacteria", "Synechococcus", "PicoEukaryotes")
#check that columns are correct class

#convert dates & add extra cols for year, month, day
final.data$Date <- ymd(final.data$Date)
final.data$Year <- year(final.data$Date)
final.data$Month <- month(final.data$Date)
final.data$Day <- day(final.data$Date)

write.csv2(final.data, "processed_data.csv", row.names = F)
