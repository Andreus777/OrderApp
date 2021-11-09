//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    
    let menuItem: MenuItem
    
    init?(menuItem: MenuItem, coder: NSCoder){
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
