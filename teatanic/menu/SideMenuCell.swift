import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var option: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(icon: UIImage, option: String) {
        self.icon.image = icon
        self.option.text = option
    }
}
