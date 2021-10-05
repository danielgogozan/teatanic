import UIKit

class CartCell: UITableViewCell {
    typealias CartItemChangeAction = (CartItem?) -> ()
    
    @IBOutlet var pcsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var typeCircle: UIView!
    
    private var cartItem: CartItem?
    private var cartItemChangeAction: CartItemChangeAction?
    
    func configure(cartItem: CartItem, completion: @escaping CartItemChangeAction) {
        self.cartItem = cartItem
        pcsLabel.text = String(cartItem.pcs)
        nameLabel.text = cartItem.tea?.name
        priceLabel.text = cartItem.tea?.price
        weightLabel.text = cartItem.tea?.weight
        typeLabel.text = cartItem.tea?.type
        self.cartItemChangeAction = completion
        stepper.value = Double(cartItem.pcs)
        typeCircle.clipsToBounds = true
        typeCircle.layer.cornerRadius = typeCircle.layer.bounds.width/2
        typeCircle.backgroundColor = Strings.teaTypeColors[cartItem.tea?.type ?? ""]
    }
    
    @IBAction func onStepperValuChanged(_ sender: UIStepper) {
        cartItem?.pcs = Int64(sender.value)
        cartItemChangeAction?(cartItem)
    }
}
