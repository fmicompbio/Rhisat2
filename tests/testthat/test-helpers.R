context("test_helpers")

test_that(".createFlags works", {
    # expect_equal(
    #     .createFlags(flagList=list(runThreadN=3, runMode="genomeGenerate",
    #                                toInclude=TRUE, toExclude=FALSE,
    #                                vectorArg=c("file1", "file2"))),
    #     "--toInclude --runThreadN 3 --runMode genomeGenerate --vectorArg file1 file2"
    # )
    #
    # expect_error(
    #     .createFlags(flagList=list(3, x=4))
    # )
})

test_that(".starBin works", {
    # expect_error(
    #     .starBin(bin="STAR", args="")
    # )
})
