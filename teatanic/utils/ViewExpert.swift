import UIKit

final class ViewExpert {
    
    public static func displayAllertMessage(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alertTitle = NSLocalizedString(alertTitle, comment: "alert title")
        let alertMessage = NSLocalizedString(alertMessage, comment: "alert message")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "ok action")
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            view.dismiss(animated: true, completion: nil)
            view.navigationController?.popToRootViewController(animated: true)
        }))
        
        view.present(alert, animated: true, completion: nil )
    }
    
    public static func loadImage(path: String?) -> UIImage {
        guard let imagePath = path,
              let imageUrl = URL(string: imagePath),
              let image = try? Data(contentsOf: imageUrl) else {
            print("Bad image path: \(String(describing: path))")
            return UIImage(named: "teatanic")!
        }
        return UIImage(data: image)!
    }
}
