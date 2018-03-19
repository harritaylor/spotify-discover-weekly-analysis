dataset <- read.table("spotify_dataset_spring18.csv", sep=",", header=TRUE)

spotify_dataset <- dataset
# Some tracks don't have audio features, most commonly recognised by no tempo value
# As these tracks do not contribute to the model, remove them
spotify_dataset <- spotify_dataset[!(spotify_dataset$tempo==0),]

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
r_line <- rgb(1,0,0,1)
r_col  <- rgb(1,0,0,0.3)
b_line <- rgb(0,0,1,1)
b_col  <- rgb(0,0,1,0.3)
# View all features saved vs not-saved

# 1. Danceability
hist(discover_danceability,
     col=r_col,
     main="1. Dancability",
     xlab="Dancability Measure",
     prob=TRUE,
     ylim=c(0,2.5))
hist(saved_danceablility,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_danceability),
      col=r_line,
      lwd=2)
lines(density(saved_danceability),
      col=b_line,
      lwd=2)
legend(0.01,2.5,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), 
       pch=15, 
       cex=0.8)
box()

# 2. Energy
hist(discover_energy,
     col=r_col,
     main="2. Energy",
     xlab="Energy Measure",
     prob=TRUE,
     ylim=c(0,2))
hist(saved_energy,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_energy),
      col=r_line,
      lwd=2)
lines(density(saved_energy),
      col=b_line,
      lwd=2)
legend(0.01,1.9, 
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15, 
       cex=0.8)
box()

# 3. Loudness
hist(discover_loudness,
     col=r_col,
     main="3. Loudness",
     xlab="Loudness (dB)",
     prob=TRUE,
     ylim=c(0,.13))
hist(saved_loudness,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_loudness),
      col=r_line,
      lwd=2)
lines(density(saved_loudness),
      col=b_line,
      lwd=2)
legend(-32,0.125, 
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"), 
       pch=15, 
       cex=0.8)
box()

# 4. Speechiness
hist(discover_speechiness,
     col=r_col,
     main="4. Speechiness",
     xlab="Speechiness Measure",
     prob=TRUE,
     ylim=c(0,30))
hist(saved_speechiness,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_speechiness),
      col=r_line,
      lwd=2)
lines(density(saved_speechiness),
      col=b_line,
      lwd=2)
legend(0.33,30,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15, 
       cex=0.8)
box()

# 5. Acousticness
hist(discover_acousticness,
     col=r_col,
     main="5. Acousticness",
     xlab="Acousticness Measure",
     prob=TRUE,
     ylim=c(0,6))
hist(saved_acousticness,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_acousticness),
      col=r_line,
      lwd=2)
lines(density(saved_acousticness),
      col=b_line,
      lwd=2)
legend(0.65,6,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15,
       cex=0.8)
box()

# 6. Instrumentalness
hist(discover_instrumentalness,
     col=r_col,
     main="6. Instrumentalness",
     xlab="Instrumentalness Measure",
     prob=TRUE,
     ylim=c(0,6))
hist(saved_instrumentalness,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_instrumentalness),
      col=r_line,
      lwd=2)
lines(density(saved_instrumentalness),
      col=b_line,
      lwd=2)
legend(0.65,6,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15, 
       cex=0.8)
box()

# 7. Liveness
hist(discover_liveness,
     col=r_col,
     main="7. Liveness",
     xlab="Liveness Measure",
     prob=TRUE,
     ylim=c(0,7))
hist(saved_liveness,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_liveness),
      col=r_line,
      lwd=2)
lines(density(saved_liveness),
      col=b_line,
      lwd=2)
legend(0.65,7,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15,
       cex=0.8)
box()

# 8. Valence
hist(discover_valence,
     col=r_col,
     main="8. Valence",
     xlab="Valence Measure",
     prob=TRUE)
hist(saved_valence,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_valence),
      col=r_line,
      lwd=2)
lines(density(saved_valence),
      col=b_line,
      lwd=2)
legend(-0.03,1.52,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15,
       cex=0.7)
box()

# 9. Tempo
hist(discover_tempo,
     col=r_col,
     main="9. Tempo",
     xlab="Beats Per Minute",
     prob=TRUE,
     ylim=c(0,0.015))
hist(saved_tempo,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_tempo),
      col=r_line,
      lwd=2)
lines(density(saved_tempo),
      col=b_line,
      lwd=2)
legend(155,0.015,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15, 
       cex=0.8)
box()

# 10. Duration
hist(discover_duration,
     col=r_col,
     main="10. Song Duration",
     xlab="Time (Milliseconds)",
     prob=TRUE,
     ylim=c(0,6e-06))
hist(saved_duration,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_duration),
      col=r_line,
      lwd=2)
lines(density(saved_duration),
      col=b_line,
      lwd=2)
legend(4e+05,6e-06,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15,
       cex=0.8)
box()

# 11. Time signature
hist(discover_time_signature,
     col=r_col,
     main="11. Time Signature",
     xlab="(1 / time signature)",
     prob=TRUE,
     ylim=c(0,5),
     xlim=c(2,5))
hist(saved_time_signature,
     col=b_col,
     add=T,
     prob=TRUE)
lines(density(discover_time_signature),
      col=r_line,
      lwd=2)
lines(density(saved_time_signature),
      col=b_line,
      lwd=2)
legend(2,5,
       legend=c("Discover Weekly", "Saved to playlist"),
       col=c("red", "blue"),
       pch=15, 
       cex=0.8)
box()
