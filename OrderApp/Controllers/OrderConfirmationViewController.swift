//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Андрей Фокин on 15.11.21.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    let minutesToPreapare: Int
    @IBOutlet weak var confirmationLabel: UILabel!
    
    
    
    init?(minutesToPrepare: Int, coder: NSCoder){
        self.minutesToPreapare = minutesToPrepare
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
