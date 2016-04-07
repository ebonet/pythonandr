library(rjson)

# https://www.datacamp.com/community/tutorials/r-data-import-tutorial

# Takes a list of params and marge them in a query format
mergeUrl <- function(x) paste(sapply(names(x), function(l) {paste(c(l,x[l]),collapse="=")} ),collapse="&")

buildUrl <- function(page) {
  base = "http://api.vivareal.com/api/1.0/locations/listings?apiKey=183d98b9-fc81-4ef1-b841-7432c610b36e&exactLocation=FALSE&currency=BRL&business=RENTA&listingType=APART&listingUse=RESIDENCIAL&rankingId=0&locationIds=BR%3ESanta%20Catarina%3ENULL%3EFlorianopolis&maxResults=40&page="
  
  paste(c(base, page), collapse = "")
}

# Optional Parameters
loadData <- function(max=100) {
  
  all <- c()
  
  for (i in 0:max) {
    d <- fromJSON(file=buildUrl(i))
    
    if(length(d$listings) ==0 )
      break
    
    all <- c(all, d$listings)
  }
  
  all
}

json2df <- function(data) {
  keys <- c("propertyId", "rentPrice", "area", "bathrooms", "rooms", "garages", "latitude", "longitude", "address", "suites",
          "rentPeriodId", "condominiumPrice", "iptu")
  
  d <- as.data.frame(do.call(rbind, lapply(lapply(data, function(d){as.character.default(d[keys])}), rbind)))
  d[d=="NULL"] <- NA
  names(d) <- keys
  d
}

data <- loadData()
dt <- json2df(data)
write.csv(dt, file="rentals.csv", row.names=F)