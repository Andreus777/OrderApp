//
//  ResponseModel.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import Foundation

struct MenuResponce: Codable {
    var item: [MenuItem]
}


struct CategoriesResponce: Codable {
    var categories: [String]
}

struct OrderResponse: Codable{
    var prepTime: Int
    
    enum CodingKeys: String, CodingKey{
        case prepTime = "preparation_time"
    }
}
