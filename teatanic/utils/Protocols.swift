import UIKit

protocol CartDelegate {
    func cartAction(success: Bool)
}

protocol CartDeleteDelegate {
    func deleteAll()
}

protocol SideMenuControllerDelegate {
    func selectedCell(at row: Int)
}

// adapted implementation of a custom progress bar from https://betterprogramming.pub/build-a-simple-progress-bar-you-can-add-anywhere-in-your-app-27330ef6dba7
protocol ProgressBarProtocol {
    func showProgressBar()
    func hideProgressBar()
    func setProgressBarColors(barColor: UIColor, gradientColor: UIColor)
}
