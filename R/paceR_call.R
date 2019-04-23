#' A function to convert allelic depths to genotypes
#'
#' This function allows you to convert a vector of allelic depths into variant called genotypes.
#' @param data Object containing comma seperated allelic depths. Assumes ref,alt format.
#' @param minVafHet The minimum variant allele frequency allowed for a variant to be called heterozygous.
#' A variant with an allele frequency below this will be called homozygous reference.
#' @param maxVafHet The maximum variant allele frequency allowed for a variant to be called heterozygous. 
#' A variant with an allele frequency above this will be called homozygous alternative.
#' @param minDepth The minimum number of reads covering a variant to allow it to be called. 
#' Uncallable regions will be recorded as NA
#' @param form Set to either
#' itemize{
#' item 'num' -- numeric format where homozygous reference is 0, heterozygous is 1, and homozygous alternative is 2.
#' item 'char' -- character format where homozygous reference is 0/0, heterozygous is 0/1, and homozygous alternative is 1/1.}
#' @examples
#' allelicdepths <- c("5,2", "0", "10,10", "2,28", "15,7")
#' 
#' paceR.call(data=allelicdepths,
#'  minVafHet=0.1,
#'  maxVafHet=0.9,
#'  minDepth=10,
#'  form='num')
#'  
#' [1] NA NA  1  2  1
#' @export

paceR.call = function(data= NA,
                minVafHet=0.1,
                maxVafHet=0.9,
                minDepth=10,
                form='num') {
  #Check format is in correct format
  if (form != 'num' & form != 'char') {
    print("Incorrect input for the form parameter, please specify form='num' or form='char'")
    print("See paceR documentation for details")
    }
  #Set output
  homref <- ifelse(form == "num", 0, "0/0")
  het <- ifelse(form == "num", 1, "0/1")
  homalt <- ifelse(form == "num", 2, "1/1")
  ref <- sapply(strsplit(data, ","), '[', 1) %>% as.numeric()
  ref[is.na(ref)] <- 0
  alt <- sapply(strsplit(data, ","), '[', 2) %>% as.numeric()
  alt[is.na(alt)] <- 0
  vaf <- alt/(ref+alt)
  gt <- vaf
  gt[vaf > maxVafHet] <- homalt
  gt[vaf >= minVafHet & vaf <= maxVafHet] <- het
  gt[vaf < minVafHet] <- homref
  gt[(ref+alt) < minDepth] <- NA

return(gt)
}
