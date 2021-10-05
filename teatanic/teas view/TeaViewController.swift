import UIKit

class TeaViewController: UIViewController {
    
    @IBOutlet var teasTableView: UITableView!
    private var teaType: TeaType?
    private var dataSource: TeaDataSource?
    private let showTeaDetailSegue = "TeaDetailSegue"
    static let mainStoryboardName = "Main"
    private var cart: [CartItem] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showTeaDetailSegue,
           let destination = segue.destination as? TeaDetailViewController,
           let cell = sender as? TeaTableViewCell,
           let indexPath = teasTableView.indexPath(for: cell) {
            if let tea = dataSource?.tea(at: indexPath.row) {
                destination.delegate = self
                destination.configure(with: tea, isAddedToCart: cart.firstIndex(where: {$0.tea?.name == tea.name}) != nil)
            }
        }
    }
    
    override func viewDidLoad() {
        navigationItem.title = NSLocalizedString(teaType?.type ?? "Teas", comment: "tea type")
        dataSource = TeaDataSource()
        dataSource?.delegate = self
        teasTableView.dataSource = dataSource
        teasTableView.delegate = self
        showProgressBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchCart()
        setupDataSource()
    }
    
    func configure(teaType: TeaType) {
        self.teaType = teaType
    }
    
    private func fetchCart() {
        if let cart = CartUtil.fetchCart() {
            self.cart = cart
        }
    }
    
    private func setupDataSource() {
        DispatchQueue.global(qos: .background).async {
            self.dataSource?.configure(teaType: self.teaType?.type ?? nil, cart: self.cart) { success in
                switch success {
                case true:
                    DispatchQueue.main.async {
                        self.teasTableView.reloadData()
                        self.hideProgressBar()
                    }
                case false:
                    DispatchQueue.main.async {
                        ViewExpert.displayAllertMessage(view: self, alertTitle: Strings.FETCHING_TEAS_TITLE, alertMessage: Strings.FETCHING_TEAS_MESSAGE)
                        self.hideProgressBar()
                    }
                }
            }
        }
    }
}

extension TeaViewController : CartDelegate {
    func cartAction(success: Bool) {
        if success {
            self.fetchCart()
            self.dataSource?.configureCart(cart: self.cart)
            DispatchQueue.main.async {
                self.teasTableView.reloadData()
                self.showToastAtBottom(message: "Cart has been updated", duration: 0.8)
            }
        }
    }
}

extension TeaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
