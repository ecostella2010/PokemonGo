//
//  PokemonAnnotation.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 15-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit
import MapKit
class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate : CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
    
}
