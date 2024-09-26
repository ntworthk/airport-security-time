library(httr)

df_old <- readRDS("data/sydney-wait-time.rds")

headers <- c(
  `Subscription-Key` = "09af684d342c4482930c24ea76f3aeee"
)

res <- GET(url = "https://api.sydneyairport.com.au/external/GetSecurityWaitTime", add_headers(.headers=headers))

x <- content(res)

df <- lapply(x, function(y) {
  z <- as.data.frame(y$data)
  z$terminal <- y$terminal
  z
}) |> 
  do.call(what = rbind, args = _)

df$time <- Sys.time()

df <- unique(df)

df <- rbind(df_old, df)

saveRDS(df, "data/sydney-wait-time.rds")
