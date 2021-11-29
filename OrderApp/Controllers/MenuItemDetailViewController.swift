//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    
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
        addToOrderButton.layer.cornerRadius = 5.5
        updateUI()
    }
    
    func updateUI(){
        nameLabel.text = menuItem.name
        detailNameLabel.text = menuItem.detailText
        priceLabel.text = MenuItem.numberFormatter.string(from: NSNumber(value: menuItem.price))
        MenuController.shared.fetchingImage(url: menuItem.imageURL) { image in
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.imageViewLabel.image = image
            }
        }
    }
    
    @IBAction func addToOrderButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MenuController.shared.updateUserActivity(with: .menuItemDetail(menuItem))
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
