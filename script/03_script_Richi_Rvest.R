url <- URLencode("https://www.corriere.it")

pagina <- RCurl::getURL(url, 
                      useragent = str_c(R.version$platform,
                                        R.version$version.string,
                                        sep = ", "),
                      httpheader = c(From = "riccardo.ruta@studenti.unimi.it"))
 


writeLines(pagina, 
           con = ("corriere.html"))
