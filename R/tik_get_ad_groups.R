#' Get ad groups
#'
#' @param advertiser_id Advertiser ID.
#' @param fields Fields that you want to get.
#'
#' @returns
#' @export
#'
tik_get_ad_groups <- function(
    advertiser_id,
    fields = NULL
) {

  if (!is.null(fields)) fields <- toJSON(fields)
  params <- as.list(environment())

  res <- tik_build_request(
    endpoint = "adgroup/get/",
    params = params,
    resp_parse_function = tik_parsers$ad_groups
  )

  return(res)

}
