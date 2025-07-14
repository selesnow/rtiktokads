#' Get the balance and budget of ad accounts
#'
#' @description
#' Use this endpoint to obtain the balance of ad accounts in the Business Center. You can also use this endpoint to obtain the budget of the ad accounts owned by the Business Center in auto-allocation mode.
#'
#'
#' @param bc_id Business Center ID.
#' @param fields A list of additional fields to return in the response. Supported values:
#' * budget_remaining: The remaining budget.
#' * budget_frequency_restriction: Restrictions on the number of budget changes allowed for the current day.
#' * budget_amount_restriction: Restrictions on the minimum amount that can be changed for the budget.
#' * min_transferable_amount: Details of the minimal amount that you can transfer to the ad account.
#'
#' @returns tibble with balance and budget info
#' @export
#'
#' @examples
#' \dontrun{
#' bc <- tik_get_business_centers()
#' acs_balance <- tik_get_advertiser_balance(bc$bc_id)
#' }
tik_get_advertiser_balance <- function(
    bc_id,
    fields = NULL
) {

  params <- as.list(environment())

  res <- tik_build_request(
    endpoint = "advertiser/balance/get/",
    params = params,
    resp_parse_function = tik_parsers$budgets
  )

  return(res)

}
