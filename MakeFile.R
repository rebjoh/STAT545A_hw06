# Fake make file using R
# Rebecca Johnston
# 20/10/2013

# Clean data output from previous work
output <- c("GTD_cleaned.txt",
            # 01_clean_GTD.R
            "GTD_totalnkillnwound_perYear_byRegion.txt",
            # 02_graph_aggregate_cleaned_GTD.R
            "GTD_maxnkill_byRegion.txt",
            list.files(, pattern = "*.pdf"))
file.remove(output)

# Run scripts
source("01_clean_GTD.R")
source("02_graph_aggregate_cleaned_GTD.R")