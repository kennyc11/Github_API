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
gtoken <- config(token = github_token)
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



#Interrogating my own github "kennyc11"
myGit  <- fromJSON("https://api.github.com/users/kennyc11")
myGit$following #returns the number of people that I am following
myGit$followers #returns the number of people who are following me
myGit$login #returns my login username
myGit$public_repos #returns the number of public repositories I have

#An interrogation of my repositories in github
myRepos <- fromJSON("https://api.github.com/users/kennyc11/repos")
myRepos$language #returns the languages I have used in my repositories
length(myRepos$language) #returns the count of languages used in my repositories

#Returns list of people as a matrix of who I am following on github
myUsers <- fromJSON("https://api.github.com/users/kennyc11/following")
myUsers$login #returns the username logins of my followers on github
mikeBostock <- myUsers[1,] #gets the first entry in the row from my followers usernames 
mikeBostock$login #returns the login username of Mike Bostock

mikeBostock$organizations_url #gets the url for mike Bostocks organisations in github
mikeBostock$repos_url

mBostockRepos <- fromJSON("https://api.github.com/users/mbostock/repos") 
mBostockRepos$name #returns the name of Mike Bostocks repostiroies names
mBostockRepos$private #returns if Mike Bostocks repos are private or not
mBostockRepos$language #returns the lanaguages of Mike Bostocks repositories

#Interrogating Mike Bostocks organisations 
mBostockOrgs <- fromJSON("https://api.github.com/users/mbostock/orgs") 
mBostockOrgs$login #returns a list of Mike Bostocks companies
mBostockOrgs$members_url
mBostockOrgs$repos_url

#Interrogation of members of Mike Bostock Organisation d3
mBostockOrgsd3 <- fromJSON("https://api.github.com/orgs/d3/members")
mBostockOrgsd3$login #returns the username of d3 members

#Interrogation of d3 repos
d3Repos <- fromJSON("https://api.github.com/orgs/d3/repos")
d3Repos$name #returns the name of d3's repositories
d3Repos$





