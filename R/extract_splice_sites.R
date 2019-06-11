#' Extract splice sites from annotation
#'
#' This function extracts splice sites from an annotation object (a gtf/gff3
#' file, a \code{GRanges} object or a \code{TxDb} object) and saves them in a
#' text file formatted such that it can be directly used with HISAT2, by
#' providing it as the argument \code{known-splicesite-infile}.
#'
#' @param features Either the path to a gtf/gff3 file containing the genomic
#'   features, a GRanges object or a TxDb object.
#' @param outfile Character scalar. The path to a text file where the extracted
#'   splice sites will be written.
#' @param min_length Integer scalar. Junctions corresponding to introns below
#'   this size will not be reported. The default setting in HISAT2 is 5.
#'
#' @author Charlotte Soneson
#'
#' @export
#'
#' @references
#' Kim D, Langmead B and Salzberg SL. HISAT: a fast spliced aligner with low
#' memory requirements. Nature Methods 12:357-360 (2015).
#'
#' @return Nothing is returned, but the splice junction coordinates are written
#'   to \code{outfile}.
#'
#' @examples
#' tmp <- tempfile()
#' extract_splice_sites(features=system.file("extdata/refs/genes.gtf",
#'                                           package="Rhisat2"),
#'                      outfile=tmp, min_length=5)
#'
#' @importFrom GenomicFeatures makeTxDbFromGFF
#' @importFrom SGSeq convertToTxFeatures type
#' @importFrom GenomicRanges start end width seqnames strand
#' @importFrom methods is
#' @importFrom utils write.table
#'
extract_splice_sites <- function(features, outfile, min_length=5) {
    ## Create TxDb object from the input features
    if (methods::is(features, "character")) {
        if (!file.exists(features)) {
            stop("'features' is a character string, but the corresponding ",
                 "file does not exist.")
        }
        tryCatch({
            txdb <- GenomicFeatures::makeTxDbFromGFF(features, format = "auto")
        }, error = function(e) {
            stop("'features' is a character string corresponding to an ",
                 "existing file, but the file is not compatible with ",
                 "'makeTxDbFromGFF'.")
        })
    } else if (methods::is(features, "TxDb")) {
        txdb <- features
    } else if (methods::is(features, "GRanges")) {
        txdb <- GenomicFeatures::makeTxDbFromGRanges(features)
    } else {
        stop("The 'features' argument is not in one of the supported ",
             "formats (path to gtf/gff3 file, TxDb, GRanges).")
    }

    ## Extract junctions
    txf <- SGSeq::convertToTxFeatures(txdb)
    txf <- txf[SGSeq::type(txf) == "J"]

    ## hisat2 keeps only junctions where the intron is at least a certain length
    ## (5bp by default, note that width() returns the intron length + the two
    ## flanking bases)
    txf <- txf[GenomicRanges::width(txf) >= (min_length + 2)]

    ## Save junctions to a text file
    df <- data.frame(chr = as.character(GenomicRanges::seqnames(txf)),
                     start = GenomicRanges::start(txf) - 1,
                     end = GenomicRanges::end(txf) - 1,
                     strand = GenomicRanges::strand(txf),
                     stringsAsFactors = FALSE)
    df <- df[order(df$chr, df$start, df$end, df$strand), ]

    ## Make sure that scientific notation is not used in the text file
    df$start <- as.integer(df$start)
    df$end <- as.integer(df$end)

    utils::write.table(
        df, file = outfile,
        row.names = FALSE, col.names = FALSE, quote = FALSE, sep = "\t"
    )

}
