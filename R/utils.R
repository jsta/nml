is_nml_file <- function(x){
 tools::file_ext(x) == "nml"
}

ascii_only <- function(file){
  response <- what_ascii(file)

  if (length(response) > 0){
    return(FALSE)
  } else {
    return(TRUE)
  }
}

#' @importFrom utils capture.output
what_ascii <- function(file){
  response <- capture.output(tools::showNonASCIIfile(file))
  return(response)
}

buildVal	<-	function(textLine, lineNum, blckName){
  #-----function appends nml list with new values-----
  # remove all text after comment string
  textLine	<-	strsplit(textLine,'!')[[1]][1]

  if (!any(grep("=", textLine))){
    stop(c("no hanging lines allowed in .nml, used ",textLine,'.\nSee line number:',lineNum,' in "&',blckName,'" section.'))
  }
  params	<-	strsplit(textLine,"=") # break text at "="
  parNm	  <-	params[[1]][1]
  parVl	  <-	params[[1]][2]
  # figure out what parval is...if string, remove quotes and keep as string
  # ***for boolean text, use "indentical" so that 0!= FALSE
  # can be: string, number, comma-sep-numbers, or boolean

  # special case for date:
  if (is.na(parVl)){
    stop('Empty values after "', textLine, '" on line ', lineNum,
         '. \nPerhaps the values are on the next line?', call. = FALSE)
  }
  if (nchar(parVl>17) & substr(parVl,14,14)==':' & substr(parVl,17,17)==':'){
    parVl<-paste(c(substr(parVl,1,11),' ',substr(parVl,12,nchar(parVl))),collapse='')
  }
  if (any(grep("'",parVl))){

    parVl	<-	gsub("'","",parVl)
  }else if (any(grep("\"",parVl))){
    parVl  <-	gsub("\"","",parVl)
  }else if (isTRUE(grepl(".true.",parVl) || grepl(".false.",parVl))){
    logicals <- unlist(strsplit(parVl,","))
    parVl <- from.glm_boolean(logicals)
  }else if (any(grep(",",parVl))){	# comma-sep-nums
    parVl	<-	c(as.numeric(unlist(strsplit(parVl,","))))
  }else {	# test for number
    ret <- base::tryCatch(as.numeric(parVl), error = function(e) NULL)
    if (is.na(ret)) { # no success
        # fallback value: keep as string; nothing to do
    } else {
        parVl	<-	as.numeric(parVl)
    }
  }
  lineVal	<-	list(parVl)
  names(lineVal)	<-	parNm
  return(lineVal)
}

#' go from glm2.nml logical vectors to R logicals
#'
#' @param values a vector of strings containing either .false. or .true.
#' @return a logical vector
#' @keywords internal
from.glm_boolean <- function(values){

  logicals <- sapply(values, FUN = function(x){
    if (!isTRUE(grepl(".true.", x) || grepl(".false.", x))){
      stop(x, ' is not a .true. or .false.; conversion to TRUE or FALSE failed.',
           call. = FALSE)
    }
    return(ifelse(isTRUE(grepl(".true.", x)), TRUE, FALSE))
  })
  return(as.logical(logicals))
}

to.glm_boolean <- function(values){
  val.logical <- values
  values[val.logical] <- '.true.'
  values[!val.logical] <- '.false.'
  return(values)
}

.nml <- function(list_obj){
  nml <- list_obj
  class(nml) <- "nml"
  invisible(nml)
}
