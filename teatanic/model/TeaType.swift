import Foundation

struct TeaType : Equatable, Codable {
    var type : String
    var info: String
    
    init(type: String, info: String) {
        self.type = type
        self.info = info
    }
}
