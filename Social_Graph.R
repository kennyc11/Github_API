install.packages("jsonlite")
library(jsonlite)
install.packages("httpuv")
library(httpuv)
install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Interrogate_API",
                   key = "ec6b80dda7f8b9758ade",
                   secret = "b6a07323d4049d004f864590c845223aa2c1541f")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp) #run this line and connect them!!! 


# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#The above code was sourced from Michael Galarnyk's blog post
#https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

#This part of assignment deals with building the visulization of data 


#Installing plotly for better visualisation of graphs
install.packages("plotly")
require(devtools)
library(plotly)

#Linking R to plotly. This allows me to create online interactive graphs through interrogation github API
#building visulation of the data available and uploading to plotly using graphs based on d3s library.
Sys.setenv("plotly_username"="kennyc11")
Sys.setenv("plotly_api_key"="zFLJG9Kb2on2xdumwWg1")

# usernames that user Mike Bostock is following
mBostockFollowing = GET("https://api.github.com/users/mbostock/following", gtoken)
mBostockFollowingContent = content(mBostockFollowing)

# each of those users' data
mBostockFollowing.DF = jsonlite::fromJSON(jsonlite::toJSON(mBostockFollowingContent))

# usernames saved in a vector
id = mBostockFollowing.DF$login
usernames = c(id)

# creation of empty vectors in a data frame
allusers = c()
allusers.DF = data.frame(
  Username = integer(),
  Following = integer(),
  Followers = integer(),
  Repositories = integer(),
  DateCreated = integer()
)

# loop through all usernames to add 
for (i in 1:length(usernames))
{
  # retrieve an individual users following list
  following_url = paste("https://api.github.com/users/", usernames[i], "/following", sep = "")
  following = GET(following_url, gtoken)
  followingContent = content(following)
  
  # skips user if they do not follow anybody
  if (length(followingContent) == 0)
  {
    next
  }
  
  # add followings to a dataframe and retrieve usernames
  following.DF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = following.DF$login
  
  # loop through 'following' users
  for (j in 1:length(followingLogin))
  {
    # check that the user is not already in the list of users
    if (is.element(followingLogin[j], allusers) == FALSE)
    {
      # add user to list of users
      allusers[length(allusers) + 1] = followingLogin[j]
      
      # retrieve data on each user
      following_url2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(following_url2, gtoken)
      followingContent2 = content(following2)
      following.DF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      # retrieve usernames of each account user is following
      following_number = following.DF2$following
      
      # retrieve each user's followers
      followers_number = following.DF2$followers
      
      # retrieve each user's number of repositories
      repos_number = following.DF2$public_repos
      
      # retrieve year that each user joined Github
      year_created = substr(following.DF2$created_at, start = 1, stop = 4)
      
      # add user's data to a new row in dataframe
      allusers.DF[nrow(allusers.DF) + 1, ] = c(followingLogin[j], following_number, followers_number, repos_number, year_created)
      
    }
    next
  }
  # stop when there are more than 250 users
  if(length(allusers) > 250)
  {
    break
  }
  next
}




# Begin visualisations of Interrogation of Mike Bostocks GitHub
#Beginning with the visualization of repostories and followers of Mike Bostock
#Can see there is low correlation

# Visual 1: Scatter plot of Followers vs. Repositories for each user, colour coded by year they joined GitHub
VisualGraph1 = plot_ly(data = allusers.DF, x = ~Repositories, y = ~Followers, 
                       text = ~paste("Followers: ", Followers, "<br>Repositories: ", 
                                     Repositories, "<br>Date Created:", DateCreated), color = ~DateCreated)
VisualGraph1

#Upload the graph to my plotly account kennyc11, the link for this graph is https://plot.ly/~kennyc11/8/#/
api_create(VisualGraph1, filename = "Followers vs. Repositories")

#Plot 2: Scatter plot of Mike Bostocks following vs his followers 
VisualGraph2 = plot_ly(data = allusers.DF, x = ~Following, y = ~Followers, text = ~paste("Following: ", Following, 
                                         "<br>Followers: ", Followers, "<br>Date Created:", DateCreated), color = ~DateCreated)



VisualGraph2
 
#Looking at the most popular languages used in github

Languages = c()

