//
//  World.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation



struct World: Identifiable, Equatable {
    
    let id: String
    let name: String
    let slogan: String
    let imageUrl: String
    let background: String
        
    static func == (lhs: World, rhs: World) -> Bool {
        return lhs.id == rhs.id
    }
    
}
