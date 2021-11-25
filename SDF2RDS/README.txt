SDF2RDS Conversion Tool
Created: 2021/11/25

Arun S. Moorthy; arun.moorthy@nist.gov
================================================================================

To run this tool, use the command

> source("asm_SDF2RDS.R")

while ensuring the working directory has been updated to the directory containing
the script. The program will ask the user to select an SDF file to convert (from the 
options in the 'SDF_files' folder) and produce an R-data.table (.RDS) in the 
'converted_RDSfiles' folder. This .RDS file can then be loaded into an R workspace.

The "MoNA-export-GC-MS_Spectra.sdf" library is from the Mass Bank of North America 
https://mona.fiehnlab.ucdavis.edu/downloads

The "SWGDRUG39.SDF" file was creating by converting the SWGDrug v3.9 library from NIST 
format to an SDF using Lib2NIST (a free converter available at chemdata.nist.gov). 
The SWGDrug Library is hosted at https://swgdrug.org. 