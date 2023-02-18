##Firefox'un yüklü olması gerekir.



message("For Doğruluk Payı®
          by Onur Tuncay Bal, Simge Akkaş
          for contact:
          https://www.linkedin.com/in/onur-tuncay-bal-400955176/
          https://www.linkedin.com/in/simge-akkaş-737345203/")
message("Gerekli Kütüphaneler Yükleniyor")



require(tidyverse)
library(RSelenium)
require(netstat)
library(rvest)

message("Done!")

message("Firefox Sanal Uzantısı Başlatılıyor")









rs.driver.object <- rsDriver(browser = "firefox",
                             verbose = TRUE,
                             port = free_port())


rs.client<- rs.driver.object$client
message("Client Ayrıldı, Yönlendiriliyor")
rs.client$navigate("https://hasartespit.csb.gov.tr")


message("Hasar Tespit Veri Tabanına Bağlanıldı, Elementler Ayrıştırılıyor.")
search_city <- rs.client$findElement(using = "id",'IlId')
search_ilce <- rs.client$findElement(using = "id", 
                                     'IlceId')
search_mahalle <- rs.client$findElement(using = "id","MahalleId")
sorgula.buttons <- rs.client$findElements(using = 'class', value = "btn")
sorgula.button<- sorgula.buttons[[2]]


search_city$sendKeysToElement(list("Kahramanmaraş", key = 'enter'))

search_ilce <- rs.client$findElement(using = "id", 
                                     'IlceId')
search_ilce$sendKeysToElement(list("Afşin", key = 'enter'))

#Search Mahalle
search_mahalle <- rs.client$findElement(using = "id","MahalleId")
search_mahalle$sendKeysToElement(list('Afşinbey', key = 'enter'))

#Inspect the button element
sorgula.buttons <- rs.client$findElements(using = 'class', value = "btn")
sorgula.button<- sorgula.buttons[[2]]

#click on button
sorgula.button$clickElement()


qresult<- rs.client$findElements(using = "name", value = "QueryResult_length")
qresult.options <- qresult[[1]]$findChildElements(using = "xpath","option")
qresult.options[[5]]$clickElement()


#get the html table
table <- rs.client$findElement(using = 'id', value = 'QueryResult')
source <- table$getPageSource()
source.unlist <- source%>%unlist()
page <- read_html(source.unlist)
html_table(page)[1] -> main.frame
main.frame <- main.frame[[1]]
View(main.frame)


options.city <- search_city$findChildElements(using = "xpath","option")
for (city in 1:length(options.city)) {
  temp.options.city <- options.city[[city]]
  temp.options.city$clickElement()
  options.ilce <- search_ilce$findChildElements(using = "xpath","option")
  for (ilce in 2:length(options.ilce)) {
    temp.options.ilce <- options.ilce[[ilce]]
    temp.options.ilce$clickElement()
    options.mahalle <- search_mahalle$findChildElements(using = "xpath","option")
    for (mahalle in 2:length(options.mahalle)) {
      temp.options.mahalle <- options.mahalle[[mahalle]]
      temp.options.mahalle$clickElement()
      sorgula.button$clickElement()
      Sys.sleep(1.5) ##Internet hızına göre burayı ayarlayabilirsiniz. 
      #select all
      qresult<- rs.client$findElements(using = "name", value = "QueryResult_length")
      qresult.options <- qresult[[1]]$findChildElements(using = "xpath","option")
      qresult.options[[5]]$clickElement()
      #get query
      table <- rs.client$findElement(using = 'id', value = 'QueryResult')
      source <- table$getPageSource()
      source.unlist <- source%>%unlist()
      page <- read_html(source.unlist)
      html_table(page)[1] -> temp.frame
      rbind(temp.frame[[1]],main.frame) -> main.frame
      write.csv(main.frame, "~/main.frame1.csv") ### Verinin kaydedileceği konumu buraya belirtebilirsiniz.
      
    }
  }
}


