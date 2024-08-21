//
//  Message.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct Message: Identifiable{
    
    let id: String
    let fromId: String
    let toId: String
    let content: String
    let read: Bool
    let timestamp: Date
    
    let ownerImageUrl: String
    let displayName: String
    
    
}
