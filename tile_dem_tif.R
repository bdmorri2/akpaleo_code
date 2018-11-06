library(raster)
library(gdalUtils)
dem = raster("/projects/oa/akpaleo/dem/aea_bilinear.tif")

#setwd("P:\\akpaleo\\radiation\\test_run")

clim= dem
# Determine tile parameters starting with the lower left corner
ntc <- 10000
ntr <- 10000

ex = extent(clim)


scoord = ex[3]
wcoord = ex[1]
#ncoord = ex[4]
ecoord = ex[2]
nsres = yres(clim)
ewres = xres(clim)
ncl <- ncol(clim) #number of columns 
nrw <- nrow(clim) #number of rows

# Determine the raster resolution, lower left corner coordinates and number of rows and columns. This can be used to calculate tile sizes:
cpt <- ceiling(ncl/ntc)  # number of columns per tile
rpt <- ceiling(nrw/ntr)  # number of rows per tile
cptl = ncl-cpt*(ntc-1)
rptl = nrw-rpt*(ntr-1)

scoor = scoord-ntr*nsres
ncoor = scoord
#plot(clim)

for(i in 1:rpt){     
  wcoor <- wcoord-ntc*ewres
  ecoor <- wcoord
  scoor <- scoor+ntr*nsres
  if (i == rpt)
  {
    ncoor <- ncoor+(6920)*nsres
  }
  else
  {
    ncoor = ncoor + ntr*nsres
  }
  
  
  s <- scoor #+ 0.5*mdr
  n <- ncoor #- 0.5*mdr
  
  for(j in 1:cpt){   
    wcoor <- wcoor+ntc*ewres
    
    if (j ==cpt)
    {
      ecoor <- ecoor+(1025)*ewres
    }
    else
    {
      ecoor <- ecoor+ntc*ewres
    }
    
    w <- wcoor #+ 0.5*mdr
    e <- ecoor #- 0.5*mdr
  
    library(raster)
    
    # add in time for paleo dir and speed
    c = crop(dem, extent(w,e,s,n))
    
    # test code to make sure that tiles are in correct dimensions, etc.
    #tl = c(w,n)
    #tr = c(e,n)
    #bl = c(w,s)
    #br = c(e,s)
    #points = rbind( tl, tr, bl, br)
    #points(points)
    
    writeRaster(c, file = paste('/data/gpfs/assoc/gears/akpaleo/data/dem/tiles/dem_', i, '.tif', sep = ""), overwrite = T)
    
  }
}




