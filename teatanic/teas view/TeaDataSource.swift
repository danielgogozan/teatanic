import UIKit
import FirebaseDatabase
import CodableFirebase

class TeaDataSource: NSObject {
    
    typealias TeaCompletion = (Bool) -> Void
    private let db: DatabaseReference = Database.database().reference()
    private let teaCellId = "TeaTableViewCell"
    private var teas: [Tea] = []
    private var teasCompletion: TeaCompletion?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cart: [CartItem] = []
    var delegate: CartDelegate?
    
    func configure(teaType: String?, cart: [CartItem], completion: @escaping TeaCompletion) {
        self.teasCompletion = completion
        self.cart = cart
        getTeas(teaType: teaType)
    }
    
    func configureCart(cart: [CartItem]) {
        self.cart = cart
    }
    
    private func getTeas(teaType: String?) {
        //self.db.child("teas").queryOrdered(byChild: "type").queryEqual(toValue: teaType).getData
        self.db.child("teas").getData { (error, snapshot) in
            if let error = error {
                print("Error getting teas: \(error)")
                self.teasCompletion?(false)
            }
            else if snapshot.exists() {
                for case let dataSnapshot as DataSnapshot in snapshot.children {
                    if let tea = try? FirebaseDecoder().decode(Tea.self, from: dataSnapshot.value as! [String : Any]) {
                        if(teaType == nil || tea.type == teaType) {
                            self.teas.append(tea)
                        }
                    }
                }
                self.teasCompletion?(true)
            }
        }
    }
    
    func tea(at index: Int) -> Tea {
        return teas[index]
    }
}

extension TeaDataSource : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: teaCellId, for: indexPath) as? TeaTableViewCell else {
            fatalError("Could not dequeue tea cell.")
        }
        
        let isAddedToCart = cart.firstIndex(where: { $0.tea?.name == teas[indexPath.row].name }) != nil
        cell.delegate = delegate
        cell.configure(tea: teas[indexPath.row], isAddedToCart: isAddedToCart)
        return cell
    }
}
