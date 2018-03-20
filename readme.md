# Evaluating Spotify's Discover Weekly performance using common machine learning tools
## CM3202 Emerging Technologies Coursework Spring 2018

### Introduction
I have added songs that I am currently listening to into a monthly playlist since Summer 2015. I have also kept a record of every song that Spotify has recommended to me via their Discover Weekly service since mid-2016. Using these datasets I have performed a rough analysis of Spotify's prediction model for my music taste. All the code that was used to achieve this is located in this repository (https://github.com/harritaylor/discover-weekly-analysis).

### Dataset Collection & Preparation
Spotify provides an API available to developers in order to make applications using the platform. I was able to query this API using the Requests library in python for song features of all the songs in both the discover weekly archive playlists and my saved favourites playlists. I then combined the datasets and introduced another variable, "saved" in order to distinguish which songs I had personally added to playlists, and which songs Spotify had recommended to me. I also removed all songs that appear in both playlists from the Discover Weekly Archive playlist, as these are songs that Spotify successfully recommended to me that I like. I then saved the data to a CSV file entitled ["spotify\_dataset\_spring18.csv"]("https://github.com/harritaylor/discover-weekly-analysis/blob/master/Spotify_dataset_spring18.csv").

### Exploratory Data Analysis
- [] todo
