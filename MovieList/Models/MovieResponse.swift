//
//  MovieResponse.swift
//  MovieList
//
//  Created by Charitra Prakash Yalimadannanavar on 2/27/24.
//

import Foundation
struct MovieResponse: Decodable {
    var average_rating : Double
    var backdrop_path : String
    var results : [Movie]
}
