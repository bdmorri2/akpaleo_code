library(foreach)
library(shapefiles)
library(rgdal)
library(maptools)
library(raster)

# Load weather station data
weather = read.csv("P:\\akpaleo\\weather_station\\weather.csv")
head(weather)
names(weather)
weather[weather == "unknown"] = NA


#fix the decimal place for pr
weather$TPCP = weather$TPCP/10
# ignore precip conversion. New data is m/s not kg.... mm/m to m/s
weather$TPCP = weather$TPCP*(1/1000)*(1/(2.592*10^6))         #(1/1000) * (1/(2.62974*10^6)) * (1000/1)  #--> converts mm/month --> kg m^-2 s^01 (this is what the climate data is in)

#make dates match up to climate data dates
weather[,6] = as.character(weather[ ,6])
weather[ ,6] = paste("X", weather[,6], sep = "")
weather[ ,6] = substr(weather[ ,6], 2,7)

#keep only the station name, lat, lon, date, prcip and temperature columns
weather = weather[,c(1,2,4,5,6,18,22,23,24) ]
keep = as.vector(which(weather[,3] != "NA" ))
weather = weather[keep, ]
weather[ , 7:9] = weather[ ,7:9]/10 # Need to add decimal to tenths place based off of the metadata
#weather[ ,6] = weather[,6] *.01 # Need to add decimal to the hundreths place based off of the metadata

# convert the odd no data values
weather$MNTM[weather$MNTM == min(weather$MNTM)] = NA
weather$MMNT[weather$MMNT == min(weather$MMNT)] = NA
weather$MMXT[weather$MMXT == min(weather$MMXT)] = NA
weather$TPCP[weather$TPCP == min(weather$TPCP)] = NA

# convert temperature columns to K
weather$MNTM = weather$MNTM + 273.15
weather$MMNT = weather$MMNT + 273.15
weather$MMXT = weather$MMXT + 273.15

# make new column with just the month name instead of the  month/yr to join data later (since the climate data is now just monthly average for whole time span)
month.name = cbind("jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec")
months = vector()
for (i in 1:nrow(weather))
{
  date = weather[i,5]
  mon = as.integer(substr(date, 5,6))
  name = month.name[mon]
  months[i] = name
  
}
weather$month = months

# convert the latlon coordinates to northing easting in ArcMap
x = as.numeric(as.vector(weather[ ,4]))
y = as.numeric(as.vector(weather[ ,3]))
latlon = cbind(x,y,weather[,c(2,5)])


write.csv(latlon, file = "P:\\akpaleo\\weather_station\\all_locations.csv")

# add Northing and easting coordinates to weather matrix
coords = shapefile("P:\\akpaleo\\weather_station\\shapefiles\\reproj_all_stations.shp")
xy = coordinates(coords)
weather = cbind(weather, xy)

# Add radiation data to the weather datafrmae

wd = setwd("P:\\akpaleo\\radiation\\reprojected\\")


files = dir()
files = files[25:36]

months = substr(files, 7, nchar(files)-4)

rad.extract = data.frame()

for (i in 1:length(files))
{
  
  r = raster(files[i])
  total = extract(r, xy)
  name = months[i]
  month = vector(length = length(total))
  month[] = name
  month = as.data.frame(month)
  radiation = cbind(total, month, xy)
  rad.extract = rbind(rad.extract, radiation) 
}

un.rad.extract = unique(rad.extract)

#rad.beam.data = merge(tasmax.clim.data, un.rad.extract, by = c("month", "coords.x1", "coords.x2"))
#rad.dif.data = merge(rad.beam.data, un.rad.extract, by = c("month", "coords.x1", "coords.x2"))
rad.tot.data = merge(weather, un.rad.extract, by = c("month", "coords.x1", "coords.x2"))


names(rad.tot.data)[names(rad.tot.data)=="total"] <- "total_rad"

# add the elevation, slope, and aspect data to the frame
ord.xy = rad.tot.data[ ,2:3]
elev = raster("P:\\akpaleo\\dem\\raster\\mosaic\\aea_dem.tif")
elv = extract(elev, ord.xy)
elv.data = cbind(rad.tot.data, elv)

# Calculate TCI
flow = raster("P:\\akpaleo\\flow_accum\\tci_cor.tif")
tci = extract(flow, ord.xy)

tci.data = cbind(elv.data, tci)


##### Add Climate


tmin = read.csv("P:\\akpaleo\\downscale\\tmin_extract.csv")
tmin_data = merge(tci.data, tmin, by = c("DATE", "coords.x1", "coords.x2"))

names(tmin_data)[names(tmin_data)=="extract"] <- "tmin"




write.csv(tmin_data, file = "P:\\akpaleo\\weather_station\\tmin_preRemove.csv")

sd_tmin = sd(tmin_data$MMNT, na.rm = TRUE)

tmin_remove = tmin_data
zscore = (abs(tmin_remove$MMNT - mean(tmin_remove$MMNT, na.rm = TRUE)))/sd_tmin
remove = which(zscore >3)
tmin_remove$MMNT[remove] = NA

tmin_remove = tmin_remove[ ,-16]
tmin_remove = tmin_remove[ ,-16]


write.csv(tmin_remove, file = "P:\\akpaleo\\weather_station\\tmin_database.csv")


# PRECIPITAITON

data = read.csv("P:\\akpaleo\\weather_station\\tmin_preRemove.csv")
pr = read.csv("P:\\akpaleo\\climate\\ccsm4\\modern\\pr_resample\\data\\pr_data.csv")
names(pr)[names(pr) == "extract"] = "pr" 

#pr_data = merge(data, pr, by = c("DATE", "coords.x1", "coords.x2"))
write.csv(pr_data, file = "P:\\akpaleo\\weather_station\\pr_preRemove.csv")

sd_pr = sd(data$TPCP, na.rm = TRUE)

pr_remove = data
zscore = (abs(pr_remove$TPCP - mean(pr_remove$TPCP, na.rm = TRUE)))/sd_pr
remove = which(zscore >3)
pr_remove$TPCP[remove] = NA


write.csv(pr_remove, file = "P:\\akpaleo\\weather_station\\pr_database.csv")


