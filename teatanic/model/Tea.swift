import Foundation

public class Tea: NSObject, Decodable, NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(desc, forKey: "desc")
        coder.encode(ingredients, forKey: "ingredients")
        coder.encode(availability, forKey: "availability")
        coder.encode(origin, forKey: "origin")
        coder.encode(picture, forKey: "picture")
        coder.encode(price, forKey: "price")
        coder.encode(type, forKey: "type")
        coder.encode(weight, forKey: "weight")
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String ?? "default"
        self.desc = coder.decodeObject(forKey: "desc") as? String ?? ""
        self.ingredients = coder.decodeObject(forKey: "ingredients") as? String ?? ""
        self.availability = (coder.decodeObject(forKey: "availability") as? String)?.boolValue ?? true
        self.origin = coder.decodeObject(forKey: "origin") as? String ?? ""
        self.picture = coder.decodeObject(forKey: "picture") as? String ?? ""
        self.price = coder.decodeObject(forKey: "price") as? String ?? ""
        self.type = coder.decodeObject(forKey: "type") as? String ?? ""
        self.weight = coder.decodeObject(forKey: "weight") as? String ?? ""
    }
    
    var name: String
    var desc: String
    var ingredients: String
    var availability: Bool
    var origin: String
    var picture: String
    var price: String
    var type: String
    var weight: String
    
    var computedPrice: Float {
        return Float(String(self.price.split(separator: "$")[0])) ?? 0
    }
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
