#' Get Business Centers
#'
#' @returns tibble with business centers info
#' @export
#'
#' @examples
#' \dontrun{
#' bc <- tik_get_business_centers()
#' }
tik_get_business_centers <- function() {

  res <- tik_build_request(
    endpoint = "bc/get/",
    params = list(),
    resp_parse_function = tik_parsers$business_centers
  )

  return(res)

}
