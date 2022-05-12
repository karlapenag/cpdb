#' Compute distance matrix
#'
#' @param pdb PDB name ID string
#' @param ch PDB chain string (default "A")
#' @param res Residue position
#' @param a Distance in angstroms (default 8 angstroms)
#'
#' @return A list with the residue contacts.
#' @export
#'
#' @examples
#' x <- get_contacts("4q21", "A", 15, 6)
#' y <- get_contacts("1XI4", "B", 312)
#'
#'
#'
get_contacts <- function(pdb, ch = "A", res, a = 8){
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
    filter_chain <- dplyr::filter(pdb_struct$atom, chain == "A")
    result <- dplyr::filter(filter_chain, elety == "CA")
    mx <- result[,c("x","y","z")]
    res_mx <- mx[res,]
  }
  # count total number of residues in protein
  res_total <- nrow(mx)
  # new list
  dist_list <- list()

  for (val in 1:res_total)
  {
    # calculate euclidean distance
    eucl_dist = sqrt((mx[val,1] - res_mx[1,1])^2 + (mx[val,2] - res_mx[1,2])^2 + (mx[val,3] - res_mx[1,3])^2)
    dist_list <- c(dist_list, eucl_dist) # append each eucl_dist in dist_list
  }

  contacts <- which(dist_list <= a) # get index (residue position) of the residues that are no longer than 8 angstroms away from the specified residue
  contacts_filt <- contacts[!contacts %in% res] # remove the specified residue
  print('The residue contacts positions are:')
  return(contacts_filt)
}
