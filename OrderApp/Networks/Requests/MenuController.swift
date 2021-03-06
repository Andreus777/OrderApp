//
//  MenuController.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import Foundation
import UIKit

class MenuController {
    
    static let shared = MenuController()
    static let notificationOrderUpdated = Notification.Name("MenuController.Updated")
    
    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")
   
    var order = Order(){
        didSet{
            NotificationCenter.default.post(name: MenuController.notificationOrderUpdated, object: nil)
            userActivity.order = order
        }
    }
    
    
    typealias minuteToPrepare = Int
    
    let baseUrl = URL(string: "http://localhost:8080/")!
    
    
    func fetchingCategories(completion: @escaping(Result<[String], Error>) -> Void ){
        let categoriesURL = baseUrl.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoriesURL) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let categoriesResponse = try jsonDecoder.decode(CategoriesResponce.self, from: data)
                    completion(.success(categoriesResponse.categories))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchingMenuItems(forCategory categoryName: String, completion: @escaping (Result<[MenuItem], Error>) -> Void){
        let baseMenuURL = baseUrl.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let menuResponse = try jsonDecoder.decode(MenuResponce.self, from: data)
                    completion(.success(menuResponse.items))
                } catch  {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    
    func submitOrder(forMenuID menuIDs: [Int], completion: @escaping(Result<minuteToPrepare, Error>) -> Void){
        let orderURL = baseUrl.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do {
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func fetchingImage(url: URL, completion: @escaping (UIImage?)-> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func updateUserActivity(with controller: StateRestorationController ){
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .categories, .order: break
         
        }
        userActivity.controllerIdentifier = controller.identifier
    }
}
