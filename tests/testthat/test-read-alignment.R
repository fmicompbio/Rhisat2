context("read-alignment")

test_that("malformed input gives error", {
    tmp <- tempdir()
    outdir <- file.path(tmp, "hisat2indexdir")
    hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=outdir, force=TRUE, execute=TRUE
    )

    ## malformed sequences
    expect_error(hisat2(sequences=TRUE, outfile="file1",
                        index=file.path(outdir, "index")))

    ## malformed outfile
    expect_error(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=c("file1", "file2"),
                        index=file.path(outdir, "index")))

    ## malformed sequences, c=TRUE
    expect_error(hisat2(sequences=list(TRUE, TRUE), outfile="file1", c=TRUE,
                        type="paired", index=file.path(outdir, "index")))

    ## malformed index
    expect_error(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=file.path(tmp, "alignments.sam"),
                        index=1, force=TRUE,
                        execute=FALSE, type="single"))

    ## outfile is not overwritten if it exists and force=FALSE
    write.table(1, file=file.path(tmp, "alignments2.sam"))
    expect_error(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=file.path(tmp, "alignments2.sam"),
                        index=file.path(outdir, "index"), force=FALSE,
                        execute=FALSE, type="single", strict=TRUE))
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

    ## single-end reads but with type="paired" should not work
    expect_error(hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                              package="Rhisat2"),
                        outfile=file.path(tmp, "alignments.sam"),
                        index=file.path(outdir, "index"), force=TRUE,
                        execute=FALSE, type="paired"))

    ## paired-end reads but with type="single" should not work
    expect_error(hisat2(sequences=list(system.file("extdata/reads/reads1.fastq",
                                                   package="Rhisat2"),
                                       system.file("extdata/reads/reads2.fastq",
                                                   package="Rhisat2")),
                        outfile=file.path(tmp, "alignments.sam"),
                        index=file.path(outdir, "index"), force=TRUE,
                        execute=FALSE, type="single"))

    ## missing outfile (return alignments as vector)
    v <- hisat2(sequences=system.file("extdata/reads/reads1.fastq",
                                      package="Rhisat2"),
                index=file.path(outdir, "index"))
    expect_is(v, "character")
    expect_length(v, 7)
})
