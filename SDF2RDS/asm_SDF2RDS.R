# A simple script to convert an SDF file (from the ExampleSDF_files folder)
# to an R data table (.RDS) that can be further manipulated in R. The output
# RDS file will be saved in the working directory.
#
# Contact: Arun Moorthy, arun.moorthy@nist.gov
#============================================================================
rm(list=ls()) # clear workspace

header = paste0("SDF2RDS Converter v.0.1\nRevised November 25, 2021.")
cat(header)
cat("\n\n")

utility_path = paste0("../UtilityFunctions/LoadAllFunctions.R")
source(utility_path)

SDF_file_path = "./SDF_files/"

user_OS = .Platform$OS.type # for OS specific system commands

## MAIN Loop
operation = TRUE
while (operation){

  ## Step 0: USER Data
  pf_SDF = list.files(SDF_file_path,pattern=".SDF")
  pf_sdf = list.files(SDF_file_path,pattern=".sdf")
  pfs = c(pf_SDF,pf_sdf)
  if(length(pfs)<1){
    operation = asm_ErrorFlagFatal("Step 0. No potential SDF files in SDF_files directory.")
    break
  } else {

    isError = TRUE
    while (isError){
      cat(paste0("There are ", length(pfs), " SDF files currently in the SDF_files directory.\n\n"))
      for(i in 1:length(pfs)){
        cat(paste0(i,": ",pfs[i],"\n"))
      }
      cat("\n")

      a <- readline(prompt="Choose SDF (integer value) for conversion: ")
      if (a %in% as.character(seq(1,length(pfs)))){
        file = pfs[as.numeric(a)]
        isError = FALSE
        cat("\n")
      } else {
        cat("\n")
        cat("INVALID INPUT. Try again.\n")
      }
    }
  }
  
  stime <- system.time({
  
  cat("Loading SDF file for conversion...\n\n")
  SDF = readLines(paste0(SDF_file_path,file))
  compoundBreak = "\\$\\$\\$\\$"
  Breaks = grep(compoundBreak, SDF); 
  nCompounds = length(Breaks);
     startPoints = c(1,(Breaks+1)); startPoints = startPoints[-length(startPoints)]; # removes the last break
     endPoints = Breaks-1;
  
     Name = character(nCompounds)
     InChIKey = character(nCompounds)
     Synonyms = character(nCompounds)
     Formula = character(nCompounds)
     MW = character(nCompounds)
     ExactMass = character(nCompounds)
     CASno = character(nCompounds)
     ID = character(nCompounds)
     Comment = character(nCompounds)
     NumPeaks = character(nCompounds)
     MS_Peaks = character(nCompounds)
     
     cat("Converting SDF to RDS:\n")
     pb <-txtProgressBar(min=0,max=nCompounds,initial=0,char="=",style=3)
     for(i in 1:nCompounds){
        data = SDF[startPoints[i]:endPoints[i]]
        
        iName = which(data==">  <NAME>")
          if(length(iName) >0) Name[i] = data[iName+1]
        iInChIKey = which(data==">  <INCHIKEY>")
          if(length(iInChIKey)>0) InChIKey[i] = data[iInChIKey+1]
        iSynonymStart = which(data==">  <SYNONYMS>")
          if(length(iSynonymStart)>0){
               b = grep(">  <",data)
               c = which((b - iSynonymStart) > 0)
               iSynonymEnd = b[c[1]] - 2;
               
               a = NULL;
               for(j in (iSynonymStart+1):iSynonymEnd){
                    a = c(a,data[j])
               }
               Synonyms[i] = list(a)
          }
        iFormula = which(data==">  <FORMULA>")
          if(length(iFormula)>0) Formula[i] = data[iFormula+1]
        iMW = which(data==">  <MW>")
          if(length(iMW)>0) MW[i] = data[iMW+1]
        iExactMass = which(data==">  <EXACT MASS>")
          if(length(iExactMass)>0) ExactMass[i] = data[iExactMass+1]
        iCASno = which(data==">  <CASNO>")
          if(length(iCASno)>0) CASno[i] = data[iCASno+1]
        iID = which(data==">  <ID>")
          if(length(iID)>0) ID[i] = data[iID+1]
        iComment = which(data==">  <COMMENT>")
          if(length(iComment)>0) Comment[i] = data[iComment+1]
        iNumPeaks = which(data==">  <NUM PEAKS>")
          if(length(iNumPeaks)>0) NumPeaks[i] = data[iNumPeaks+1]
        
        iPeakStart = which(data == ">  <MASS SPECTRAL PEAKS>") + 1;
          PeakList = NULL;
          for(j in iPeakStart:length(data)){
               a = data[j];
               if(a=="") break
               PeakList = c(PeakList,a);
          }
         MS_Peaks[i] = list(PeakList)
      
         setTxtProgressBar(pb,i)    
     }
     cat("\n\n")
     
     
     cat("Saving RDS file in convert_RDSfiles folder.\n\n")
     Library = as.data.table(cbind(Name,
                                   InChIKey,
                                   Synonyms,
                                   Formula,
                                   MW,
                                   ExactMass,
                                   CASno, 
                                   ID, 
                                   Comment,
                                   NumPeaks,
                                   MS_Peaks));
     
     corefilename = strsplit(file,"\\.")[[1]][1]
     RDSfilename = paste0(corefilename,".RDS")
     saveRDS(Library,RDSfilename)

  
     suppressMessages(file.move(RDSfilename,"converted_RDSfiles", overwrite = TRUE))
     
  })[3]
  
  cat(paste0("Library conversion complete in ",round(stime,2), " seconds for library of ", nCompounds, " entries.\n\n"))
  
  

  ## End code (check if another library is to be built?)
  potential_continue = c("Yes","yes","Y","y")
  potential_exit = c("No","no","N","n")
  isError = TRUE
  cat("\n")
  while (isError){
    a <- readline(prompt="Do you want to convert another SDF file to an R data table? (yes/no) ")
    if (a %in% potential_continue){
      isError = FALSE
    } else if (a %in% potential_exit){
      cat("\nExiting SDF2RDS converter program.\n\n")
      operation = FALSE
      isError =  FALSE
    } else {
      cat("INVALID INPUT. Do you want to convert another SDF file to an R data table? (yes/no) ")
    }
  }




}

#rm(list=ls()) # Clear environment after exiting program
