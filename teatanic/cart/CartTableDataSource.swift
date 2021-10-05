import UIKit

class CartTableDataSource: NSObject {
    typealias CartItemChangeAction = (Bool) -> ()
    
    private let cartCell = "CartCell"
    private var cart: [CartItem] = []
    private var cartItemChangeAction: CartItemChangeAction?
    
    private var totalPrice: Float {
        cart.map({Float($0.pcs) * $0.tea!.computedPrice }).reduce(0, +)
    }
    
    func configure(completion: @escaping CartItemChangeAction) {
        self.cartItemChangeAction = completion
    }
    
    func fetchCart(completion: (Bool, Float) -> ()) {
        if let cart = CartUtil.fetchCart() {
            self.cart = cart
            completion(true, totalPrice)
        }
        completion(false, 0)
    }
    
    func tea(at index: Int) -> CartItem {
        return cart[index]
    }
    
    func getCart() -> [CartItem] {
        return cart
    }
}

extension CartTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cart.count)
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cartCell, for: indexPath) as? CartCell else {
            fatalError("Could not dequeue cart reusable cell.")
        }
        
        cell.configure(cartItem: cart[indexPath.row]) { newCartItem in
            do {
                if(newCartItem?.pcs == 0) {
                    CartUtil.removeFromCart(tea: newCartItem?.tea, delegate: nil)
                    self.cartItemChangeAction?(true)
                    return
                }
                try CartUtil.context.save()
                self.cartItemChangeAction?(true)
            } catch {
                print("Updating cartItem failed...")
                self.cartItemChangeAction?(false)
            }
        }
        
        return cell
    }
}
