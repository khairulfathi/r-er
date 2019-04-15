library(plyr)

# start to read both CSV files
csv_surv <- read.csv('Student_Survey.csv')
csv_test <- read.csv('Speedtest_Result.csv')

# rename variables name for easier reference
tmpstud <- rename(csv_surv, c(Academic.Programme = "Programme", Internet.Connection.Method = "SSID", Main.Usage.of.Internet = "Usage", On.overall.basis..how.satisfied.are.you.with.wireless.internet.connection.provided.by.IIUM. = "Satisfaction", Propose.a.solution.to.improve.IIUM.WIFI.services. = "Comment", Average.Duration.of.Daily.Use.of.Internet = "Duration", How.many.times.have.your.Internet.connection.been.suddenly.disconnected.or.face.intermittent.connection.in.past.3.days. = "Disconnected", Is.WiFi.coverage.adequate.and.within.acceptable.signal.strength. = "Coverage", How.satisfied.are.you.with.the.network.speed.to.achieve.your.main.usages. = "Speed"))
tmptest <- rename(csv_test, c(Submission.Date = "Timestamp", WiFi.SSID = "SSID", Download.Speed..Mbps. = "DLSpeed", Download.Size..MB. = "DLSize", Upload.Speed..Mbps. = "UPSpeed", Upload.Size..MB. = "UPSize", Ping..ms. = "Ping", Jitter..ms. = "Jitter", Loss.... = "Loss", Signal.Strength..dBm. = "Signal"))

# filter test records and removed unwanted variables
tmpstud <- tmpstud[which(tmpstud$Gender == ''), ]
tmpstud$Timestamp <- tmpstud$Gender <- tmpstud$Comment <- NULL
tmpstud$Usage <- strsplit(as.character(tmpstud$Usage), ",")

# start to process final data frame
k <- 1

Respondent <- integer()
Programme <- character()
SSID <- character()
Mahallah <- character()
Usage <- character()
Satisfaction <- integer()
Duration <- character()
Speed <- integer()
Disconnected <- character()
Coverage <- character()

# iterate each row to split Usage into separate line in data frame
for(i in 1:nrow(tmpstud))
{
  for(j in 1:3)
  {
    Respondent[k] <- i # to identify unique number of respondent
    Programme[k] <- as.character(tmpstud$Programme[i])
    SSID[k] <- as.character(tmpstud$SSID[i])
    Mahallah[k] <- as.character(tmpstud$Mahallah[i])
    Usage[k] <- tmpstud$Usage[[i]][j]
    Satisfaction[k] <- tmpstud$Satisfaction[i]
    Duration[k] <- as.character(tmpstud$Duration[i])
    Speed[k] <- tmpstud$Speed[i]
    Disconnected[k] <- as.character(tmpstud$Disconnected[i])
    Coverage[k] <- as.character(tmpstud$Coverage[i])
    
    k <- k + 1
  }
}

# finalized data frame
dfstud <- data.frame(Respondent, Programme, SSID, Mahallah, Usage, Satisfaction, Duration, Speed, Disconnected, Coverage, stringsAsFactors = FALSE)

# bar 
bp <- ggplot(pie, aes(x="", y=freq, fill=x)) + geom_bar(width = 1, stat = "identity")

# pie
bp + coord_polar("y", start=0)