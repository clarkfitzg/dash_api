# Tue Mar 13 15:39:38 PDT 2018
#
# Experimenting with the dash API for Vessela Engsberg
#


# An API lets you easily access metadata about these scientific data sets.
#
# Why would you want to do this? A couple reasons I can think of:
# - 
#
# Let's look at this file as an example. It's recent, has several
# researchers from UC Davis, and small files sizes.
#
# https://dash.ucdavis.edu/stash/dataset/doi:10.25338/B8P88G

# Motivating question:
#
# How large are the datasets on Dash?


library(RCurl)
library(RJSONIO)


# We don't need API's for simple things. For example, if I want to
# access a file from an R script I can find the URL by browsing the main
# page:
# https://dash.ucdavis.edu/stash/dataset/doi:10.25338/B8QC7F
# I can do something like the following:
# TODO: get
# Or just paste the URL into a browser
# https://dash.ucdavis.edu/stash/downloads/file_download/27666


base_url = "https://dash.ucop.edu"

ds_url = paste0(base_url, "/api/datasets")

raw = getURLContent(ds_url)

j = fromJSON(raw)

names(j)

# What is a link to the next and previous pages of results?
j[["_links"]]

# I think this is how many individual results
j[["count"]]

# How many total results?
j[["total"]]

# Then we see a bunch of stuff here.
j[["_embedded"]]

# Seemingly extraneous layer of nesting. Common.
# But this is an actual data object, we see familiar fields like title,
# authors, abstract.
names(j[["_embedded"]][[1]][[1]])

j[["_embedded"]][[1]][[1]][["id"]]


# Appears to be a URL for direct download
j[["_embedded"]][[1]][[1]][["_links"]][["stash:download"]]

j[["_embedded"]][[1]][[1]][["storage_size"]]


# If we want to go directly there:
rel_url = j[["_embedded"]][[1]][[1]][["_links"]][["self"]]

raw2 = getURLContent(paste0(base_url, rel_url))
j2 = fromJSON(raw2)

# Notice different between href and id.
# If I have the DOI and I want to access the record:

# This DOI is pretty cool. Maybe Vessela can explain what it means.
pems_doi = "DOI:10.25338/B8QC7F"

# This is the kind of gibberish we're after
pems_url = paste0(base_url, "/api/datasets/", URLencode(pems_doi, reserved = TRUE))

# All works great.
raw3 = getURLContent(pems_url)

j3 = fromJSON(raw3)


