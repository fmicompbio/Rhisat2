context("read-alignment")

test_that("malformed input gives error", {
    tmp <- tempdir()
    outdir <- file.path(tmp, "hisat2indexdir")
    hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=outdir, force=TRUE, execute=TRUE
    )
    expect_error(hisat2(sequences=TRUE, outfile="file1",
                        index=file.path(outdir, "index")))
    expect_error(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=c("file1", "file2"),
                        index=file.path(outdir, "index")))
})
