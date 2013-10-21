# Graph and aggregate cleaned GTD using R 
# Rebecca Johnston
# 13/10/2013


# Load required packages --------------------------------------------------

library(ggplot2) # for graphing
library(plyr) # for data aggregation
library(reshape) # for converting data from wide to tall format for plotting

# Load cleaned GTD --------------------------------------------------------

# Upload new GTD output from sub folder data
terr <- read.delim("GTD_cleaned.txt", header = TRUE, sep = "\t", 
                   quote = "", na.strings = "NA")
dim(terr)
names(terr)
head(terr)
tail(terr)


# Make some plots ---------------------------------------------------------

# Number of fatalities per incident over time
# N.B. Must specify na.rm = TRUE in ggplot AND geom_point arguments
  # Otherwise it removes missing nkill values with a warning
# Changed range of y axis using limits within scale_y_continuous argument 
  # Since I don't want to show an extreme outlier
  # Which happens to be the 9/11 attacks
terr[which(terr$nkill == max(terr$nkill, na.rm = TRUE)), ]

# geom_boxplot looks ridiculous since the IQR is 1
summary(terr$nkill)
IQR(terr$nkill, na.rm = TRUE)

# geom_point looks a little more interesting
# Due to overlapping points, I have used the alpha argument to add transparency
killPerYr <- ggplot(terr, aes(x = iyear, y = nkill, na.rm = TRUE)) + 
  ylab("Number of fatalities") +
  xlab("Year") +
  ggtitle("Number of fatalities per terrorist incident over time") +
  theme(plot.title = element_text(face = "bold")) +
  scale_y_continuous(limits = c(0, 450)) + 
  geom_point(na.rm = TRUE, alpha = 0.25)
pdf("point_nkills_perIncident_perYear.pdf")
plot(killPerYr)
dev.off()

# Number of fatalities per incident over time by region
killPerYrReg <- ggplot(terr, aes(x = iyear, y = nkill, colour = region_txt, 
                                 na.rm = TRUE)) + 
  ylab("Number of fatalities") +
  xlab("Year") +
  ggtitle("Number of fatalities per terrorist incident over time") +
  theme(plot.title = element_text(face = "bold"), 
        axis.text.x = element_text(angle = 90, vjust = 0.25), 
        legend.position = "none") +
  scale_y_continuous(limits = c(0, 450)) + 
  geom_point(na.rm = TRUE, alpha = 0.5, size = I(1)) + 
  facet_wrap(~region_txt)
pdf("point_nkills_perIncident_perYear_facetByRegion.pdf")
plot(killPerYrReg)
dev.off()

# Number of individuals wounded per incident over time by region
woundPerYrReg <- ggplot(terr, aes(x = iyear, y = nwound, colour = region_txt, 
                                  na.rm = TRUE)) + 
  ylab("Number of individuals wounded") +
  xlab("Year") +
  ggtitle("Number of individuals wounded per terrorist incident over time") +
  theme(plot.title = element_text(face = "bold"), 
        axis.text.x = element_text(angle = 90, vjust = 0.25), 
        legend.position = "none") +
  scale_y_continuous(limits = c(0, 450)) + 
  geom_point(na.rm = TRUE, alpha = 0.5, size = I(1)) + 
  facet_wrap(~region_txt)
pdf("point_nwound_perIncident_perYear_facetByRegion.pdf")
plot(woundPerYrReg)
dev.off()


# Data aggregation --------------------------------------------------------

# Compare total nkill to total nwound over time and region using geom_line
totKill <- ddply(terr, iyear ~ region_txt, summarize, 
                 nkill = sum(nkill, na.rm = TRUE), 
                 nwound = sum(nwound, na.rm = TRUE))
head(totKill)

# Used reshape package to melt wide into tall format and plotted by group
# Much easier to plot graphs when data is in tall format
# id argument in melt function = state columns to keep constant
totKill <- melt(totKill, id = c("iyear", "region_txt"))
head(totKill)
tail(totKill)

# Changed names in data frame since it is difficult to change legend in ggplot
names(totKill) <- c("Year", "Region", "Result", "Number")
levels(totKill$Result) <- c("Killed", "Wounded")

