"https://business-api.tiktok.com/open_api/v1.3/bc/get/"                 # список бизнес центров
"https://business-api.tiktok.com/open_api/v1.3/oauth2/advertiser/get/"  # список рекламных аккаунтов
"https://business-api.tiktok.com/open_api/v1.3/advertiser/budget/get/"  # данные по аккаунтам включая валюту
"https://business-api.tiktok.com/open_api/v1.3/advertiser/balance/get/" # лимиты
"https://business-api.tiktok.com/open_api/v1.3/report/integrated/get/"  # отчёты по тратам

# функция формирующая запрос
tik_build_request <- function(
    endpoint,
    params,
    resp_parse_function
) {

  # добавляем размер страницы
  params$page_size <- getOption('tik.page_size')

  # Формируем запрос
  req <- request(getOption('tiktok.base_url')) %>%
    req_url_path_append(getOption('tiktok.api_version')) %>%
    req_url_path_append(endpoint) %>%
    req_headers(
      "Access-Token" = tik_auth()$data$access_token,
      "Content-Type" = "application/json"
    ) %>%
    req_method("GET") %>%
    req_url_query(!!!params)

  # Выполняем запрос с пагинацией
  resps <- req_perform_iterative(
    req,
    next_req = iterate_with_offset(
      "page",
      resp_complete = is_complete,
      resp_pages = function(resp) resp_body_json(resp)$data$page_info$total_page
    ),
    max_reqs = Inf
  )

  # Собираем результаты
  res <- resps_data(resps, resp_parse_function)

}


# вспомогательные функции для пагинации -----------------------------------
## функция определяющая что мы получили последнюю страницу
is_complete <- function(resp) {
  resp_body_json(resp)$data$page_info$page == resp_body_json(resp)$data$page_info$total_page || is.null(resp_body_json(resp)$data$page_info$total_page)
}

## функции паркеры
### бюджеты и лимиты
tik_parse_budgets <- function(resp) {
  content <- resp_body_json(resp)
  tibble(budgets = content$data$advertiser_account_list) %>%
  unnest_wider(budgets)
}

### список рекламодателей из бизнес центра
tik_parse_advertisers <- function(resp) {
  content <- resp_body_json(resp)
  tibble(adv = content$data) %>%
  unnest_longer(adv) %>%
  unnest_wider(adv)
}

### информация по рекламодателям из бизнес центра
tik_parse_advertisers_info <- function(resp) {
  content <- resp_body_json(resp)
  tibble(adv = content$data) %>%
  unnest_longer(adv) %>%
  unnest_wider(adv)
}

### парсер бизнес центров
tik_parse_business_centers <- function(resp) {
  content <- resp_body_json(resp)
  tibble(bc = content$data$list) %>%
  unnest_wider(bc) %>%
  unnest_wider(bc_info)
}

### парсер отчётов
tik_parse_report <- function(resp) {
  content <- resp_body_json(resp)
  tibble(report = content$data$list) %>%
  unnest_wider(report) %>%
  unnest_wider(dimensions) %>%
  unnest_wider(metrics)
}

## список парсеров
tik_parsers <- list(
  business_centers = tik_parse_business_centers,
  advertisers      = tik_parse_advertisers,
  advertisers_info = tik_parse_advertisers_info,
  budgets          = tik_parse_budgets,
  report           = tik_parse_report
)
