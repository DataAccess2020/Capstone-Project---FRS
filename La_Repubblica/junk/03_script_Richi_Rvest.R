# Source setup scripts:
source(here::here("script","00_setup.R"))

here::here("")

#encode URL
url <- URLencode("https://www.repubblica.it")

#inspect robots
browseURL("https://repubblica.it/robots.txt")

repubblica <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
 


writeLines(pagina, 
           con = ("repubblica.html"))

link <- read_html(here::here("repubblica.html")) %>% 
  html_nodes(css = "a") %>% 
  html_attr("href")

