context("genome_generation")

test_that("malformed input gives error", {
    expect_error(
        hisat2_build(references=TRUE, outdir="./", force=TRUE, execute=FALSE)
    )
    expect_error(
        hisat2_build(references="nonexistent.fa",
                     outdir="./", force=TRUE, execute=FALSE)
    )
    expect_error(hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=1, force=TRUE, execute=FALSE
    ))
    expect_error(hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=c("dir1", "dir2"), force=TRUE, execute=FALSE
    ))

    tmp <- tempdir()
    dir.create(file.path(tmp, "mytestdir"), recursive=TRUE, showWarnings=FALSE)
    expect_error(hisat2_build(
        references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
        outdir=file.path(tmp, "mytestdir"), force=FALSE, execute=FALSE
    ))
})

test_that("correctly formatted input works", {
    tmp <- tempdir()
    expect_equal(
        hisat2_build(
            references=system.file("extdata/refs/chr1.fa", package="Rhisat2"),
            outdir=file.path(tmp, "hisat2indexdir"), force=TRUE, execute=FALSE
        ),
        paste(shQuote(file.path(system.file(package="Rhisat2"), "hisat2-build")),
              shQuote(system.file("extdata/refs/chr1.fa", package="Rhisat2")),
              shQuote(paste0(file.path(tmp, "hisat2indexdir"), "/index")))
    )
})
