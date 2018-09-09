library(dplyr)
library(leaflet)
library(readxl)
library(scales)
library(ggplot2)

## read global country xslx
country <- read_excel("../data/country.xlsx")

# changing column name (global country file)
country <- rename(country, countryEng = "Country")
country <- rename(country, alpha2code = "Alpha-2 code")
country <- rename(country, alpha3code = "Alpha-3 code")
country <- rename(country, numericCode = "Numeric code")
country <- rename(country, lat = "Latitude")
country <- rename(country, lng = "Longitude")
country <- rename(country, countryKor = "Country_Kor")

period1 <- read_excel("../data/Data-2000-2003.xlsx")
period2 <- read_excel("../data/Data-2004-2007.xlsx")
period3 <- read_excel("../data/Data-2008-2011.xlsx")
period4 <- read_excel("../data/Data-2012-2015.xlsx")
period5 <- read_excel("../data/Data-2016-2018.xlsx")


worldData <- rbind(period1, period2)
worldData <- rbind(worldData, period3)
worldData <- rbind(worldData, period4)
worldData <- rbind(worldData, period5)


# removing comma
worldData$수입중량 <- gsub(",","",worldData$수입중량)
worldData$수출중량 <- gsub(",","",worldData$수출중량)
worldData$수출금액 <- gsub(",","",worldData$수출금액)
worldData$수입금액 <- gsub(",","",worldData$수입금액)
worldData$무역수지 <- gsub(",","",worldData$무역수지)

# changing data tpye from char to numeric
worldData$수입중량 <- as.numeric(worldData$수입중량)
worldData$수출중량 <- as.numeric(worldData$수출중량)
worldData$수출금액 <- as.numeric(worldData$수출금액)
worldData$수입금액 <- as.numeric(worldData$수입금액)
worldData$무역수지 <- as.numeric(worldData$무역수지)

# changing column name 
worldData <- rename(worldData, period = "기간")
worldData <- rename(worldData, prodNm = "품목명")
worldData <- rename(worldData, prodCode = "품목코드")
worldData <- rename(worldData, countryKor = "국가명")
worldData <- rename(worldData, exprtWgh = "수출중량")
worldData <- rename(worldData, imprtWgh = "수입중량")
worldData <- rename(worldData, exprtMny = "수출금액")
worldData <- rename(worldData, imprtMny = "수입금액")
worldData <- rename(worldData, tradeBalance = "무역수지")

# 결측치 제거
worldData <- left_join(worldData, country)
worldDataFiltered <- na.omit(worldData)

# 무역수지 계산
worldDataFiltered <- worldDataFiltered %>% mutate(ifSurplus = ifelse(tradeBalance > 0, "흑자", "적자"))

# 기간 별 나라별 4개영역 총계
sumCountryPerPeriod <- worldDataFiltered %>% group_by(countryKor, period) %>% summarise(imprtWghTotal = sum(imprtWgh), imprtMnyTotal = sum(imprtMny), exprtWghTotal = sum(exprtWgh), exprtMnyTotal = sum(exprtMny))

# 기간 별 나라별 품목 별 4개 영역 총계
sumCountryProductPerPeriod <- worldDataFiltered %>% group_by(countryKor, period, prodNm) %>% summarise(imprtWghTotal = sum(imprtWgh), imprtMnyTotal = sum(imprtMny), exprtWghTotal = sum(exprtWgh), exprtMnyTotal = sum(exprtMny))

# 품목명 읽기
prodNameCSV <- read.csv("../data/prodName.csv", stringsAsFactors = F)
prodName <- prodNameCSV$prodNm

# 현재까지 년도
periodGlobal <- c(2000:2018)

option <- c(
  "수출중량" = "exprtWgh",
  "수입중량" = "imprtWgh",
  "수출금액" = "exprtMny",
  "수입금액" = "imprtMny"
)

optionMoney <- c(
  "수출금액" = "exprtMny",
  "수입금액" = "imprtMny"
)

xlim <- list(
  min = min(sumCountryPerPeriod$imprtMnyTotal) ,
  max = max(sumCountryPerPeriod$imprtMnyTotal) + 500
)
ylim <- list(
  min = min(sumCountryPerPeriod$exprtMnyTotal) ,
  max = max(sumCountryPerPeriod$exprtMnyTotal) + 500
)
