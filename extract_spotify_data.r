setwd("/Users/hlt/Projects/University/emerging-tech/SpotifyPrefsPredict")

# Load data and remove duplicates
discover_weekly_data <- read.table("./dataset/archive_audio_features.csv", sep=",", header=TRUE)
saved_playlist_data <- read.table("./dataset/liked_audio_features.csv", sep=",", header=TRUE)

# Remove useless data
set.seed(1234)

# Subsample the data to have equal size datasets
discover_weekly_data <- discover_weekly_data[sample(nrow(discover_weekly_data), 685), ]

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
