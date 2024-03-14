//
//  MovieDetailView.swift
//  MovieList
//
//  Created by Charitra Prakash Yalimadannanavar on 2/24/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    @StateObject var detailViewModel: MovieDetailViewModel
    let movieId: Int

    init(movieId: Int) {
        self.movieId = movieId
        self._detailViewModel = StateObject(wrappedValue: MovieDetailViewModel())
    }

    var body: some View {
        ScrollView {
            VStack {
                if let movie = detailViewModel.movie {
                    Text(movie.title ?? "Unknown Title")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .foregroundColor(.white)
                        
                    
                    HStack {
                        if let releaseDate = movie.release_date {
                            Text(releaseDate).padding().font(.headline).foregroundColor(.white)
                        } else {
                            Text(" ")
                        }
                        if let runningTime = movie.runtime {
                            Text("\(runningTime)m").font(.headline).foregroundColor(.white)
                        } else {
                            Text(" ")
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) { // Adjust the spacing as needed
                            ForEach(0..<3) { _ in // Assuming you want to display two images horizontally
                                if let posterPath = movie.poster_path {
                                    let imageURL = "https://image.tmdb.org/t/p/w780\(posterPath)"
                                    // Use SDWebImageSwiftUI to asynchronously load and display the image
                                    WebImage(url: URL(string: imageURL))
                                        .resizable()
                                        .frame(width: 250, height: 250) // Adjust the frame size as needed
                                        .cornerRadius(35)
                                        .clipped()
                                }
                                if let backdropPath = movie.backdrop_path {
                                    let imageURL = "https://image.tmdb.org/t/p/w780\(backdropPath)"
                                    // Use SDWebImageSwiftUI to asynchronously load and display the image
                                    WebImage(url: URL(string: imageURL))
                                        .resizable()
                                        .frame(width: 250, height: 250) // Adjust the frame size as needed
                                        .cornerRadius(35)
                                        .clipped()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                
            Spacer()
                    // Ratings for the movie
            VStack {
                    HStack(spacing:8) {
                        Text("   ")
                                .font(.headline)
                                                
                        ForEach(movie.genres ?? [], id: \.id) { genre in
                                if let name = genre.name {
                    Capsule()
                            .fill(Color.white)
                        .overlay(
                        Text("\(name)")
                        .font(.headline)
                        .foregroundColor(.black)
                    .padding(8))
                                }
                            }
                        }
                        .padding()
                                            
                RatingStars(rating: movie.vote_average ?? 0)
                        }
                    
                    Spacer()
                    Rectangle()
                        .frame(height: 0.5)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    if let overview = movie.overview {
                        HStack {
                            Text("    Description")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Text(overview)
                            .padding()
                            .foregroundColor(.white)
                    }
                } else {
                    Text("Loading...")
                }
                
                Spacer()
            }
        }.background(Color(#colorLiteral(red: 0.05, green :0.2, blue: 0.3,  alpha: 2)))
        .onAppear {
            detailViewModel.fetchMovie(id: movieId)
            UserDefaults.standard.setValue(true, forKey: "isMovieRowActive")
            UserDefaults.standard.setValue(movieId, forKey: "MovieId")
        }
        .onDisappear{
            UserDefaults.standard.removeObject(forKey: "isMovieRowActive")
            UserDefaults.standard.removeObject(forKey: "MovieId")
        }
    }
}

struct RatingStars: View {
    var rating: Double
    
    var body: some View {
        HStack {
//            Text("\(rating)")
            let filledStars = Int(rating / 2)
            ForEach(0..<filledStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            ForEach(0..<5-filledStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        }
    }
}




struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: 123) // Pass a sample movieId here for preview
    }
}
