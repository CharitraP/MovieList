//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Charitra Prakash Yalimadannanavar on 2/24/24.
//

import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let movieStore = "MovieStored"

    func fetchMovies() {
        // Construct the URL with the API key
        let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NWZjMGU5YjBiNWQ3YmIyN2Q1ZjRhMzYzOTQ5YjZiMyIsInN1YiI6IjY1ZDkyZmZjMGYwZGE1MDE2MjMyMmNjMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SKA1aWfUuedyy8jl0u2cpNhFMsYSU397sgsup64Rn7k"
        let urlString = "https://api.themoviedb.org/4/list/1?"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Accept") // Fixed accept header value
        
        // Use the correct key for the "Authorization" header
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Decode JSON response
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                
                DispatchQueue.main.async { // Update on the main thread
                    
                    self.movies = movieResponse.results
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    private func saveMoviesToUserDefaults() {
           do {
               let encodedData = try JSONEncoder().encode(movies)
               UserDefaults.standard.set(encodedData, forKey: movieStore)
           } catch {
               print("Error encoding movies:", error)
           }
       }
    
    func loadMoviesFromUserDefaults() {
            if let encodedData = UserDefaults.standard.data(forKey: movieStore) {
                do {
                    let decodedMovies = try JSONDecoder().decode([Movie].self, from: encodedData)
                    self.movies = decodedMovies
                } catch {
                    print("Error decoding movies:", error)
                }
            }
        }
    
    func deleteItem(at offsets: IndexSet) {
            movies.remove(atOffsets: offsets)
            self.saveMoviesToUserDefaults()
    }
    
}
