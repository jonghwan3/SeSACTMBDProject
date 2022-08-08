//
//  MovieModel.swift
//  SeSACTMBDProject
//
//  Created by 박종환 on 2022/08/04.
//

import Foundation

struct Movie {
    
    let movieTitle: String
    let date: String
    let rate: Double
    let genreId: Int
    let actors: [Actor]
    let url: URL?
    
}

struct Actor {
    let name: String
}
