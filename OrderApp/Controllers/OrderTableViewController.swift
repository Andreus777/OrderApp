//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Андрей Фокин on 4.11.21.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var minutesToPrepareorder = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(tableView!, selector: #selector(tableView.reloadData), name: MenuController.notificationOrderUpdated, object: nil)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.notificationOrderUpdated, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuController.shared.order.menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath){
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = MenuItem.numberFormatter.string(from: NSNumber(value: menuItem.price))
        MenuController.shared.fetchingImage(url: menuItem.imageURL) { image in
            guard let image = image else {return}
            DispatchQueue.main.async {
                if let currentIndexpath = self.tableView.indexPath(for: cell), currentIndexpath != indexPath {
                    return
                }
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(minutesToPrepare: minutesToPrepareorder, coder: coder)
    }
    
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue){
        if segue.identifier == "dismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
        
    }
    
    @IBAction func submitPressed(_ sender: Any?) {
        
        let totalOrder = MenuController.shared.order.menuItems.reduce(0.0) {(result, menuitem) -> Double in
            return result + menuitem.price
        }
        
        let formattedTotatOrder = MenuItem.numberFormatter.string(from: NSNumber(value: totalOrder)) ?? "\(totalOrder)"
        
        let alert = UIAlertController(title: "Submit Order", message: "You're almost ready to confirm your order with a total of \(formattedTotatOrder)", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func uploadOrder(){
        let menuId = MenuController.shared.order.menuItems.map{$0.id}
        MenuController.shared.submitOrder(forMenuID: menuId) { result in
            switch result{
            case .success(let minutesToPrepare):
                DispatchQueue.main.async {
                    self.minutesToPrepareorder = minutesToPrepare
                    self.performSegue(withIdentifier: "confirmOrder", sender: nil)
                }
            case .failure(let error):
                self.displayError(title: "Order submission failed", error: error)
            
            }
        }
    }
    
    func displayError(title: String, error: Error){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
