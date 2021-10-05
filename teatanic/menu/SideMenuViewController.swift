import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet var menuTable: UITableView!
    @IBOutlet var footerImage: UIImageView!
    
    var menuOptions: [SideMenuOption] = [
        SideMenuOption(icon: UIImage(systemName: "house.fill")!, title: "Tea"),
        SideMenuOption(icon: UIImage(systemName: "cart")!, title: "Cart"),
    ]
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.menuTable.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        self.menuTable.reloadData()
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else {
            fatalError("Could not dequeue reusable cell menu.")
        }
        
        cell.configure(icon: self.menuOptions[indexPath.row].icon, option: self.menuOptions[indexPath.row].title)
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.2403760254, green: 0.255415976, blue: 0.5147255063, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(at: indexPath.row)
    }
}
