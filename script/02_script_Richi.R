Rcrawler(Website = "https://www.nytimes.com/", KeywordsFilter = c("coronavirus", "Coronavirus"))

ListProjects()

MyDATA<-LoadHTMLFiles("nytimes.com-101542", type = "vector")

view("MyData")

page<-LinkExtractor(url="https://dapsco.unimi.it/", IndexErrPages = c(200), ExternalLInks = TRUE, Useragent = "Mozilla/5.0 (Windows NT 6.3; Win64; x64)")
