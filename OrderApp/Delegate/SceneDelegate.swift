//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Андрей Фокин on 2.11.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var orderTabBarItem:UITabBarItem!

    var window: UIWindow?

   @objc func updateBadgeValue(){
       switch MenuController.shared.order.menuItems.count{
       case 0: orderTabBarItem.badgeValue = nil
       case let count: orderTabBarItem.badgeValue = String(count)
       }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeValue), name: MenuController.notificationOrderUpdated, object: nil)
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            configureScene(for: userActivity)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    func configureScene(for userActivity: NSUserActivity){
        if let restoredOrder = userActivity.order{
            MenuController.shared.order = restoredOrder
        }
        
        guard let restorationController = StateRestorationController(userActivity: userActivity),
              let tabBarController = window?.rootViewController as? UITabBarController,
              tabBarController.viewControllers?.count == 2,
              let categoryTableViewController = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController else {return}
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch restorationController {
        
        case .categories: break
        
        case .menu(let category):
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuTableViewController(category: category, coder: coder)
            }
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
        
        case .order: tabBarController.selectedIndex = 1
        
        case .menuItemDetail(let menuItem):
           
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorationController.Identifier.menu.rawValue) { coder in
                return MenuTableViewController(category: menuItem.category, coder: coder)
            }
            
            let menuItemDetailViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuItemDetailViewController(menuItem: menuItem, coder: coder)
            }
            
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: false)
            categoryTableViewController.navigationController?.pushViewController(menuItemDetailViewController, animated: false)
        }
              
    }

    
}

