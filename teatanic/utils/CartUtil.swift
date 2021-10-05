import UIKit

public class CartUtil {
    
    typealias CartAction = (Bool) -> Void
    
    public static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cartAction: CartAction?
    
    static func addToCart(tea: Tea?, delegate: CartDelegate?) {
        let cartItem = CartItem(context: self.context)
        cartItem.pcs = 1
        cartItem.tea = tea
        do {
            try context.save()
            delegate?.cartAction(success: true)
        }
        catch {
            print("Error while adding to the cart: \(error)")
            delegate?.cartAction(success: false)
        }
    }
    
    static func removeFromCart(tea: Tea?, delegate: CartDelegate?) {
        do {
            let cart: [CartItem] = try context.fetch(CartItem.fetchRequest())
            if let index = cart.firstIndex(where: { $0.tea?.name == tea?.name }) {
                self.context.delete(cart[index])
                try self.context.save()
                delegate?.cartAction(success: true)
            }
        }
        catch {
            print("Error while deleting cart item: \(error)")
            delegate?.cartAction(success: false)
        }
    }
    
    static func fetchCart() -> [CartItem]? {
        do {
            return try context.fetch(CartItem.fetchRequest())
        }
        catch {
            print("Error while fetching the cart: \(error)")
        }
        return nil
    }
    
    static func deleteAll(cart: [CartItem], delegate: CartDelegate?) {
        do {
            for cartItem in cart {
                self.context.delete(cartItem)
                try self.context.save()
            }
            delegate?.cartAction(success: true)
        }
        catch {
            print("Error while clearing the cart: \(error)")
            delegate?.cartAction(success: true)
        }
    }
}
