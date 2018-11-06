library(raster)
library(gdalUtils)


test = raster("P:\\akpaleo\\dem\\raster\\extracted_data\\60raster\\w001001n70w159_conv.tif")

setwd("P:\\akpaleo\\dem\\raster\\extracted_data\\60raster")

wd = setwd("P:\\akpaleo\\dem\\raster\\extracted_data\\60raster")
files = dir()


mosaic_rasters(files, dst_dataset = "/projects/oa/akpaleo/dem/raster/mosaic/mosaic_60m.tif", verbose = TRUE)

