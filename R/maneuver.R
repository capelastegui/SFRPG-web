
getManeuverList <- function (dir_base=here::here())
{
  ##require(rutils)
  source(file.path(dir_base,"R","0-00-csv-to-html.R"))
  
  maneuver.raw <- file.path(dir_base,"inst", "raw","combat","Combat-maneuvers.csv")
  maneuver.tag <- file.path(dir_base,"inst", "raw","combat","Combat-maneuvers-tags.csv")
  css.file <- file.path(dir_base,"Rmd","SFRPG.css")
  
  
  maneuver.htm.file <- file.path(dir_base,"html","Combat","maneuvers.html")
  maneuver.table.htm.file <- file.path(dir_base,"html","Combat","maneuvers-table.html")
  
 
  
  usageOrder  <- c("","At-Will","Encounter","Daily")
  maneuver.tag.df <- read.csv(maneuver.tag, sep=";", colClasses="character") 
  maneuver.tag.pre<- maneuver.tag.df[1,]
  maneuver.tag.post<- maneuver.tag.df[2,]
  
  
  maneuver.raw.df <- read.csv(maneuver.raw, sep=";") %>% 
    dplyr::filter(Name!="DELETEME")%>%
    gsub_colwise("\\n","<br>") %>%
    tbl_df() %>% 
    
    mutate(UsageLimit=factor(UsageLimit, 
                             levels=c(usageOrder,setdiff(UsageLimit,usageOrder)))) %>%  
    arrange(desc(Type), Name) %>% 
    mutate(usageColors=revalue(UsageLimit,replace=c(Daily="gray", Encounter="red","At-Will"="green")))
  
  levels(maneuver.raw.df$usageColors)[levels(maneuver.raw.df$usageColors)==""] <- "green"
  
  maneuver.raw.df  <- maneuver.raw.df %>% 
    mutate(Name=paste("<span class=\"",usageColors,"\">",Name, "</span>",sep="")) 
  
   #%>%
   #mutate(Level=paste(Level,"</span>",sep=""))
  
  
  htm <- build_element_apply(maneuver.raw.df,maneuver.tag.pre, maneuver.tag.post,
                           df.names=setdiff(names(maneuver.raw.df),c("Summary","Build","usageColors")),
                           skipEmpty = TRUE)
  
  table <- build_table_apply(maneuver.raw.df %>% arrange(desc(Type),Name),
                           df.names=c("Name",  "Type", "Action","Summary"),
                           tableClass="power-table")
  
  list(maneuvers=maneuver.raw.df,maneuvers.htm=htm,maneuvers.table=table)
  
  
  
  
}

writeManeuverList  <- function(maneuver.list)
{
  
  css.file <- file.path(dir_base,"Rmd","SFRPG.css")
  
  
  maneuver.htm.file <- file.path(dir_base,"html","Combat","maneuvers.html")
  
  #Build maneuver tables
  #add stuff to nested list
  #l_class  <- llply.n(l_class,2,.fun2 = function(...){c(...,a="A")})
  # No longer used, keep in case we need a global maneuver table
  # maneuver.table.htm<-build_table_apply(maneuver.raw.df,
  #                       df.names=c("Name", "Class", "Level", "Type","UsageLimit","Range","Action","Summary"),
  #                       tableClass="maneuver-table")
  # maneuver.table.htm<-paste(maneuver.table.htm,collapse="<br> ")
  #write(maneuver.table.htm,maneuver.table.htm.file)
  
  #Build full text descriptions
  maneuver.full <- paste("<html>\r\n<head>\r\n<title>maneuver-test</title>\r\n<style type=\"text/css\">",
                      css,
                      "</style></head>\r\n<body>",
                      "<p>",maneuver.list$maneuvers.table,"</p>",
                      maneuver.list$maneuvers.htm,
                      "</body></html>",
                      sep="\r\n",
                      collapse="")
  writeChar(maneuver.full,maneuver.htm.file)
}

toHtmlManeuverList <- function(maneuver.list)
{
  maneuver.full <- paste("<p>",maneuver.list$maneuvers.table,"</p>",
                         maneuver.list$maneuvers.htm,
                         sep="\r\n",
                         collapse="")

}


