#' @title Grab nii file stubname
#' @description Quick helper function to strip off .nii or .nii.gz 
#' from filename
#' @return A character vector with the same length as \code{x}
#' @param x character vector of filenames ending in .nii or .nii.gz
#' @param bn Take \code{\link{basename}} of file?
#' @export
nii.stub = function(x, bn=FALSE){
  nx = names(x)
  x = path.expand(x)
  x = trimws(x)
  stub = gsub("\\.gz$", "", x)
  stub = gsub("\\.nii$", "", stub)
  if (bn) stub = basename(stub)
  names(stub) = nx
  return(stub)
}
