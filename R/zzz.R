.onLoad <- function(libname, pkgname) {

  # where function
  utils::globalVariables("where")

  # options
  op <- options()
  op.gads <- list(tiktok.app_id          = '7044431703179264001',
                  tiktok.app_secret      = '21b7b1213d1a2341db97e6482a4addac1f3fe837',
                  tiktok.base_url        = 'https://business-api.tiktok.com/open_api/',
                  tiktok.api_version     = 'v1.3',
                  tik.page_size          = 50,
                  tiktok.auth_cache_mode = 'global')

  toset <- !(names(op.gads) %in% names(op))
  if (any(toset)) options(op.gads[toset])

  invisible()
}

.onAttach <- function(lib, pkg,...){

  packageStartupMessage(rtiktokadsWelcomeMessage())

}


rtiktokadsWelcomeMessage <- function(){
  # library(utils)

  paste0("\n",
         "---------------------\n",
         "Welcome to rtiktokads version ", utils::packageDescription("rtiktokads")$Version, "\n",
         "\n",
         "Author:           Alexey Seleznev (Head of analytics dept at Netpeak).\n",
         "Telegram channel: https://t.me/R4marketing \n",
         "YouTube channel:  https://www.youtube.com/R4marketing/?sub_confirmation=1 \n",
         "Email:            selesnow@gmail.com\n",
         "Site:             https://selesnow.github.io \n",
         "Blog:             https://alexeyseleznev.wordpress.com \n",
         "Facebook:         https://facebook.com/selesnown \n",
         "Linkedin:         https://www.linkedin.com/in/selesnow \n",
         "\n",
         "Using Googla Ads API version: ", getOption('rtikokads.api_version'), "\n",
         "\n",
         "Type ?rtiktokads for the main documentation.\n",
         "The github page is: https://github.com/selesnow/rtiktokads/\n",
         "Package site: https://selesnow.github.io/rtiktokads/docs\n",
         "Package lessons playlist: https://www.youtube.com/playlist?list=PLD2LDq8edf4qprTxRcflDwV9IvStiChHi\n",
         "\n",
         "Suggestions and bug-reports can be submitted at: https://github.com/selesnow/rtiktokads/issues\n",
         "Or contact: <selesnow@gmail.com>\n",
         "\n",
         "\tTo suppress this message use:  ", "suppressPackageStartupMessages(library(rtiktokads))\n",
         "---------------------\n"
  )
}
