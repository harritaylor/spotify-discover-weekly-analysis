# TODO: 
# - Perform EDA
# - Develop ML model for classification
# - Write report

### Data Preprocessing ### 

setwd("/Users/hlt/Projects/University/emerging-tech/SpotifyPrefsPredict")

# Load data and remove duplicates
discover_weekly_data <- read.table("archive_audio_features.csv", sep=",", header=TRUE)
saved_playlist_data <- read.table("liked_audio_features.csv", sep=",", header=TRUE)

# Remove useless data
saved_playlist_data$mode <- NULL
saved_playlist_data$type <- NULL
saved_playlist_data$audio_features <- NULL
saved_playlist_data$track_href <- NULL
saved_playlist_data$analysis_url <- NULL
saved_playlist_data$uri <- NULL

discover_weekly_data$mode <- NULL
discover_weekly_data$type <- NULL
discover_weekly_data$audio_features <- NULL
discover_weekly_data$track_href <- NULL
discover_weekly_data$analysis_url <- NULL
discover_weekly_data$uri <- NULL

# Remove duplicates within the dataframe
unique_weekly <- unique(discover_weekly_data)
unique_saved <- unique(saved_playlist_data)

# Identify which tracks are shared between the datasets
merged_data <- rbind(unique_weekly,unique_saved)
shared_tracks <- merged_data[duplicated(merged_data$id),]

# Remove tracks from discover_weekly_archive that appear in both datasets
discover_weekly_data <- unique_weekly[!(unique_weekly$id %in% shared_tracks$id),]
saved_playlist_data <- unique_saved

# Add column that specifies if I have saved the song to my personal library
discover_weekly_data$saved <- 0
saved_playlist_data$saved <- 1

# Merge, remove ID column as it is no longer useful, then save to disk.
dataset <- rbind(saved_playlist_data,discover_weekly_data)
dataset$id <- NULL
write.csv(dataset, file = "spotify_dataset_spring18.csv")

### Exploratory Data Analysis


### 