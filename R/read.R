#'@title read in an *.nml file
#'@description
#'read in na nml file and create a list.  \cr
#'
#'
#'@param nml_file a string with the path to an nml file
#'@return an nml list
#'@author
#'Jordan S. Read
#'@examples \dontrun{
#'fpath <- system.file("extdata/glm2.nml", package = "nml")
#'sim_nml <- read_nml(fpath)
#'print(sim_nml)
#'}
#'@export
read_nml  <-	function(nml_file){
  nml_file <- nml_path_norm(nml_file)

  if (!ascii_only(nml_file)){
    stop('non-ASCII characters found in nml file on line ', what_ascii(nml_file))
  }
  # skip all commented lines, return all variables and associated values
  # requires NO return line variables (all variables must be completely defined on a single line)
  c <- file(nml_file,"r")
  fileLines <- readLines(c)
  close(c)
  lineStart	<-	substr(trimws(fileLines, which = 'left'),1,1)
  # ignore comment lines or empty lines
  ignoreLn	<-	lineStart=='!' | fileLines==""
  lineStart	<-	lineStart[!ignoreLn]
  fileLines	<-	fileLines[!ignoreLn]
  # find all lines which start with "&" * requires FIRST char to be value

  lineIdx		<- seq(1,length(lineStart))
  blckOpen	<-	lineIdx[lineStart=="&"]
  blckClse	<-	lineIdx[lineStart=="/"]


  nml <- list()
  for (i in 1:length(blckOpen)){
    blckName	<-	substr(fileLines[blckOpen[i]],2,nchar(fileLines[blckOpen[i]]))
    blckName <- gsub("\\s", "", blckName)
    oldNms	<-	names(nml)
    nml[[i]]	<-	list()
    names(nml)	<-	c(oldNms,blckName)

    carryover = ''

    for (j in (blckOpen[i]+1):(blckClse[i]-1)){

      textLine	<-	paste(carryover, gsub("\t","",gsub(" ","",fileLines[j])), sep='')
      if(substr(textLine,1,1)!='!'){
        # Add a check here, sometimes, if there is a hanging comma,
        #and only sometimes that means add next row
        if(substr(textLine,nchar(textLine), nchar(textLine)) == ',' &&
           j+1 <= length(fileLines) && !any(grep("=",fileLines[j+1])) && !any(grep("/",fileLines[j+1]))){

          carryover = textLine
          next
        }else{
          carryover = ''
        }
        # else, line is commented out
        lineVal	<-	buildVal(textLine, lineNum=j, blckName)
        nml[[i]]	<-	c(nml[[i]],lineVal)
      }
    }
  }
  nml <- .nml(nml)
  return(nml)
}

nml_path_norm <- function(nml_file){
  if (!is_nml_file(nml_file)){
    warning(nml_file, ' is not of file type .nml')
  }

  return(nml_file)
}
