import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet var menuBtn: UIBarButtonItem!
    @IBOutlet var cartTable: UITableView!
    
    private var dataSource: CartTableDataSource?
    private var teaDetailSegue = "CartTeaDetailSegue"
    @IBOutlet var totalPriceLabel: UILabel!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var orderButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == teaDetailSegue,
           let destination = segue.destination as? TeaDetailViewController,
           let cell = sender as? CartCell,
           let indexPath = cartTable.indexPath(for: cell) {
            guard let cartItem = dataSource?.tea(at: indexPath.row) else {
                print("Cart item at row index \(indexPath.row) couldn't be retrieved.")
                return
            }
            destination.delegate = self
            destination.configure(with: cartItem.tea!, isAddedToCart: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        dataSource = CartTableDataSource()
        dataSource?.configure { success in
            if success {
                self.refreshCart()
            }
        }
        cartTable.dataSource = dataSource
        cartTable.delegate = self
        refreshCart()
        
    }
    
    private func refreshCart() {
        dataSource?.fetchCart{ success, totalPrice in
            if success {
                DispatchQueue.main.async {
                    self.totalPriceLabel.text = "\(String(format: "%.2f", totalPrice))$"
                    self.cartTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func cancelButtonTrigger(_ sender: Any) {
        let customPopup = CustomPopupViewController(title: "Don't forget", message: "A cup of tea can sometimes be magic", noButton: "that's right", yesButton: "drop it", delegate: self)
        self.present(customPopup, animated: true, completion: nil)
    }
    
    @IBAction func orderButtonTrigger(_ sender: Any) {
        deleteAll()
        DispatchQueue.main.async {
            self.showToastAtBottom(message: "Your order has been placed", duration: 0.8)
        }
    }
    
}

extension CartViewController: CartDeleteDelegate {
    func deleteAll() {
        CartUtil.deleteAll(cart: dataSource?.getCart() ?? [], delegate: self)
    }
}

extension CartViewController: CartDelegate {
    func cartAction(success: Bool) {
        refreshCart()
        DispatchQueue.main.async {
            self.cartTable.reloadData()
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
