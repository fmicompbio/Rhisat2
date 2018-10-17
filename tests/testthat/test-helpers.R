context("test_helpers")

test_that(".createFlags works", {
    expect_equal(
        .createFlags(
            flagList=list(p=3, q=TRUE, phred33=TRUE, `no-softclip`=TRUE,
                          secondary=FALSE, vectorArg=c("file1", "file2"))),
        "-q --phred33 --no-softclip -p 3 --vectorArg file1,file2"
    )

    expect_error(
        .createFlags(flagList=list(3, x=4))
    )
})

test_that(".hisat2Bin works", {
    expect_error(
        .hisat2Bin(bin="hisat2-build", args="")
    )
    expect_error(
        .hisat2Bin(bin="hisat2", args="")
    )
    expect_equal(
        .hisat2Bin(bin="hisat2", args="-1 file1 -2 file2", execute=FALSE),
        paste(shQuote(file.path(system.file(package="Rhisat2"), "hisat2")),
              "-1 file1 -2 file2")
    )
})
