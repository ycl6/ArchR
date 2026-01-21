#' Add Harmony Batch Corrected Reduced Dims to an ArchRProject
#' 
#' This function will add the Harmony batch-corrected reduced dimensions to an ArchRProject.
#' 
#' @param ArchRProj An `ArchRProject` object containing the dimensionality reduction matrix passed by `reducedDims`.
#' @param reducedDims The name of the `reducedDims` object (i.e. "IterativeLSI") to retrieve from the designated `ArchRProject`.
#' @param dimsToUse A vector containing the dimensions from the `reducedDims` object to use in clustering.
#' @param scaleDims A boolean value that indicates whether to z-score the reduced dimensions. The default is set to `NULL`, and will scale the dimensions 
#' based on the value of `scaleDims` when the `reducedDims` were originally created during dimensionality reduction. This idea was introduced by Timothy Stuart.
#' @param scaleBy A character string indicating if the reduced dimensions should be scaled in either the row direction (default) or the column direction when `scaleDims = TRUE`.
#' In the case of SVD matrix, the default is to perform scaling for each cell, rather than on the components as in the `signac::RunSVD` implementation.
#' You can use `scaleBy = "column"` to perform scaling for each component. Like, `scaleDims`, the saved value of `scaleBy` will be used if set to `scaleBy = NULL`.
#' @param corCutOff A numeric cutoff for the correlation of each dimension to the sequencing depth. If the dimension has a correlation
#' to sequencing depth that is greater than the `corCutOff`, it will be excluded from analysis.
#' @param name The name to store harmony output as a `reducedDims` in the `ArchRProject` object.
#' @param groupBy The name of the column in `cellColData` to use for grouping cells together for vars in harmony batch correction.
#' The value of `groupBy` is passed to the `vars_use` parameter in `harmony::HarmonyMatrix()`. When run through ArchR, this parameter
#' defines which variables to correct for during batch correction. See `harmony::HarmonyMatrix()` for more information.
#' @param verbose A boolean value indicating whether to use verbose output during execution of this function. Can be set to FALSE for a cleaner output.
#' @param force A boolean value that indicates whether or not to overwrite data in a given column when the value passed to `name` already
#' exists as a column name in `cellColData`.
#' @param ... Additional arguments to be provided to harmony::HarmonyMatrix
#' @export
#' 
#' @examples
#'
#' # Get Test ArchR Project
#' proj <- getTestProject()
#'
#' # Add Confounder
#' proj <- addCellColData(proj, data = proj$TSSEnrichment > 10, name = "TSSQC", cells = getCellNames(proj))
#'
#' # Run Harmony
#' proj <- addHarmony(proj, groupBy = "TSSQC")
#'
#' @export
addHarmony <- function(
  ArchRProj = NULL,
  reducedDims = "IterativeLSI",
  dimsToUse = NULL,
  scaleDims = NULL, 
  scaleBy = NULL,
  corCutOff = 0.75,
  name = "Harmony",
  groupBy = "Sample",
  verbose = TRUE,
  force = FALSE,
  ...
  ){

  .validInput(input = ArchRProj, name = "ArchRProj", valid = c("ArchRProj"))
  .validInput(input = reducedDims, name = "reducedDims", valid = c("character"))
  .validInput(input = dimsToUse, name = "dimsToUse", valid = c("numeric", "null"))
  .validInput(input = scaleDims, name = "scaleDims", valid = c("boolean", "null"))
  .validInput(input = scaleBy, name = "scaleBy", valid = c("character", "null"))
  .validInput(input = corCutOff, name = "corCutOff", valid = c("numeric", "null"))
  .validInput(input = name, name = "name", valid = c("character"))
  .validInput(input = groupBy, name = "groupBy", valid = c("character"))
  .validInput(input = verbose, name = "verbose", valid = c("boolean"))
  .validInput(input = force, name = "force", valid = c("boolean"))

  if(!is.null(ArchRProj@reducedDims[[name]])){
    if(!force){
      stop("Error name in reducedDims Already Exists! Set force = TRUE or pick a different name!")
    }
  }

  .requirePackage("harmony", source = "cran")
  harmonyParams <- list(...)
  harmonyParams$data_mat <- getReducedDims(
    ArchRProj = ArchRProj, 
    reducedDims = reducedDims, 
    dimsToUse = dimsToUse, 
    scaleDims = scaleDims, 
    scaleBy = scaleBy,
    corCutOff = corCutOff
  )
  harmonyParams$verbose <- verbose
  harmonyParams$meta_data <- data.frame(getCellColData(
    ArchRProj = ArchRProj, 
    select = groupBy)[rownames(harmonyParams$data_mat), , drop = FALSE])
  harmonyParams$do_pca <- FALSE
  harmonyParams$vars_use <- groupBy
  harmonyParams$plot_convergence <- FALSE

  # Call Harmony
  harmonyMat <- suppressWarnings(do.call(HarmonyMatrix, harmonyParams))
  harmonyParams$data_mat <- NULL
  ArchRProj@reducedDims[[name]] <- SimpleList(
    matDR = harmonyMat, 
    params = harmonyParams,
    date = Sys.time(),
    scaleDims = NA,  # do not scale dims after
    scaleBy = "row", # set to default
    corToDepth = NA
  )
  ArchRProj
}

