# Let's look at this file as an example. It's recent, has several
# researchers from UC Davis, and small files sizes.
#
# https://dash.ucdavis.edu/stash/dataset/doi:10.25338/B8P88G

# We don't need API's for simple things. For example, if I want to
# access a file from an R script I can find the URL by browsing the web page.
#
# Ie. download the file from:
# https://dash.ucdavis.edu/stash/downloads/file_download/28115

library(RCurl)
library(RJSONIO)


base_url = "https://dash.ucop.edu"

ds_url = paste0(base_url, "/api/datasets")

raw = getURLContent(ds_url)

j = fromJSON(raw)

names(j)

# Now we'll explore this nested data structure

# I think this is how many individual results
j[["count"]]

# How many total results?
j[["total"]]

# 1. YOUR TURN: 
# What is the URL for the next page of results?

# Then we see a bunch of stuff here.
j[["_embedded"]]

# Essentially this is all about understanding the structure of the nested data.
# Handy functions: names, length, class, str

# Seemingly extraneous layer of nesting. Common.

# But this is an actual data object, we see familiar fields like title,
# authors, abstract.
names(j[["_embedded"]][[1]][[1]])

j[["_embedded"]][[1]][[1]][["id"]]


# Appears to be a URL for direct download
j[["_embedded"]][[1]][[1]][["_links"]][["stash:download"]]

# 2. YOUR TURN:
# What is the storage size of the first record?


# If we want to access the first directly
rel_url = j[["_embedded"]][[1]][[1]][["_links"]][["self"]]

raw2 = getURLContent(paste0(base_url, rel_url))
j2 = fromJSON(raw2)

# Notice different between href and id.
# If I have the DOI and I want to access the record:

URLdecode(rel_url)

# This DOI is pretty cool.
doi = "doi:10.25338/B8P88G"

# This is the kind of gibberish we're after
url3 = paste0(base_url, "/api/datasets/", URLencode(doi, reserved = TRUE))

# Now we can go directly to it
raw3 = getURLContent(url3)

j3 = fromJSON(raw3)

# 3. YOUR TURN:
# Download the data set from the above record.






## Answers

# 1
j[[c("_links", "next")]]

# 2
j[["_embedded"]][[1]][[1]][["storage_size"]]

# 3
url3 = paste0(base_url, j3[[c("_links", "stash:download")]])
download.file(url3, "dash3.zip")
