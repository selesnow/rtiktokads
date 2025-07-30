#' Get the partners of a BC
#'
#' @param bc_id Business Center ID.
#'
#' @returns tibble with list of partners
#' @export
#'
#' @examples
tik_get_bc_partners <- function(
    bc_id
) {

  params <- as.list(environment())

  res <- tik_build_request(
    endpoint = "advertiser/balance/get/",
    params = params,
    resp_parse_function = tik_parsers$budgets
  )

  return(res)

}
