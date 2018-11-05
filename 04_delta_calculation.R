time = "rcp8"
months = c("jan", "feb", "mar", "april", "may", "june", "july", "aug", "sept", "oct", "nov", "dec")
res = "30m"

dir_files = list.files(path = paste('/projects/oa/tree_vel/downscale/averages/', time, "/wind/dir/", sep = ""), pattern = ".tif", include.dirs = T, full.names = T)
order = c(5,4,8,1,9,7,6,2,12,11,10,3)
dir_files = dir_files[order]
aspect_file = paste("/projects/oa/tree_vel/dem/raster/ca_aspect_", res, "_fix.tif", sep = "")


for (i in 1:length(months))
{
  module = print("module load anaconda")
  gdal = print(paste("gdal_calc.py -A ", dir_files[i], " -B ", aspect_file, " --outfile /projects/oa/tree_vel/downscale/averages/", time, "/wind/delta/", res, "/dir_", months[i], "_", time, ".tif --calc='(numpy.absolute((A-B))>180)*numpy.absolute(numpy.absolute((A-B))-360)+(numpy.absolute((A-B))<=180)*numpy.absolute((A-B))'", sep = ""))
  combine = rbind(module, gdal)
  write(combine, file = paste("/projects/oa/tree_vel/downscale/averages/", time, "/wind/delta/qsub_files/delta_", res, "_", i, ".sh", sep = ""))
}

