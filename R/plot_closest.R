#' Plot residues at certain distance (angstroms) from specified residue
#'
#' @param pdb PDB name ID string
#' @param ch PDB chain string (default "A")
#' @param res Residue position
#' @param a Distance in angstroms (default 8 angstroms)
#'
#' @return A scatter plot where x = distance to specified residue.
#' @export
#'
#' @examples
#' x <- plot_closest("4q21", "A", 15, 6)
#' y <- plot_closest("1XI4", "B", 312)
#'
#'
#'
plot_closest <- function(pdb, ch = "A", res, a = 8){

  pdb_struct <- bio3d::read.pdb(pdb)  # read pdb from www.rcsb.org

  # pdb_struct is a list of 8 elements of different types (list, double, character, etc...)

  ## The filter() function is used to subset a data frame,
  ## retaining all rows that satisfy the conditions

  ## if chain was set
  if (!is.null(ch)){
    filter_chain <- dplyr::filter(pdb_struct$atom, chain == ch)
    # pdb_struct$atom contains information of each of the atoms in the protein,
    result <- dplyr::filter(filter_chain, elety == "CA")

    # make new matrix with xyz coordinates of all residues
    mx <- result[,c("x","y","z")]
    # make new matrix with xyz coordinates of target residue
    res_mx <- mx[res,]
  }

  else {
    # default chain = A
    result <- dplyr::filter(pdb_struct$atom, chain == "A")
    result <- dplyr::filter(filter_chain, elety == "CA")
    mx <- result[,c("x","y","z")]
    res_mx <- mx[res,]
  }

  # count total number of residues in protein
  res_total <- nrow(mx)
  dist_list <- matrix(0, res_total, 2) # initialize matrix with two columns and rows = total residues

  for (val in 1:res_total)
  {
    # calculate euclidean distance
    eucl_dist = sqrt((mx[val,1] - res_mx[1,1])^2 + (mx[val,2] - res_mx[1,2])^2 + (mx[val,3] - res_mx[1,3])^2)
    dist_list[val,1] <- val
    dist_list[val,2] <- eucl_dist
  }

  dist_filt <- dist_list[dist_list[,2] <= a,, drop=FALSE]
  df <- data.frame(dist_filt)

  fig <- plotly::plot_ly(data=df, x=df[,2], y=1, color = df[,2],
                customdata = df[,1], type = "scatter", mode = "markers",
                marker = list(size=15, line = list(color = 'rgb(0,0,0)', width = 1)),
                hoverinfo=FALSE,
                hovertemplate = paste("<b>residue pos: </b>%{customdata}",
                                      "<extra></extra>"))

   # %>%
   #  layout(title = 'Closest residues', plot_bgcolor = "#e5ecf6",
   #         xaxis = list(title = "Distance (Å)",zeroline = FALSE,showline = FALSE, dtick=1),
   #         yaxis =list(showticklabels=FALSE))

  return(fig)
}
