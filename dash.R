# How large are the datasets on Dash?

library(RCurl)
library(RJSONIO)
library(ggplot2)


# Retrieves metadata for all data sets from dash
get_dash_metadata = function(base_url = "https://dash.ucop.edu"
                             , first_path = "/api/datasets"
                             , seconds_between_requests = 0.1)
{
    # Start with the first response
    first_url = paste0(base_url, first_path)
    j = fromJSON(getURLContent(first_url))

    npages = ceiling(j[["total"]] / j[["count"]])

    # Only 1 page, no need to loop
    if(npages < 2) return(j[["_embedded"]][[1]])

    # Preallocate place for each page to go
    result = vector(npages, mode = "list")

    for(i in seq(npages)){
        message(sprintf("Fetched page %s of %s.", i, npages))
        result[[i]] = j[["_embedded"]][[1]]
        if(i < npages){
            nexturl = paste0(base_url, j[["_links"]][["next"]])
            Sys.sleep(seconds_between_requests)
            j = fromJSON(getURLContent(nexturl))
        }
    }

    # Eliminates nesting from the number of results that the API gave us.
    do.call(c, result)
}


# From the nested list of API response make a data frame with these columns
nested_to_table = function(x
    , columns = c("id", "title", "storage_size", "versionNumber")
){
    # dash wants to make it as easy as possible to upload your data. To
    # that end many fields will be missing data. Then it's up to you, the
    # one processing the metadata, to handle it correctly.
    # 
    # Beginners often find that dealing with the nested structure of the
    # data is more difficult than the API calls. 
    # 
    # Practice for your data munging skills :)
    #
    if(!is.list(x)) x = as.list(x)
    x2 = x[columns]
    empty = sapply(x2, is.null)
    x2[empty] = NA
    out = do.call(data.frame, x2)
    colnames(out) = columns
    out
}


############################################################
# Actually run the code

md = get_dash_metadata()

tmp = lapply(md, nested_to_table)

meta = do.call(rbind, tmp)

# Now we can look at the storage size

# Useful for projector
theme_set(theme_bw(base_size = 20))

ggplot(meta, aes(x = storage_size)) +
    geom_histogram(bins = 20) +
    scale_x_log10() +
    labs(title = "Size of data sets in Dash") +
    labs(caption = "1e3 = KB, 1e6 = MB, 1e9 = GB, 1e12 = TB")

ggsave("sizes.pdf")
