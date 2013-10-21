STAT545A hw06: Analysis of the Global Terrorism Database
---
_Rebecca Johnston_

_21/10/2013_

### Report:
A visual report of my assignment (without code) is available via [RPubs](http://rpubs.com/rljohn/stat545a-2013-hw06_johnston-reb).

### Summary:
For this assignment, I explored the [Global Terrorism Database](http://www.start.umd.edu/gtd/), which contains information about over 100 000 terrorist incidents from 1970 - 2011. I attempted to perform a very visual and global analysis using R and ggplot2.

### How to replicate my analysis:

1. Download the following files into an empty directory:
  + [`globalterrorismdb_1012dist.txt`](https://github.com/rebjoh/STAT545A_hw06/blob/master/globalterrorismdb_1012dist.txt)
  + [`01_clean_GTD.r`](https://github.com/rebjoh/STAT545A_hw06/blob/master/01_clean_GTD.R)
  + [`02_graph_aggregate_cleaned_GTD.r`](https://github.com/rebjoh/STAT545A_hw06/blob/master/02_graph_aggregate_cleaned_GTD.R)
  + [`MakeFile.r`](https://github.com/rebjoh/STAT545A_hw06/blob/master/MakeFile.R)

2. Start a new RStudio session. Ensure the above directory is the working directory, then open the MakeFile.R, and click on "Source".
  + Alternatively, in a shell: *Rscript MakeFile.R*
    + Running the pipeline for the first time will return warnings about file.remove(). Don't worry, this is totally normal, since the code is trying to remove files that don't exist.
  
3. After running the pipeline, you should see 3 .txt files and 7 .pdf files:
  + GTD_cleaned.txt
  + point_nkills_perIncident_perYear.pdf
  + point_nkills_perIncident_perYear_facetByRegion.pdf
  + point_nwound_perIncident_perYear_facetByRegion.pdf
  + GTD_totalnkillnwound_perYear_byRegion.txt
  + line_totalnkill_totalnwound_perYear_facetByRegion.pdf
  + histogram_totalnkill_perYear.pdf
  + histogram_totalnkill_byAttackType.pdf
  + histogram_maxnkill_perRegion.pdf
  + GTD_maxnkill_byRegion.txt
