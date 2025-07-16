#' Get marketing report
#'
#' @description
#' Use this function to create a synchronous report task.
#' This function can currently return the reporting data of up to 20,000 advertisements. If your number of advertisements exceeds 20,000, please use campaign_ids / adgroup_ids / ad_ids as a filter to obtain the reporting data of all advertisements in batches. If you use campaign_ids / adgroup_ids / ad_ids as a filter, you can pass in up to 100 IDs at a time.
#'
#'
#' @param advertiser_id Advertiser ID. You need to pass in either advertiser_id/advertiser_ids or bc_id.
#' * When report_type is set to BASIC or AUDIENCE, pass in advertiser_id or advertiser_ids. If you pass in both advertiser_id and advertiser_ids, advertiser_id will be ignored.
#' * When report_type is set to PLAYABLE_MATERIAL, CATALOG, or TT_SHOP, pass in advertiser_id.
#' * When report_type is set to BC, pass in bc_id.
#' @param advertiser_ids  A list of advertiser IDs.
#' @param bc_id ID of a Business Center that you have access to.
#' @param service_type Ad service type. Not supported when report_type is BC.
#' * AUCTION: auction ads, or both auction ads and reservation ads.
#' * RESERVATION (deprecated) : reservation ads.
#' @param report_type Report type:
#' * BASIC: basic report.
#' * AUDIENCE: audience report.
#' * PLAYABLE_MATERIAL: playable ads report.
#' * CATALOG: DSA report.
#' * BC: Business Center report.
#' * TT_SHOP: GMV max ads report.
#' @param data_level The data level that you'd like to query in reports.
#' * AUCTION_AD: auction ads or both auction ads and reservation ads, ad level.
#' * AUCTION_ADGROUP: auction ads or both auction ads and reservation ads, ad group level.
#' * AUCTION_CAMPAIGN: auction ads or both auction ads and reservation ads, campaign level.
#' * AUCTION_ADVERTISER: auction ads or both auction ads and reservation ads, advertiser level.
#' @param dimensions Grouping conditions. For example: ["campaign_id", "stat_time_day"] indicates that both campaign_id and stat_time_day (days) are grouped. Different report types support different dimensions.
#' * Supported dimensions in [basic reports](https://business-api.tiktok.com/portal/docs?id=1751443956638721)
#' * Supported dimensions in [audience reports](https://business-api.tiktok.com/portal/docs?id=1751454103714818)
#' * Supported dimensions in [playable ad reports](https://business-api.tiktok.com/portal/docs?id=1751617879104514)
#' * Supported dimensions in [DSA reports](https://business-api.tiktok.com/portal/docs?id=1751617879104514)
#' * Supported dimensions in [Business Center reports](https://business-api.tiktok.com/portal/docs?id=1775747465089026)
#' * Supported dimensions in [GMV max ads reports](https://business-api.tiktok.com/portal/docs?id=1803073629472770)
#' @param metrics Metrics to query. Different report types support different metrics. For supported metrics for each report type, see the corresponding articles under [Report types](https://ads.tiktok.com/marketing_api/docs?id=1738864835805186).
#' @param enable_total_metrics Whether to enable the total added-up data for your requested metrics. When enable_total_metrics is enabled, we will provide the aggregate data for all pages as you query different pages. Under this condition, you only need to specify this field when requesting data for the first page.
#' @param start_date Query start date (closed interval) in the format of YYYY-MM-DD. The date is based on the ad account time zone.
#' @param end_date Query end date (closed interval) in the format of YYYY-MM-DD. The date is based on the ad account time zone.
#' @param query_lifetime Whether to request the lifetime metrics. Default value: False. If query_lifetime = True, the start_date and end_date parameters will be ignored. The lifetime metric name is the same as the normal one.
#' @param multi_adv_report_in_utc_time Whether to set the returned metrics in the local timezone of each respective advertiser.
#' @param order_field Sorting field.
#' @param order_type Sorting order. ASC or DESC.
#'
#' @details
#' To take more details see [API documentation](https://business-api.tiktok.com/portal/docs?id=1740302848100353&rid=uz955smt6w)
#'
#' @returns tibble with report data
#' @export
#'
#' @examples
#' \dontrun{
#' report <- tik_get_report(advertiser_id = '7499750467069771792')
#' }
tik_get_report <- function(
    advertiser_id                = NULL,
    advertiser_ids               = NULL,
    bc_id                        = NULL,
    service_type                 = NULL,
    report_type                  = 'BASIC',
    data_level                   = 'AUCTION_ADVERTISER',
    dimensions                   = c('advertiser_id', 'stat_time_day'),
    metrics                      = 'spend',
    enable_total_metrics         = FALSE,
    start_date                   = Sys.Date() - 7,
    end_date                     = Sys.Date() - 1,
    query_lifetime               = FALSE,
    multi_adv_report_in_utc_time = FALSE,
    order_field                  = NULL,
    order_type                   = NULL
) {

  # make correct json
  dimensions <- toJSON(dimensions)
  metrics <- toJSON(metrics)
  params <- as.list(environment())

  if (is.null(advertiser_ids)) {

    res <- tik_build_request(
      endpoint = "report/integrated/get/",
      params = params,
      resp_parse_function = tik_parsers$report
    )

  } else {

    # разбиваем список рекламодателей по 5 на запрос
    chunks <- split(advertiser_ids, ceiling(seq_along(advertiser_ids) / 5))
    json_chunks <- lapply(chunks, toJSON)
    # по очереди собираем данные по 5 рекламодателей
    res <- purrr::map_dfr(
      json_chunks,
      \(chunk) {
        params$advertiser_ids <- chunk
        tik_build_request(
          endpoint = "report/integrated/get/",
          params = params,
          resp_parse_function = tik_parsers$report
        )
      }
    )

  }

  return(res)

}
