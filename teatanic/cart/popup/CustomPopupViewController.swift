import UIKit

class CustomPopupViewController: UIViewController {
    
    private var popupView: CustomPopupView?
    private var delegate: CartDeleteDelegate?
    
    init(title: String, message: String, noButton: String, yesButton: String, delegate: CartDeleteDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        popupView = CustomPopupView()
        popupView?.configure(title, message, noButton, yesButton)
        popupView?.noButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        popupView?.yesButton.addTarget(self, action: #selector(deleteAllAndDismiss), for: .touchUpInside)
        view = popupView
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteAllAndDismiss() {
        self.dismiss(animated: true, completion: nil)
        delegate?.deleteAll()
    }
}
