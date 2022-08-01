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

    ## execute alignment
    hisat2(sequences=list(system.file("extdata/reads/reads1.fastq",
                                      package="Rhisat2"),
                          system.file("extdata/reads/reads2.fastq",
                                      package="Rhisat2")),
           outfile=file.path(tmp, "alignments.sam"),
           index=file.path(outdir, "index"), force=TRUE,
           execute=TRUE, type="paired")
    expect_true(file.exists(file.path(tmp, "alignments.sam")))
    sam <- readLines(file.path(tmp, "alignments.sam"))
    expect_is(sam, "character")
    expect_length(sam, 11)
    expect_equal(sam[2], "@SQ\tSN:chr1\tLN:100000")
    sam <- strsplit(sam[4:11], "\t")
    expect_equal(length(unique(vapply(sam, "[", 1, FUN.VALUE = ""))), 4)
    expect_equal(sam[[1]][1], "HWUSI-EAS1513_0012:6:48:5769:946#0")
    expect_equal(sam[[1]][2], "65")
    expect_equal(sam[[1]][3], "chr1")
    expect_equal(sam[[1]][4], "819")
    expect_equal(sam[[1]][6], "101M")
    expect_equal(sam[[2]][1], "HWUSI-EAS1513_0012:6:48:5769:946#0")
    expect_equal(sam[[2]][2], "129")
    expect_equal(sam[[2]][3], "chr1")
    expect_equal(sam[[2]][4], "819")
    expect_equal(sam[[2]][6], "101M")


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
    ## check content
    expect_equal(v[2], "@SQ\tSN:chr1\tLN:100000")
    alnm <- strsplit(v[4:7], "\t")
    expect_equal(length(unique(vapply(alnm, "[", 1, FUN.VALUE = ""))), 4)
    names(alnm) <- vapply(alnm, "[", 1, FUN.VALUE = "")
    ## two of the reads don't align
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:9942:949#0/1`[2], "4")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:6908:952#0/1`[2], "4")
    ## the others do align
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:5769:946#0/1`[2], "0")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:5769:946#0/1`[3], "chr1")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:5769:946#0/1`[4], "819")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:5769:946#0/1`[6], "101M")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:8070:953#0/1`[2], "0")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:8070:953#0/1`[3], "chr1")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:8070:953#0/1`[4], "7543")
    expect_equal(alnm$`HWUSI-EAS1513_0012:6:48:8070:953#0/1`[6], "101M")
})
