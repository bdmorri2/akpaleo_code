
library(utils)
library(foreach)
library(spatial.tools)
library(tools)

setwd("P:\\akpaleo\\dem\\raster\\raw_60m")
files = dir(pattern=glob2rx("*.zip*"))


files1 = files[1:153]
files2 = files[154:length(files)]

names1 = substr(files1, 1,7)
names2 = substr(files2, 10,16)

for (i in 1:length(files)) 
{
  zipfile = files[i]
  outname = names[i]
  outdir = paste("/projects/oa/akpaleo/dem/raster/extracted_data/NED_60m/", outname, sep = "")
  unzip(zipfile, exdir = outdir)
}


