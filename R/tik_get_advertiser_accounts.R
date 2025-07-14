#' Get authorized ad accounts
#'
#' @returns tibble with advertisers name and id
#' @export
#'
#' @examples
#' \dontrun{
#' advertisers <- tik_get_advertiser_accounts()
#' }
tik_get_advertiser_accounts <- function() {

  res <- tik_build_request(
    endpoint = "oauth2/advertiser/get/",
    params = list(
      app_id = getOption('tiktok.app_id'),
      secret = getOption('tiktok.app_secret')
    ),
    resp_parse_function = tik_parsers$advertisers
  )

  return(res)
}
