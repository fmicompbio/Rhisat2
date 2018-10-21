## Rhisat2

The `Rhisat2` R package provides an R interface to the [`hisat2`](https://ccb.jhu.edu/software/hisat2/index.shtml) spliced short-read aligner by [Kim et al. (2015)](https://www.nature.com/articles/nmeth.3317). The package contains wrapper functions to create a genome index and to perform the read alignment to the generated index.

### Source code
The source code for hisat2 v2.1.0 was obtained from [https://ccb.jhu.edu/software/hisat2/index.shtml](https://ccb.jhu.edu/software/hisat2/index.shtml) on October the 17, 2018.

Based on the discussion at [https://github.com/BenLangmead/bowtie2/issues/81](https://github.com/BenLangmead/bowtie2/issues/81), the following small modification was made to allow compilation:

In the file `src/aligner_result.cpp`, line 1267

	flag > 0

was replaced by

	flag[0] != '\0'
	
