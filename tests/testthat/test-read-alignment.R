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

test_that("correctly formatted input works", {
    tmp <- tempdir()
    outdir <- file.path(tmp, "hisat2indexdir")
    hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=outdir, force=TRUE, execute=TRUE
    )
    ## single-end reads
    expect_equal(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=file.path(tmp, "alignments.sam"),
                        index=file.path(outdir, "index"), force=TRUE,
                        execute=FALSE, type="single"),
                 paste(shQuote(file.path(system.file(package="Rhisat2"), "hisat2")),
                       "-x", shQuote(file.path(outdir, "index")),
                       "-U", shQuote(system.file("extdata/reads/reads1.fastq",
                                                 package="Rhisat2")),
                       "-S", shQuote(file.path(tmp, "alignments.sam"))))

    ## paired-end reads
    expect_equal(hisat2(sequences=list(system.file("extdata/reads/reads1.fastq",
                                                   package="Rhisat2"),
                                       system.file("extdata/reads/reads2.fastq",
                                                   package="Rhisat2")),
                        outfile=file.path(tmp, "alignments.sam"),
                        index=file.path(outdir, "index"), force=TRUE,
                        execute=FALSE, type="paired"),
                 paste(shQuote(file.path(system.file(package="Rhisat2"), "hisat2")),
                       "-x", shQuote(file.path(outdir, "index")),
                       "-1", shQuote(system.file("extdata/reads/reads1.fastq",
                                                 package="Rhisat2")),
                       "-2", shQuote(system.file("extdata/reads/reads2.fastq",
                                                 package="Rhisat2")),
                       "-S", shQuote(file.path(tmp, "alignments.sam"))))
})
