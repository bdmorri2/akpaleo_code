var = "sw_rad"
time = "paleo"
months = c("april", "aug", "dec", "feb", "jan", "july", "june", "mar", "may", "nov", "oct", "sept")

inpath =  paste('/projects/oa/akpaleo/archived_climate/', time, "/late_lgm/monthly_ave/", var, sep = "")
files = list.files(path = inpath, pattern = ".tif")

for (i in 1:12)
{
  lib = print('library(gdalUtils)')
  infile = print(paste("infile = '/projects/oa/akpaleo/archived_climate/", time, "/late_lgm/monthly_ave/", var, "/", files[i], "'", sep = ""))
  outfile = print(paste("outfile = '/projects/oa/akpaleo/archived_climate/", time, "/sw_resample/", files[i], "'", sep = ""))
  ref = print("ref= '/projects/oa/akpaleo/radiation/coarse_rad/coarse_april.tif'")
  align = print(paste("align_rasters(unaligned= infile, reference = ref, dstfile = outfile, nThreads = 20, r = 'bilinear', verbose = TRUE)"))
  combine = rbind(lib, infile, outfile, ref, align)
  write(combine, file = paste('/projects/oa/akpaleo/archived_climate/', time, '/sw_resample/qsub_files/resample_', i, '.R', sep = ""))
  R = print(paste("R CMD BATCH /projects/oa/akpaleo/archived_climate/", time, "/sw_resample/qsub_files/resample_", i, '.R', sep = ""))
  write(R, file = paste('/projects/oa/akpaleo/archived_climate/', time, '/sw_resample/qsub_files/R_job_', i, '.sh', sep = ""))
  qsub = print(paste("qsub -o resample_out -e resample_err -l walltime=4:00:00,nodes=1:ppn=20 /projects/oa/akpaleo/archived_climate/", time, "/sw_resample/qsub_files/R_job_",i, ".sh", sep = ""))
  write(qsub, file = paste("/projects/oa/akpaleo/archived_climate/", time, "/sw_resample/qsub_files/qsub_commands.sh", sep = ""), append = TRUE)  
}

