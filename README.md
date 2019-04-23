# paceR
## Pileup Allele CallER
Allows you to convert a vector of allelic depths into variant called genotypes 


## Install with devtools
```
devtools::install_github("elliefewings/paceR")
```
## Or download and install from parent directory
```
devtools::install("paceR")

#Load library
library(paceR)
```

## Examples of use
### Example1 - calling genotypes across vector
```
#Where the first number is the counts of reference reads and the second is alternative allele reads.
#Each string in the vector represents a different variant

allelicdepths <- c("5,2", "0", "10,10", "2,28", "15,7")

paceR.call(data=allelicdepths,
	minVafHet=0.1,
	maxVafHet=0.9,
	minDepth=10,
	form='num')

#> [1] NA NA  1  2  1
```

### Example2 - calling across multiple samples in a dataframe
```
df <- data.frame(CHROM=c(1, 2, 3, 4),
                 POS=c("1000", "2000", "3000", "4000"),
                 REF=c("A", "G", "C", "T"),
                 ALT=c("T", "C", "G", "A"),
                 S1=c("15,25", "0", "12", "8,8"),
                 S2=c("0,1", "12,50", "2", "52,3"))

#Apply paceR over columns of dataframe
df[5:6]  <- df[5:6] %>% apply(2, paceR.call)

df

#> CHROM  POS REF ALT S1 S2
#> 1     1 1000   A   T  1 NA
#> 2     2 2000   G   C NA  1
#> 3     3 3000   C   G  0 NA
#> 4     4 4000   T   A  1  0

```
