context("splice-site-extraction")

test_that("splice site extraction works and is consistent with HISAT2 output", {
  tmp <- tempfile()
  extract_splice_sites(features=system.file("extdata/refs/genes.gtf",
                                            package="Rhisat2"),
                       outfile=tmp, min_length=5)
  tmp <- read.delim(tmp, header=FALSE, as.is=TRUE)
  his <- read.delim(system.file("extdata/refs/hisat2_splice_sites.txt",
                                package="Rhisat2"),
                    header=FALSE, as.is=TRUE)
  expect_equal(tmp, his)
})
