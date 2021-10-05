import UIKit
import Firebase
import FirebaseDatabase
import SideMenu

class MainBoardViewController: UIViewController {
    
    @IBOutlet var teaTypesCollectionView: UICollectionView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    private var dataSource : BoardDataSource?
    private let estimatedWidth = 160.0
    private let cellMarginSize = 16.0
    private let showTeasSegue = "ShowTeasSegue"
    private let showTeasByTypeSegue = "ShowTeasByTypeSegue"
    let cartController: CartViewController = CartViewController()
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showTeasByTypeSegue,
           let destination = segue.destination as? TeaViewController,
           let cell = sender as? UICollectionViewCell,
           let indexPath = teaTypesCollectionView.indexPath(for: cell) {
            if let teaType = dataSource?.teaType(at: indexPath.row){
                destination.configure(teaType: teaType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = BoardDataSource()
        DispatchQueue.global(qos: .background).async {
            self.dataSource?.configure {
                DispatchQueue.main.async {
                    self.teaTypesCollectionView.reloadData()
                    self.hideProgressBar()
                }
            }
        }
        
        teaTypesCollectionView.delegate = self
        teaTypesCollectionView.dataSource = dataSource
        
        setupGridView()
        setupNavigationBar()
        showProgressBar()
    }
    
    func setupGridView() {
        let flow = teaTypesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(cellMarginSize)
        flow.minimumLineSpacing =  CGFloat(cellMarginSize)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Tea Board"
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
}

extension MainBoardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimatedWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        return width
    }
}
