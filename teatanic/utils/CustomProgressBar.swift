import UIKit

class CustomProgressBar: UIView {
    
    private var barColor: UIColor = UIColor(named: "color.green") ?? UIColor.green
    private var gradientColor: UIColor = UIColor(named: "color.purple") ?? UIColor.purple
    
    // layers used in animation
    // prevent drawing new layers at every draw
    private let progressLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    private let backgroundMask = CAShapeLayer()
    
    private var progress: CGFloat = 0 {
        didSet {
            // calls draw
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc func onRotationChange(notification: Notification) {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = UIColor.systemPink.cgColor
        
        gradientLayer.frame = rect
        gradientLayer.colors = [barColor.cgColor, gradientColor.cgColor, barColor.cgColor]
        gradientLayer.endPoint = CGPoint(x: progress, y: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeRotationNotification()
    }
}

extension CustomProgressBar {
    private func setupView() {
        setupLayers()
        setupAnimation()
        handleRotation()
    }
    
    private func setupLayers() {
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = progressLayer
        gradientLayer.locations = []
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    }
    
    private func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        // start point -0.3 (before the progress bar)
        animation.fromValue = [-0.3, 0.15, 0]
        // end point 1.3 (after the progress bar)
        animation.toValue = [1, 1.15, 1.9]
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.duration = 1.15
        gradientLayer.add(animation, forKey: "animation")
    }
    
    private func handleRotation() {
        NotificationCenter.default.addObserver(self, selector: #selector(onRotationChange(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeRotationNotification() {
        NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
    }
}


extension CustomProgressBar: ProgressBarProtocol {
    func showProgressBar() {
        alpha = 1
        progress = 1
    }
    
    func hideProgressBar() {
        alpha = 0
        progress = 0
    }
    
    func setProgressBarColors(barColor: UIColor, gradientColor: UIColor) {
        self.barColor = barColor
        self.gradientColor = gradientColor
    }
}
