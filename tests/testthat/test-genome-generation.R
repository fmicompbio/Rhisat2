context("genome_generation")

test_that("malformed input gives error", {
    # expect_error(starGenomeGenerate(genomeFastaFiles=TRUE,
    #                                 genomeDir="./", force=TRUE, execute=FALSE))
    # expect_error(starGenomeGenerate(genomeFastaFiles="nonexistent.fa",
    #                                 genomeDir="./", force=TRUE, execute=FALSE))
    # expect_error(starGenomeGenerate(
    #     genomeFastaFiles=system.file("extdata/refs/chr1.fa", package="RSTAR"),
    #     genomeDir=1, force=TRUE, execute=FALSE
    # ))
    # expect_error(starGenomeGenerate(
    #     genomeFastaFiles=system.file("extdata/refs/chr1.fa", package="RSTAR"),
    #     genomeDir=c("dir1", "dir2"), force=TRUE, execute=FALSE
    # ))
    #
    # tmp <- tempdir()
    # dir.create(file.path(tmp, "mytestdir"), recursive=TRUE, showWarnings=FALSE)
    # expect_error(starGenomeGenerate(
    #     genomeFastaFiles=system.file("extdata/refs/chr1.fa", package="RSTAR"),
    #     genomeDir=file.path(tmp, "mytestdir"), force=FALSE, execute=FALSE
    # ))
})

test_that("correctly formatted input works", {
    # tmp <- tempdir()
    # expect_equal(
    #     starGenomeGenerate(
    #         genomeFastaFiles=system.file("extdata/refs/chr1.fa", package="RSTAR"),
    #         genomeDir=file.path(tmp, "starindexdir"), force=TRUE, execute=FALSE
    #     ),
    #     paste(shQuote(file.path(system.file(package="RSTAR"), "STAR")),
    #           "--runMode genomeGenerate --genomeDir",
    #           shQuote(file.path(tmp, "starindexdir")), "--genomeFastaFiles",
    #           shQuote(system.file("extdata/refs/chr1.fa", package="RSTAR")))
    # )
})
