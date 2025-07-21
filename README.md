# rtiktokads
R Пакет для работы с [TikTok Marketing API](https://business-api.tiktok.com/portal/docs?id=1797738007505921&rid=uz955smt6w).

## Функционал пакета
На данный момент в rtiktokads 0.1.0 доступен очень ограниченный функционал:

* Авторизация:
    * `tik_set_username()` - задать имя пользователя
    * `tik_auth()` - авторизоваться в TikTok Bussines API
* Запрос данных:
    * `tik_get_business_centers()` - запросить список бизнес центров
    * `tik_get_advertiser_accounts()` - запросить список рекламных аккаунтов
    * `tik_get_advertiser_info()` - запросить информацию по рекламным аккаунтам
    * `tik_get_advertiser_balance()` - запросить информацию о балансе рекламных аккаунтов
    * `tik_get_campaigns()` - Запрос рекламных кампаний
    * `tik_get_ad_groups()` - Запрос групп объявлений
    * `tik_get_ads()` - Запрос объявлений
* Отчёты:
    * `tik_get_report()` - запрос отчётов из TikTok Marketing API

## Пример работы с пакетом

```r
library(rtiktokads)

# авторизация
tik_set_username('a.seleznev@netpeak.group')
tik_auth()

# запрос данных
bc <- tik_get_business_centers()
advertisers <- tik_get_advertiser_accounts()
budgets <- tik_get_advertiser_balance('7418551027034587137')
advertisers_info <- tik_get_advertiser_info(advertisers$advertiser_id)

# запрос отчётов
report <- tik_get_report(advertiser_id = '7499750467069771792')
reports <- tik_get_report(advertiser_ids = advertisers$advertiser_id)
```
