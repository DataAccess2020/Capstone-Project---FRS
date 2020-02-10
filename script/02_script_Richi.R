Rcrawler(Website = "https://www.nytimes.com/", KeywordsFilter = c("coronavirus", "Coronavirus"))

ListProjects()

MyDATA<-LoadHTMLFiles("nytimes.com-101542", type = "vector")

view("MyData")
