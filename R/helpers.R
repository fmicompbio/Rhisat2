#' Call the HISAT2 binary with additional arguments.
#'
#' Adapted from the Rbowtie package
#'
#' @keywords internal
#'
#' @param bin The name of the binary, either hisat2 or hisat2-build
#' @param execute Logical scalar, whether to execute the command. If FALSE,
#'   return a string with the shell command.
#' @param args A character string containing the arguments that will be passed
#'   to the binary
#'
#' @return If \code{execute} is TRUE, returns the console output of running the
#'   hisat2 command. If \code{execute} is FALSE, returns the shell command.
#'
.hisat2Bin <- function(bin=c("hisat2", "hisat2-build"), args="", execute=TRUE) {
    if (is.null(args) || args=="") {
        stop("The hisat2 binaries need to be called with additional arguments")
    }
    args <- gsub("^ *| *$", "", args)
    bin <- match.arg(bin)
    call <- paste(shQuote(file.path(system.file(package="Rhisat2"), bin)), args)
    if (!execute) {
        return(call)
    }
    output <- system(call, intern=TRUE)
    return(output)
}

#' Create flags
#'
#' Given a named list of argument values, generate a single character string
#' containing all arguments and values, separated by single spaces. Logical
#' values imply that the argument is either included (without a value) or
#' excluded in the character string. For vector-valued arguments, the values
#' will be separated by single spaces in the final string.
#'
#' Adapted from the Rbowtie package
#'
#' @keywords internal
#'
#' @param flagList A named list of argument values. Vectors will be collapsed
#'   and separated by a space
#'
#' @return A character string with the arguments and their values.
#'
.createFlags <- function(flagList) {
    if (!length(flagList)) {
        return("")
    }
    if (is.null(names(flagList)) || any(names(flagList) == "")) {
        stop("Unable to create command line arguments from input.")
    }

    ## Logical values of flagList require special attention. If flagList
    ## contains a logical entry with value TRUE, the code below will append -X
    ## or --XX to the argument string (one or two dashes depending on whether
    ## the name of the variable has one or more characters). If the logical
    ## entry has value FALSE, the argument will be excluded from the final
    ## string.
    logFlags <- vapply(flagList, is.logical, FALSE)
    flags <- NULL
    if (any(logFlags)) {
        fnames <- names(flagList)[logFlags][vapply(flagList[logFlags],
                                                   function(x) x[1], FALSE)]
        flags <- paste(vapply(fnames, function(x)
            ifelse(nchar(x) == 1, sprintf("-%s", x), sprintf("--%s", x)), ""),
            collapse=" ")
    }

    ## For the non-logical values of flagList, add '-X value' or '--XX value' to
    ## the final argument string.
    fnames <- vapply(names(flagList)[!logFlags],
                     function(x) ifelse(nchar(x)==1, sprintf("-%s", x),
                                        sprintf("--%s", x)), "")
    flags <- paste(flags, paste(fnames,
                                vapply(flagList[!logFlags], paste,
                                       collapse=" ", ""),
                                collapse=" ", sep=" "), collapse=" ")
    return(gsub("^ *| *$", "", flags))
}


