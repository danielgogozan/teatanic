import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var teaTypeLabel: UILabel!
    
    func configure(image: UIImage, labelText: String) {
        imageView.image = image
        teaTypeLabel.text = labelText
        roundImageCorners()
    }
    
    func roundImageCorners() {
        imageView.layer.cornerRadius=20;
        imageView.layer.masksToBounds = true;
    }
}
