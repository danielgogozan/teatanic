import UIKit

class IngredientsDataSource: NSObject {
    private var ingredients: [String] = []
    private let ingredientCellId = "IngredientCell"
    
    func configure(with ingredients: [String]) {
        self.ingredients = ingredients
    }
}

extension IngredientsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellId, for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        cell.imageView?.image = UIImage(named: "ingredient")
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}
