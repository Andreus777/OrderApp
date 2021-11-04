//
//  Order.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import Foundation

struct Order {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
