library(raster)
library(rgdal)
library(gdalUtils)
library(foreach)
library(spatial.tools)


# rasterize the unzipped files

wd = setwd("P:\\akpaleo\\dem\\raster\\raw_60m")

files = list.files(path = wd, pattern = "w01001.adf", recursive = TRUE, full.names = TRUE)

file = vector()
for (i in 1:length(files))
{
  string = substr(files[i], 1, 69)
  file[i] = string
}

dupl_files = which(duplicated(file))
files = file[-dupl_files]



names = dir()
#names = names[2:length(names)]
outnames = vector()

for (i in 1:length(names))
{
  string = paste(names[i], "_conv.tif", sep = "")
  outnames[i] = string
}
outname = unlist(outname)
outname = outname[1:375]


for (i in 1:503)
{
  batch_gdal_translate(infiles = files[i], outdir = "/projects/oa/akpaleo/dem/raster/extracted_data/60raster",  outsuffix = outnames[i], verbose = TRUE )
}

wd = setwd("P:\\akpaleo\\dem\\raster\\extracted_data\\60raster")

files = dir()
files = list.files(path = wd, pattern = ".aux", recursive = TRUE, full.names = TRUE)

delete = foreach(files) %do%
{
  file.remove(files)
}

files = dir()
name = substr(files, 7,22)

newname = foreach(files) %do%
{
  file.rename(files, names)
}

files = list.files(path = wd, pattern = ".img", recursive = TRUE, full.names = TRUE)

test = raster("P:\\akpaleo\\dem\\raster\\extracted_data\\60raster\\n71w144_conv.tif")
