//
//  Movie.swift
//  Tableviews_Part_2//
//  Created by Louis Tur on 9/20/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct Movie {
    
    internal var title: String
    internal var year: Int
    internal var genre: String
    internal var cast: [Actor]
    internal var locations: [String]
    internal var summary: String
    internal var poster: String
    
    init(from data: [String : Any]) {
        
        if let movieTitle: String = data["name"] as? String,
            let movieYear: Int = data["year"] as? Int,
            let movieGenre: String = data["genre"] as? String,
            let movieLocations: [String] = data["locations"] as? [String],
            let movieSynopsis: String = data["description"] as? String,
            let moviePoster: String = data["poster"] as? String
            // 1. we'll need to update our model to include the "poster" key
        {
            
            self.title = movieTitle
            self.year = movieYear
            self.genre = movieGenre
            self.locations = movieLocations
            self.summary = movieSynopsis
            self.poster = moviePoster
            
            if let allActorNames: [String] = data["cast"] as? [String] {
                var castContainer: [Actor] = []
                
                for actorName in allActorNames {
                    castContainer.append(Actor(from: actorName))
                    
                }
                
                self.cast = castContainer
            }
            else {
                self.cast = []
            }
        }

        else {
            self = Movie()
        }
    }
    
    init() {
        self.title = ""
        self.year = 1970
        self.genre = ""
        self.cast = []
        self.locations = []
        self.summary = ""
        self.poster = ""
    }
 }
