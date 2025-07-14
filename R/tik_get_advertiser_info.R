#' Get ad account details
#'
#' @param advertiser_ids List of advertiser IDs to query. You can obtain Advertiser IDs through the `tik_get_advertiser_accounts()` function
#' @param fields A list of information to be returned. Supported values:
#' * telephone_number
#' * contacter
#' * currency
#' * cellphone_number
#' * timezone
#' * advertiser_id
#' * role
#' * company
#' * status
#' * description
#' * rejection_reason
#' * address
#' * name
#' * language
#' * industry
#' * license_no
#' * email
#' * license_url
#' * country
#' * balance
#' * create_time
#' * display_timezone
#' * owner_bc_id
#' * company_name_editable.
#'
#' @returns tibble with advertisers onfo
#' @export
#'
#' @examples
#' \dontrun{
#' advertisers <- tik_get_advertiser_accounts()
#' advertisers_info <- tik_get_advertiser_info(advertisers$advertiser_id)
#' }
tik_get_advertiser_info <- function(
    advertiser_ids,
    fields = NULL
) {

  # make correct json
  advertiser_ids <- toJSON(advertiser_ids)
  fields         <- if (!is.null(fields)) toJSON(fields) else fields

  params <- as.list(environment())

  res <- tik_build_request(
    endpoint = "advertiser/info/",
    params = params,
    resp_parse_function = tik_parsers$advertisers_info
  )

  return(res)

}
