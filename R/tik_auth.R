#' Change session token path
#'
#' @param token_path auth cache folder
#'
#' @return using for side effect, no return value
#' @export
#'
tik_set_token_path <- function(
    token_path = ifelse(getOption('tiktok.auth_cache_mode') == 'global', rappdirs::site_data_dir("rtiktokads"), rappdirs::user_cache_dir("rtiktokads"))
    ) {
  options('tiktok.token_path' = token_path)
  cli_alert_success('Set token_path {.file {token_path}}')
}

#' Set session auth username
#'
#' @param username TikTok login
#'
#' @return using for side effect, no return value
#' @export
#'
tik_set_username <- function(username) {
  options('tiktok.username' = username)
  cli_alert_success('Set username {.file {username}}')
}

#' Get auth cache folder
#'
#' @return character, cache folder path
#' @export
#'
tik_get_token_path <- function() {
  if ( !is.null( getOption('tiktok.token_path') ) )        return(getOption('tiktok.token_path'))
  if ( !identical(Sys.getenv('R_TIKTOK_TOKEN_PATH'), "") ) return(Sys.getenv('R_TIKTOK_TOKEN_PATH'))
  return( normalizePath(user_cache_dir(appname = 'rtiktokads'), mustWork = F) )
}

#' Get auth username
#'
#' @return character, current auth username
#' @export
#'
tik_get_username <- function(){
  if ( !is.null( getOption('tiktok.username') ) )        return(getOption('tiktok.username'))
  if ( !identical(Sys.getenv('R_TIKTOK_USERNAME'), "") ) return(Sys.getenv('R_TIKTOK_USERNAME'))
  return( NULL )
}

tik_get_access_token <- function() {
  access_token <- tik_auth()
  access_token$data$access_token
}

#' Authorization in 'TikTok Marketing API'
#'
#' @param username TikTok login
#' @param token_path auth cache folder
#'
#' @return tik_access_token object
#' @export
#'
tik_auth <- function(
  username = tik_get_username(),
  token_path = tik_get_token_path()
) {

  if ( !dir.exists(token_path) ) {
    dir.create(token_path, recursive = T)
  }

  if ( all(username != tik_get_username()) ) tik_set_username(username)
  if ( token_path != tik_get_token_path() ) tik_set_token_path(token_path)

  token_file_name <- paste(username, 'tiktok_auth.rds', sep = "_")
  token_file_path <- normalizePath(file.path(token_path, token_file_name), mustWork = FALSE)

  if ( file.exists(token_file_path) ) {

    tik_auth_obj <- readRDS(token_file_path)

  } else {

    browseURL('https://ads.tiktok.com/marketing_api/auth?app_id=7044431703179264001&state=your_custom_params&redirect_uri=https%3A%2F%2Fselesnow.github.io%2Frtiktokads%2FgetToken%2Fget_code.html&rid=ehzu75ozwx')
    auth_code <- readline('Enter auth code: ')

    tik_auth_obj <- request('https://business-api.tiktok.com/') %>%
      req_url_path_append('open_api/v1.2/oauth2/access_token/') %>%
      req_body_json(list(
        app_id    = '7044431703179264001',
        auth_code = auth_code,
        secret    = '21b7b1213d1a2341db97e6482a4addac1f3fe837'
      )) %>%
      req_perform() %>%
      resp_body_json()

    class(tik_auth_obj) <- 'tik_access_token'
    tik_auth_obj$username <- username
    tik_auth_obj$token_file_path <- token_file_path

    cli_alert_success('Authorization complete. Token save at {.file {token_file_path}}')

    saveRDS(tik_auth_obj, file = token_file_path)

  }

  return(tik_auth_obj)

}

#' @export
print.tik_access_token <- function(x, ...) {
  cli_text(style_bold('TikTok Marketing API Token'))
  cli_ul("advertiser_ids: {.file {paste(x$data$advertiser_ids, sep = ', ')}}")
  cli_ul("username: {.file {x$username}}")
  cli_ul("path: {.file {x$token_file_path}}")
}
