import UIKit

class MainViewController: UIViewController {
    
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuWidth: CGFloat = 240
    private let rotationPadding: CGFloat = 100
    private var isExpanded: Bool = false
    private var sideMenuShadowView: UIView!
    private let viewTag = 123
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShadow()
        setupSideMenu()
        showViewController(viewController: UINavigationController.self, storyboardId: "MainBoardIDNav")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuWidth - self.rotationPadding)
        }
    }
    
    private func setupShadow() {
        print("setup shadow...")
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .gray
        self.sideMenuShadowView.alpha = 0.0
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.delegate = self
        view.insertSubview(self.sideMenuShadowView, at: 1)
    }
    
    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: 2)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        // Side Menu AutoLayout
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuWidth - self.rotationPadding)
        self.sideMenuTrailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension MainViewController: SideMenuControllerDelegate {
    func selectedCell(at row: Int) {
        switch row {
        case 0:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "MainBoardIDNav")
        case 1:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "CartNavID")
        default:
            break
        }
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
}

extension MainViewController {
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        //deleting existing subviews
        for subview in view.subviews {
            if subview.tag == viewTag {
                subview.removeFromSuperview()
            }
        }
        
        //creating the new view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = viewTag
        view.insertSubview(vc.view, at: 0)
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: 0) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.3) { self.sideMenuShadowView.alpha = 0.6 }
            view.addGestureRecognizer(tapGestureRecognizer!)
        }
        else {
            self.animateSideMenu(targetPosition: (-self.sideMenuWidth - self.rotationPadding)) { _ in
                self.isExpanded = false
            }
            view.removeGestureRecognizer(tapGestureRecognizer!)
            UIView.animate(withDuration: 0.3) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: .layoutSubviews, animations: {
            self.sideMenuTrailingConstraint.constant = targetPosition
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: !self.isExpanded)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc
    func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    //closing the menu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //on menu click, do not close the menu
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
}


extension UIViewController {
    //accessing the MainViewController from children
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is MainViewController {
            return viewController! as? MainViewController
        }
        //iterating through view controllers hierarchy
        while (!(viewController is MainViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        
        return nil
    }
    
    // this one is done using AlertController and the toast appears in the center of the screen
    func showToastAtCenter(message: String, duration seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor(named: "color.green")
        alert.view.layer.cornerRadius = 10
        alert.view.alpha = 0.7
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showToastAtBottom(message: String, duration seconds: Double) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 15)
        toastLabel.backgroundColor = UIColor(named: "color.green")?.withAlphaComponent(0.85)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 0
        
        let textSize = toastLabel.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)
        toastLabel.frame = CGRect(x: 20, y: window.frame.height-90, width: labelWidth + 30, height: textSize.height + 20)
        toastLabel.center.x = window.center.x
        toastLabel.layer.cornerRadius = 10
        toastLabel.layer.masksToBounds = true
        
        window.addSubview(toastLabel)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            UIView.animate(withDuration: seconds, animations: {
                toastLabel.alpha = 0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

extension UIViewController: ProgressBarProtocol {
    
    private var progressBar: CustomProgressBar? {
        if let navBar = navigationController?.topViewController?.view{
            if let progressBar = navBar.subviews.first(where: {$0 is CustomProgressBar}) as? CustomProgressBar {
                return progressBar
            }
            else {
                let progressBar = CustomProgressBar()
                navBar.addSubview(progressBar)
                progressBar.translatesAutoresizingMaskIntoConstraints = false
                let safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
                NSLayoutConstraint.activate([
                                                progressBar.leftAnchor.constraint(equalTo: navBar.leftAnchor),
                                                progressBar.topAnchor.constraint(equalTo: navBar.topAnchor, constant: safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)),
                                                progressBar.rightAnchor.constraint(equalTo: navBar.rightAnchor),
                                                progressBar.heightAnchor.constraint(equalToConstant: 5)])
                return progressBar
            }
        }
        return nil
    }
    
    func showProgressBar() {
        progressBar?.isHidden = false
        progressBar?.showProgressBar()
    }
    
    func hideProgressBar() {
        progressBar?.isHidden = true
        progressBar?.hideProgressBar()
    }
    
    func setProgressBarColors(barColor: UIColor, gradientColor: UIColor) {
        progressBar?.setProgressBarColors(barColor: barColor, gradientColor: gradientColor)
    }
    
}
