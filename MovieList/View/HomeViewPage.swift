
//
//  HomeViewPage.swift
//  MovieList
//
//  Created by Charitra Prakash Yalimadannanavar on 2/24/24.
//

import SwiftUI

struct HomeViewPage: View {
    @StateObject var viewModel = MovieListViewModel()
    @State var isMovieRowActive = false
    @State var movieId:Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                // List of movies
                List {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }.background(Color(#colorLiteral(red: 0.05, green: 0.2, blue: 0.3, alpha: 2)))
                .listStyle(PlainListStyle())
                .navigationDestination(isPresented: self.$isMovieRowActive){
                    MovieDetailView(movieId: self.movieId)
                }
            }
            .navigationBarTitle("Movies")
        }
      .onAppear(){
        viewModel.loadMoviesFromUserDefaults()
        if(viewModel.movies.isEmpty) {
            viewModel.fetchMovies()
        }
          self.isMovieRowActive = UserDefaults.standard.bool(forKey: "isMovieRowActive")
          self.movieId = UserDefaults.standard.integer(forKey: "MovieId")
    }
}

}

struct HomeViewPage_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewPage()
    }
}
