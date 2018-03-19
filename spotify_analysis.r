# TODO:
# - Perform EDA
# - Develop ML model for classification
# - Write report

### Data Preprocessing ###

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

# Clear workspace
rm(list = ls())

dataset <- read.table("spotify_dataset_spring18.csv", sep=",", header=TRUE)

spotify_dataset <- dataset
# Some tracks don't have audio features, most commonly recognised by no tempo value
# As these tracks do not contribute to the model, remove them
spotify_dataset <- spotify_dataset[!(spotify_dataset$tempo==0),]

# Remove fields that won't be used
spotify_dataset$mode <- NULL
spotify_dataset$type <- NULL
spotify_dataset$audio_features <- NULL
spotify_dataset$track_href <- NULL
spotify_dataset$analysis_url <- NULL
spotify_dataset$X <- NULL
spotify_dataset$key <- NULL
spotify_dataset$uri <- NULL

# Partition dataset into variables for visualisation

# Saved playlists
saved_subset           <- subset(spotify_dataset, spotify_dataset$saved == 1)

saved_danceability    <- saved_subset$danceability
saved_energy           <- saved_subset$energy
saved_loudness         <- saved_subset$loudness
saved_speechiness      <- saved_subset$speechiness
saved_acousticness     <- saved_subset$acousticness
saved_instrumentalness <- saved_subset$instrumentalness
saved_liveness         <- saved_subset$liveness
saved_valence          <- saved_subset$valence
saved_tempo            <- saved_subset$tempo
saved_duration         <- saved_subset$duration_ms
saved_time_signature   <- saved_subset$time_signature

# Discover weekly archive
discover_subset           <- subset(spotify_dataset, spotify_dataset$saved == 0)

discover_danceability     <- discover_subset$danceability
discover_energy           <- discover_subset$energy
discover_loudness         <- discover_subset$loudness
discover_speechiness      <- discover_subset$speechiness
discover_acousticness     <- discover_subset$acousticness
discover_instrumentalness <- discover_subset$instrumentalness
discover_liveness         <- discover_subset$liveness
discover_valence          <- discover_subset$valence
discover_tempo            <- discover_subset$tempo
discover_duration         <- discover_subset$duration_ms
discover_time_signature   <- discover_subset$time_signature


### Exploratory Data Analysis

# View all features saved vs not-saved

# 1. Danceability
hist(discover_danceability,
     col=rgb(1,0,0,0.5),
     xlab="1. \"Dancability\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,2.5))
hist(saved_danceablility,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_danceability),
      col=rgb(1,0,0,0.5))
lines(density(saved_danceability),
      col=rgb(0,0,1,0.5))
box()

# 2. Energy
hist(discover_energy,
     col=rgb(1,0,0,0.5),
     xlab="2. \"Energy\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,2))
hist(saved_energy,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_energy),
      col=rgb(1,0,0,0.5))
lines(density(saved_energy),
      col=rgb(0,0,1,0.5))
box()

# 3. Loudness
hist(discover_loudness,
     col=rgb(1,0,0,0.5),
     xlab="3. Loudness (dB)",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,.13))
hist(saved_loudness,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_loudness),
      col=rgb(1,0,0,0.5))
lines(density(saved_loudness),
      col=rgb(0,0,1,0.5))
box()

# 4. Speechiness
hist(discover_speechiness,
     col=rgb(1,0,0,0.5),
     xlab="4. \"Speechiness\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,30))
hist(saved_speechiness,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_speechiness),
      col=rgb(1,0,0,0.5))
lines(density(saved_speechiness),
      col=rgb(0,0,1,0.5))
box()

# 5. Acousticness
hist(discover_acousticness,
     col=rgb(1,0,0,0.5),
     xlab="5. \"Acousticness\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,6))
hist(saved_acousticness,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_acousticness),
      col=rgb(1,0,0,0.5))
lines(density(saved_acousticness),
      col=rgb(0,0,1,0.5))
box()

# 6. Instrumentalness
hist(discover_instrumentalness,
     col=rgb(1,0,0,0.5),
     xlab="6. \"Instrumentalness\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,6))
hist(saved_instrumentalness,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_instrumentalness),
      col=rgb(1,0,0,0.5))
lines(density(saved_instrumentalness),
      col=rgb(0,0,1,0.5))
box()

# 7. Liveness
hist(discover_liveness,
     col=rgb(1,0,0,0.5),
     xlab="7. \"Liveness\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE,
     ylim=c(0,7))
hist(saved_liveness,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_liveness),
      col=rgb(1,0,0,0.5))
lines(density(saved_liveness),
      col=rgb(0,0,1,0.5))
box()

# 8. Valence
hist(discover_valence,
     col=rgb(1,0,0,0.5),
     xlab="8. \"Valence\"",
     main="Red: discover weekly, Blue: saved",
     prob=TRUE)
hist(saved_valence,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_valence),
      col=rgb(1,0,0,0.5))
lines(density(saved_valence),
      col=rgb(0,0,1,0.5))
legend(-0.03,1.52, legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), lty=1:1, cex=0.8)
box()

# 9. Tempo
hist(discover_tempo,
     col=rgb(1,0,0,0.5),
     main="9. Tempo",
     xlab="Beats Per Minute",
     prob=TRUE,
     ylim=c(0,0.015))
hist(saved_tempo,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_tempo),
      col=rgb(1,0,0,0.5))
lines(density(saved_tempo),
      col=rgb(0,0,1,0.5))
legend(155,0.015, legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), lty=1:1, cex=0.8)
box()

# 10. Duration
hist(discover_duration,
     col=rgb(1,0,0,0.5),
     main="10. Song Duration",
     xlab="Time (Milliseconds)",
     prob=TRUE,
     ylim=c(0,6e-06),
     xlim=c(0,7e+05))
hist(saved_duration,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_duration),
      col=rgb(1,0,0,0.5))
lines(density(saved_duration),
      col=rgb(0,0,1,0.5))
legend(4e+05,6e-06, legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), lty=1:1, cex=0.8)
box()

# 11. Time signature
hist(discover_time_signature,
     col=rgb(1,0,0,0.5),
     main="11. Time Signature",
     xlab="(1 / time signature)",
     prob=TRUE,
     ylim=c(0,5),
     xlim=c(2,5))
hist(saved_time_signature,
     col=rgb(0,0,1,0.5),
     add=T,
     prob=TRUE)
lines(density(discover_time_signature),
      col=rgb(1,0,0,0.5))
lines(density(saved_time_signature),
      col=rgb(0,0,1,0.5))
legend(2,5, legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), lty=1:1, cex=0.8)
box()

###
