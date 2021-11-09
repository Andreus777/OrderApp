//
//  ResponseModel.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//


// добавил эту заметку для теста на гитхаб


import Foundation

struct MenuResponce: Codable {
    var items: [MenuItem]
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
