#' Create input indicator(s)
#' 
#' The function creates the input indicators from the inputs and the outputs.
#' @param input_matrix A named (primary) input(s) vector or matrix created by \code{\link{primary_input_get}}
#' @param output_vector A named output vector created by \code{\link{output_get}}.  
#' @param digits Rounding digits, if omitted, no rounding takes place.  
#' @importFrom dplyr select 
#' @examples  
#' de_output <- output_get ( source = "germany_1990", geo = "DE",
#'                          year = 1990, unit = "MIO_EUR", 
#'                          households = FALSE, labelling = "iotables")
#' 
#' de_emp <- primary_input_get ( input = "compensation_employees",
#'                              source = "germany_1990", geo = "DE",
#'                              year = 1990, unit = "MIO_EUR", 
#'                              households = FALSE, labelling = "iotables")
#'
#' de_emp_indicator <- input_indicator_create ( input_matrix = de_emp, 
#'                                            output_vector = de_output )
#' @export

input_indicator_create <- function ( input_matrix,
                                     output_vector,
                                     digits = NULL ) { 
  CPA_G47 <- CPA_T <- CPA_U <- CPA_L68A <- NULL 
  
  if (! is.null(digits)) {
    if (digits<0) digits <- NULL
  }
  
  if ( ! all ( names ( output_vector) %in% names ( input_matrix )) ) {
    
    if ( any( names(output_vector) [ ! names ( output_vector ) %in%
                                names ( input_matrix )]  == "P3_S14" ) )  {
      input_matrix$P3_S14 <- 0  #case when only households are missing (type-II)
    } 
    
    problem_cols <-  names(input_matrix) [ ! names ( input_matrix ) %in% names ( output_vector )]
    problem_cols
    if ( ! length(problem_cols) == 0 ) {
    
    if ( "CPA_G47" %in% problem_cols ) { input_matrix <- dplyr::select ( input_matrix, -CPA_G47 )}
    if ( "CPA_T" %in% problem_cols ) { input_matrix <- dplyr::select ( input_matrix, -CPA_T )}
    if ( "CPA_U" %in% problem_cols ) { input_matrix <- dplyr::select ( input_matrix, -CPA_U )}
    if ( "CPA_L68A" %in% problem_cols ) { input_matrix <- dplyr::select ( input_matrix, -CPA_L68A  )}
    if ( "TOTAL" %in% problem_cols ) { input_matrix <- dplyr::select ( input_matrix, -TOTAL )}
     
    problem_cols <-  names(input_matrix) [ ! names ( input_matrix ) %in% names ( output_vector )]
    
    if ( length (problem_cols) > 0 )  
      stop ( "Some industries / products do not have input data. ")
    }
  }

  input_matrix_inputed <- input_matrix
  input_matrix <- input_matrix[names(output_vector)]
  
  eps_changes <- 2:ncol(input_matrix)
  no_eps <- which ( names ( input_matrix ) %in% c("households", "P3_S14"))
  if (length (no_eps) > 0 ) {
    eps_changes <- eps_changes [ -(no_eps-1) ] #remove household element from loop var
  }
  
  #Not elegant, should be further optimized with vapply 
  for ( j in eps_changes ) {
    if ( as.numeric(output_vector[j])==0 ) {
      output_vector[j] <- 0.000001  #avoid division by zero 
      warning ("Warning: Zero output in ", names(output_vector)[j], " is changed to 0.000001.")
      }
    if (is.null(digits)) {
      input_matrix[,j] <- input_matrix[,j] / as.numeric(output_vector[j])  #tibble to numeric conversion
    } else {
      input_matrix[,j] <- round(input_matrix[,j] / as.numeric(output_vector[j]), digits = digits )
    }
   
  }
  
  input_matrix[,1] <- as.character (input_matrix[,1])
  input_matrix[1,1] <- paste0(as.character(input_matrix[1,1]), "_indicator")
  
  input_matrix
}
