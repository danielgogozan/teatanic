import UIKit
import FirebaseDatabase
import CodableFirebase

class BoardDataSource: NSObject {
    
    private let teaTypeCell = "TeaTypeCell"
    private let db: DatabaseReference = Database.database().reference()
    private var teaTypes : [TeaType] = []
    
    func configure(completion: @escaping () -> Void) {
        self.db.child("teatypes").getData { (error, snapshot) in
            if let error = error {
                print("Error getting tea types: \(error)")
                return
            }
            else if snapshot.exists() {
                for case let dataSnapshot as DataSnapshot in snapshot.children {
                    if let teaType = try? FirestoreDecoder().decode(TeaType.self, from: dataSnapshot.value as! [String : Any]) {
                        self.teaTypes.append(teaType)
                    }
                    completion()
                }
            }
        }
    }
    
    func teaType(at index: Int) -> TeaType {
        return teaTypes[index]
    }
}

extension BoardDataSource : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teaTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teaTypeCell, for: indexPath) as? BoardCollectionViewCell else {
            fatalError("Unable to dequeue tea cell.")
        }
        
        guard let teaTypeRow = TeaTypeRow(rawValue: indexPath.row) else {
            fatalError("ETeaType Index out of range")
        }
        
        cell.configure(image: teaTypeRow.image, labelText: teaTypeRow.labelText)
        
        return cell
    }
}

extension BoardDataSource {
    enum TeaTypeRow: Int, CaseIterable {
        case black
        case white
        case green
        case oolong
        case puerh
        case purple
        case herbal
        
        var image : UIImage {
            switch self {
            case .black: return UIImage(named: "tea.black")!
            case .white: return UIImage(named: "tea.white")!
            case .green: return UIImage(named: "tea.green")!
            case .purple: return UIImage(named: "tea.purple")!
            case .oolong: return UIImage(named: "tea.oolong")!
            case .puerh: return UIImage(named: "tea.puerh")!
            case .herbal: return UIImage(named: "tea.herbal")!
            }
        }
        
        var labelText: String {
            switch self {
            case .black: return Strings.TEA_BLACK
            case .white: return Strings.TEA_WHITE
            case .green: return Strings.TEA_GREEN
            case .purple: return Strings.TEA_PURPLE
            case .oolong: return Strings.TEA_OOLONG
            case .puerh: return Strings.TEA_PUERH
            case .herbal: return Strings.TEA_HERBAL
            }
        }
    }
}
