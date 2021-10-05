import UIKit

class TeaTableViewCell: UITableViewCell {
    
    @IBOutlet var teaImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var priceAndWeightLabel: UILabel!
    @IBOutlet var soldOutImage: UIImageView!
    @IBOutlet var cartButton: UIButton!
    private var tea: Tea?
    private var isAddedToCart: Bool = false
    var delegate: CartDelegate?
    
    func configure(tea: Tea, isAddedToCart: Bool) {
        self.tea = tea
        self.isAddedToCart = isAddedToCart
        nameLabel.text = tea.name
        originLabel.text = tea.origin
        priceAndWeightLabel.text = tea.price + " | " + tea.weight
        teaImage.image = ViewExpert.loadImage(path: tea.picture)
        soldOutImage.isHidden = tea.availability ? true : false
        cartButton.isHidden = tea.availability ? false : true
        if isAddedToCart {
            cartButton.setImage(UIImage(named: "cart.remove"), for: .normal)
        } else {
            cartButton.setImage(UIImage(named: "cart.add"), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    @IBAction func onAddToCartClick(_ sender: Any) {
        if !isAddedToCart {
            print("Adding to cart....")
            CartUtil.addToCart(tea: self.tea, delegate: delegate)
        }
        // should be removed if it was added.
        else {
            print("Removing from cart....")
            CartUtil.removeFromCart(tea: self.tea, delegate: delegate)
        }
    }
}