#Loop through all the users
for (i in 1:length(AllUsers))
{
  #Access each users repositories and save in a dataframe
  RepositoriesUrl = paste("https://api.github.com/users/", AllUsers[i], "/repos", sep = "")
  Repositories = GET(RepositoriesUrl, gtoken)
  RepositoriesContent = content(Repositories)
  RepositoriesDF = jsonlite::fromJSON(jsonlite::toJSON(RepositoriesContent))
  
  #Find names of all the repositories for the given user
  RepositoriesNames = RepositoriesDF$name
  
  #Loop through all the repositories of an individual user
  for (j in 1: length(RepositoriesNames))
  {
    #Find all repositories and save in data frame
    RepositoriesUrl2 = paste("https://api.github.com/repos/", AllUsers[i], "/", RepositoriesNames[j], sep = "")
    Repositories2 = GET(RepositoriesUrl2, gtoken)
    RepositoriesContent2 = content(Repositories2)
    RepositoriesDF2 = jsonlite::fromJSON(jsonlite::toJSON(RepositoriesContent2))
    
    #Find the language which each repository was written in
    Language = RepositoriesDF2$language
    
    #Skip a repository if it has no language
    if (length(Language) != 0 && Language != "<NA>")
    {
      #Add the languages to a list
      Languages[length(Languages)+1] = Language
    }
    next
  }
  next
}

#Save the top 20 languages in a table
LanguageTable = sort(table(Languages), increasing=TRUE)
LanguageTableTop20 = LanguageTable[(length(LanguageTable)-19):length(LanguageTable)]

#Save this table as a data frame
LanguageDF = as.data.frame(LanguageTableTop20)

#Bubble chart to count the most popular use of languages amongst users in github
BubbleChart <- plot_ly(data = LanguageDF, x = ~ LanguageDF$Languages, y = ~LanguageDF$Freq, text = ~paste("Language: ", LanguageDF$Languages, "<br>Frequency: ", 
                                                                                                           LanguageDF$Freq), type = 'scatter', mode = 'markers',
                       marker = list(size =~ Language, opacity = 0.5)) %>%
  layout(title = 'Repositories vs Following',
         xaxis = list(showgrid = FALSE),
         yaxis = list(showgrid = FALSE))
BubbleChart

#upload to plotly
api_create(BubbleChart, filename = "Most used Languages")



#Put top languages into a bar chart
#Plot the data frame of languages, showing most used 
#languages
Graph4 = plot_ly(data = LanguageDF, x = LanguageDF$Languages, y = LanguageDF$Freq, type = "bar")
Graph4

#Upload to plotly
api_create(graph4, "Top 20 Languages Used on Github")

#I will now further interrogate Mike Bostocks following to see how many people that they follow

mBostockFollowing <- fromJSON("https://api.github.com/users/mbostock/following")
mBostockFollowing$login #gets the user names of Mike Bostock's followers

a <- "https://api.github.com/users/"
b <- mBostockFollowing$login[5]
b
c <- "/following"
                          
numberOfFollowing <- c()    #empty vector
namesOfFollowing<- c()
for (i in 1:length(mBostockFollowing$login)) 
{
  following <- mBostockFollowing$login[i] #loops through each of my followers, indexed by i
  jsonLink <- sprintf("%s%s%s", a, following, c) #creates a link for my ith follower
  followingData <- fromJSON(jsonLink) #stores the followers of my ith follower
  numberOfFollowing[i] = length(followingData$login) #amount of followers the ith follower has
  namesOfFollowing[i] = following #names of all users following the ith follower
  
}
numberOfFollowing
namesOfFollowing
finalData <- data.frame(numberOfFollowing, namesOfFollowing) #stores two vectors as one
#data frame
finalData$namesOfFollowing    
finalData$numberOfFollowing   #Number of people following of each of mike bostocks following


#install.packages("devtools")
#install.packages("Rcpp")
#library(devtools)
#library(Rcpp)
#install_github('ramnathv/rCharts', force= TRUE)
#require(rCharts)

#These two shows same traits but using different plotting tools
myPlot <- nPlot(numberOfFollowing ~ namesOfFollowing, data = finalData, type = "multiBarChart")
myPlot

Graph5 = plot_ly(data = finalData, x = numberOfFollowing, y = namesOfFollowing, type = "bar")
Graph5

#Link to plotly
api_create(Graph5, "Mike Bostocks Following")
