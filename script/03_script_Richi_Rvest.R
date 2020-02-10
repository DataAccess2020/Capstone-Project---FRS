url <- URLencode("https://www.nytimes.com/")

pagina <- getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
 


writeLines(pagina, 
           con = ("nytimes.html"))



links <- XML::getHTMLLinks("https://www.nytimes.com/")


links2 <- read_html("https://www.nytimes.com/") %>% 
  html_nodes(css = ".esl82me0 , .balancedHeadline")

links2
