import UIKit

class TeaDetailViewController: UIViewController {
        
    @IBOutlet var teaImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var ingredientsTable: WrapContentTableView!
    @IBOutlet var cartButton: UIButton!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    private var ingredientsDataSource: IngredientsDataSource?
    private var isAddedToCart = false

    var delegate: CartDelegate?
    
    private var tea: Tea?
    
    func configure(with tea: Tea, isAddedToCart: Bool) {
        self.tea = tea
        self.isAddedToCart = isAddedToCart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tea = tea {
            setupViews(tea: tea)
        }
    }
    
    private func setupViews(tea: Tea) {
        teaImage.image = ViewExpert.loadImage(path: tea.picture)
        originLabel.text = tea.origin
        priceLabel.text = tea.price
        weightLabel.text = tea.weight
        nameLabel.text = tea.name
        descriptionLabel.text = tea.desc
        setupIngredientsTable(tea: tea)
        setupButtonImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.ingredientsTable.contentSize.height - 25
    }
    
    private func setupIngredientsTable(tea: Tea) {
        let ingredients = tea.ingredients.components(separatedBy: ",")
        ingredientsDataSource = IngredientsDataSource()
        ingredientsDataSource?.configure(with: ingredients)
        ingredientsTable.dataSource = ingredientsDataSource
        ingredientsTable.reloadData()
    }
    
    @IBAction func cartButtonTrigger(_ sender: Any) {
        if !isAddedToCart {
            print("Adding to cart...")
            CartUtil.addToCart(tea: self.tea, delegate: delegate)
        }
        else {
            print("Removing from cart...")
            CartUtil.removeFromCart(tea: self.tea, delegate: delegate)
        }
        
        isAddedToCart.toggle()
        setupButtonImage()
    }
    
    private func setupButtonImage() {
        if !(tea?.availability ?? true) {
            cartButton.isHidden = true
            return
        }
        if isAddedToCart {
            cartButton.setImage(UIImage(named: "cart.remove"), for: .normal)
        } else {
            cartButton.setImage(UIImage(named: "cart.add"), for: .normal)
        }
    }
}
