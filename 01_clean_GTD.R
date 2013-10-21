# Load and clean Global Terrorism Database (GTD) using R 
# Rebecca Johnston
# 13/10/2013

# To obtain data from GTD: 
# I submitted my contact info to the GTD
# I downloaded the entire GTD collection in .zip format
# Then opened "globalterrorismdb_1012dist.xlsx" in Excel
# Saved as .txt format 


# Load GTD ----------------------------------------------------------------

# Loaded data into R using read.delim
# "na.strings" converts blank fields and full stops to NA
terr <- read.delim("globalterrorismdb_1012dist.txt",  
                   header = TRUE, sep = "\t", quote = "\"",
                   na.strings = c("", "."))


# Check data structure ----------------------------------------------------

dim(terr)
class(terr)
names(terr)


# Remove unwanted variables from GTD  -------------------------------------

# Columns I want to keep 
terr <- terr[ , c("iyear", "imonth", "iday", "country_txt", "region_txt",
                  "city", "location", "attacktype1_txt", "targtype1_txt",
                  "gname", "motive", "weaptype1_txt", "nkill", "nwound",
                  "propextent_txt")]


# Shorten names of region_txt levels --------------------------------------

# Levels of region_txt have too many characters, need to shorten some names
levels(terr$region_txt)
levels(terr$region_txt) <- c("Oceania", "Central America", "Central Asia", 
                             "East Asia", "Eastern Europe", "MENA",
                             "North America", "Russia", "South America",
                             "South Asia", "Southeast Asia",
                             "Sub-Saharan Africa", "Western Europe")


# Save cleaned data to file -----------------------------------------------

write.table(terr, "GTD_cleaned.txt", quote = FALSE, sep = "\t", 
            row.names = FALSE)