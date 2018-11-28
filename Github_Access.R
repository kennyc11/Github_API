#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Interrogate_API",
                   key = "ec6b80dda7f8b9758ade",
                   secret = "b6a07323d4049d004f864590c845223aa2c1541f")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp) #run this line and connect them!!! 
1

# Use API
getToken <- config(token = github_token)
#req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

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

#Step 1: Interrogating my own Github and my followers github

#Interrogating my own github "kennyc11"
myGit  <- fromJSON("https://api.github.com/users/kennyc11")
myGit$following #returns the number of people that I am following
myGit$followers #returns the number of people who are following me
myGit$login #returns my login username
myGit$public_repos #returns the number of public repositories I have

lcaRepos <- fromJSON("https://api.github.com/repos/ohalloa2/CS3012_LCA/commits")
lcaRepos$commit$message #The details I included describing each commit to LCA assignment repository

#An interrogation of my repositories in github
myRepos <- fromJSON("https://api.github.com/users/kennyc11/repos")
languagesUsed <- myRepos$language #returns the languages I have used in my repositories
aggregate(data.frame(count = languagesUsed), list(value =languagesUsed), length) #Data frame displaying count for each language 
#df_uniq = unique(languagesUsed)
#length(df_uniq)

#Looking at the commits in my repository for task 1 Software Engineering
myReposCommits <- fromJSON("https://api.github.com/repos/kennyc11/Software-Engineering/commits")
myReposCommits$commit$message #Shows the messages for my commits in this repository



#Returns list of people of who I am following on github
myUsers <- fromJSON("https://api.github.com/users/kennyc11/following")
myUsers$login #returns the username logins of my followers on github
mikeBostock <- myUsers[1,] #gets the first entry in the row from my followers usernames 
mikeBostock$login #returns the login username of Mike Bostock

mikeBostock$organizations_url #gets the url for mike Bostocks organisations in github
mikeBostock$repos_url #url for Mike Bostocks repository in Github

#Interrogation of Mike Bostock's github
mBostockRepos <- fromJSON("https://api.github.com/users/mbostock/repos") 
mBostockRepos$name #returns the name of Mike Bostocks repostiroies names
mBostockRepos$private #returns if Mike Bostocks repos are private or not
mBostockLanguages <- mBostockRepos$language 
mBostockLanguages #returns the lanaguages of Mike Bostocks repositories

#returns the count of the languages used by Mike Bostock in his repositories
aggregate(data.frame(count = mBostockLanguages), list(value =mBostockLanguages), length) 


#Interrogating Mike Bostocks organisations 
mBostockOrgs <- fromJSON("https://api.github.com/users/mbostock/orgs") 
mBostockOrgs$login #returns a list of Mike Bostocks companies
mBostockOrgs$members_url #returns the url for the members on github of the organisations that Mike Bostocks is a member of
mBostockOrgs$repos_url #returns the url for the repositories that Mike Bostock is a member of

#Interrogation of members of Mike Bostock Organisation d3
mBostockOrgsd3 <- fromJSON("https://api.github.com/orgs/d3/members")
mBostockOrgsd3$login #returns the username of d3 members

#Interrogation of d3 repos
d3Repos <- fromJSON("https://api.github.com/orgs/d3/repos")
d3Repos$name #returns the name of d3's repositories

#Interrogating the Github API and returning relevant information as data frames

myDataJSon = toJSON(myGit, pretty = TRUE)
myDataJSon



#Step two, visulisation interrogation of API


#Installing plotly for better visualisation of graphs
install.packages("plotly")
require(devtools)
library(plotly)

#Linking R to plotly. This allows me to create online interactive graphs through interrogation github API
#building visulation of the data available and uploading to plotly using graphs based on d3s library.
Sys.setenv("plotly_username"="kennyc11")
Sys.setenv("plotly_api_key"="zFLJG9Kb2on2xdumwWg1")


