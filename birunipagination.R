##Biruni Navigator



require(tidyverse)
library(RSelenium)
require(netstat)
library(rvest)


rs.driver.object <- rsDriver(browser = "firefox",
                             verbose = TRUE,
                             port = free_port())
rs.client<- rs.driver.object$client
#Client Ayrıldı


#Siteye Git
rs.client$navigate("https://biruni.tuik.gov.tr/yapiizin/giris.zul")


#Yapı Kullanma İzin Belgesi Tuşuna Bas
yapı.kullanma.ruhsatı.izin.belgesi.buttons <- 
  rs.client$findElements(using = "class", value = "z-menu-btn")

yapı.kullanma.izin.belgesi <- yapı.kullanma.ruhsatı.izin.belgesi.buttons[[2]]
yapı.kullanma.izin.belgesi$clickElement()


#Yapı Kullanma İzin Belgesi Yıllık Tuşuna Bas

yapı.kullanma.izin.belgesi.yıllık.aylık.button <- 
  rs.client$findElements(using = "class",
  value = "z-menu-item-cnt")

yapı.kullanma.izin.belgesi.yıllık.button <- 
  yapı.kullanma.izin.belgesi.yıllık.aylık.button[[3]]
yapı.kullanma.izin.belgesi.yıllık.button$clickElement()


# Yıl Aralığını Seç
yılsecimibuttons <- rs.client$findElements(using = "class",
                                           value = "z-radio-cnt")
yıl.secimi.ikibiniki <- yılsecimibuttons[[2]]
yıl.secimi.ikibiniki$clickElement()


#Navigator u kur. 
navigator <- rs.client$findElements(using = "class", value = "z-listcell")

#Navigator Contains Yıl + Değişken
for (year in 1:20) {
  navigator.button <- navigator[[year]]
  navigator.button$clickElement()
  #Yıl Seçili Yerleşim Yerini Seç
    navigator <- rs.client$findElements(using = "class", value = "z-listcell")
    navigator.button <- navigator[[24]]
    navigator.button$clickElement()
    #İl Seç (24 - 106)
    navigator <- rs.client$findElements(using = "class", value = "z-listcell")
    for (city in 26:106) {
      city.button <- navigator[[city]]
      city.button$clickElement()
      t.sistem <- navigator[[110]]
      t.sistem$clickElement()
      second.variable.button <- rs.client$findElement(using = "class", value = "z-checkbox")
      
      if(city == 26){
        second.variable.button$clickElement()
      }
      #2. Değişken
     
      navigator <- rs.client$findElements(using = "class", value = "z-listcell")
      k.sayısı <- navigator[[123]]
      k.sayısı$clickElement()
      
      format <- rs.client$findElements(using = "class", value = "z-radio")
      xlsx <- format[[4]]
      xlsx$clickElement()
      
      ekran.temizle.rapor.olustur <- rs.client$findElements(using = "class",
                                              value = "z-button-os")
      
      rapor.olustur <- ekran.temizle.rapor.olustur[[2]]
      rapor.olustur$clickElement()
      Sys.sleep(5)
      
    }
}