# Save the result to file
write.table(totKill, "GTD_totalnkillnwound_perYear_byRegion.txt", 
            quote = FALSE, sep = "\t", row.names = FALSE)

# Plot the results
kilWndYrReg <- ggplot(totKill, aes(x = Year, y = Number, group = Result, 
                                   colour = Result)) +
  geom_line() + facet_wrap(~Region) + 
  ylab("Number of individuals") +
  xlab("Year") +
  ggtitle("Total number of fatalities and wounded individuals per year") +
  theme(plot.title = element_text(face = "bold"), 
        axis.text.x = element_text(angle = 90, vjust = 0.25))
pdf("line_totalnkill_totalnwound_perYear_facetByRegion.pdf")
plot(kilWndYrReg)
dev.off()


# Maximum number of fatalities per region for any one incident
maxKilReg <- ddply(terr, ~region_txt, summarize, 
                    maxKill = max(nkill, na.rm = TRUE))
(maxKilReg <- arrange(maxKilReg, maxKill))
maxKilReg <- within(maxKilReg, region_txt <- reorder(region_txt, maxKill))
# maxKilRegXT <- xtable(maxKilReg)
# print(maxKilRegXT, type = "html", include.rownames = FALSE)

# Save to file
write.table(maxKilReg, "GTD_maxnkill_byRegion.txt", quote = FALSE,
            sep = "\t", row.names = FALSE)

# Plot
ggmaxKilReg <- ggplot(maxKilReg, aes(x = region_txt, y = maxKill, 
                                     fill = region_txt)) + 
  coord_flip() +
  geom_histogram(stat = "identity", show_guide = FALSE) +
  ylab("Number of individuals") +
  xlab("Year") +
  ggtitle("Maximum fatalities for any one terrorist incident") +
  theme(plot.title = element_text(face = "bold"), legend.position = "none")
pdf("histogram_maxnkill_perRegion.pdf")
plot(ggmaxKilReg)
dev.off()

# Which terrorist groups were behind the attacks with the most fatalities per
# region?
whichGrp <- function(x) {
  maxKill <- which.max(x$nkill)
  data.frame(maxKill = x[maxKill, "nkill"], 
             x[maxKill,'gname'])
}
maxKilRegGrp <- ddply(terr, ~region_txt, whichGrp)
(maxKilRegGrp <- arrange(maxKilRegGrp, maxKill))
names(maxKilRegGrp) <- c("Region", "Max killed", "Terrorist group name")
# maxKilRegGrpXT <- xtable(maxKilRegGrp)
# print(maxKilRegGrpXT, type = "html", include.rownames = FALSE)

# How many fatalities are attributed to terrorist attacks each year?
nKillYr <- ddply(terr, ~iyear, summarize, TotalKill = sum(nkill, na.rm = TRUE))
ggnKillYr <- ggplot(nKillYr, aes(x = iyear, y = TotalKill)) + 
  geom_histogram(stat = "identity") +
  ylab("Number of fatalities") +
  xlab("Year") +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle("Total number of fatalities attributed to terrorist attacks per year")
pdf("histogram_totalnkill_perYear.pdf")
plot(ggnKillYr)
dev.off()

# Total fatalities per attack type?
(killByAtt <- ddply(terr, ~attacktype1_txt, summarize, 
                   totalKill = sum(nkill, na.rm = TRUE)))
# Reorder levels based on minimum of totalKill
killByAtt <- within(killByAtt, attacktype1_txt <- reorder(attacktype1_txt, 
                                                          as.integer(totalKill), 
                                                          FUN = min))
# Plot result
ggkillByAtt <- ggplot(killByAtt, aes(x = attacktype1_txt, y = totalKill, 
                                     fill = attacktype1_txt)) + 
  geom_histogram(stat = "identity") + 
  coord_flip() +
  ylab("Number of fatalities") +
  xlab("Attack type") +
  theme(plot.title = element_text(face = "bold"), legend.position = "none") +
  ggtitle("Total fatalities per terrorist attack type")
pdf("histogram_totalnkill_byAttackType.pdf")
plot(ggkillByAtt)
dev.off()