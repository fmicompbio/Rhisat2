## Rhisat2
[![R build status](https://github.com/fmicompbio/Rhisat2/workflows/R-CMD-check/badge.svg)](https://github.com/fmicompbio/Rhisat2/actions)
[![Code coverage](https://codecov.io/github/fmicompbio/Rhisat2/coverage.svg?branch=master)](https://codecov.io/github/fmicompbio/Rhisat2)

The `Rhisat2` R package provides an R interface to the [`hisat2`](https://ccb.jhu.edu/software/hisat2/index.shtml) spliced short-read aligner by [Kim et al. (2015)](https://www.nature.com/articles/nmeth.3317). The package contains wrapper functions to create a genome index and to perform the read alignment to the generated index.

### Source code

#### Rhisat2 v1.19.1 and newer

To allow compilation on Linux aarch64, the Makefile obtained from hisat2 was adapted to exclude unsupported flags (`-m64` and `-msse2`) on this platform. In addition, the `mask2iupac` array was converted from a `char` to a `signed char`. See [here](https://github.com/fmicompbio/Rhisat2/pull/5/files) for the precise changes. 

#### Rhisat2 v1.13.1 and newer

In Rhisat2 v1.13.1 and onwards, hisat2 was updated to v2.2.1, which was obtained from [https://github.com/DaehwanKimLab/hisat2/releases](https://github.com/DaehwanKimLab/hisat2/releases) on July 27, 2022. 

Furthermore, Rhisat2 now includes parts of the SIMD Everywhere header library (https://github.com/simd-everywhere/simde) to support compilation on arm64, based on the implementation by Michael R. Crusoe <crusoe@debian.org> for the hisat2 (2.2.1-3) debian package (simde patch in http://deb.debian.org/debian/pool/main/h/hisat2/hisat2_2.2.1-3.debian.tar.xz, also forwarded in https://github.com/DaehwanKimLab/hisat2/pull/251).

#### Rhisat2 versions up to v1.13.0

The source code for hisat2 v2.1.0 was obtained from [https://ccb.jhu.edu/software/hisat2/index.shtml](https://ccb.jhu.edu/software/hisat2/index.shtml) on October 17, 2018.

Based on the discussion at [https://github.com/BenLangmead/bowtie2/issues/81](https://github.com/BenLangmead/bowtie2/issues/81), the following small modification was made to allow compilation:

In the file `src/aligner_result.cpp`, line 1267

	flag > 0

was replaced by

	flag[0] != '\0'
	
