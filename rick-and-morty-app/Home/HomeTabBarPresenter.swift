import Foundation
import UIKit

protocol HomeTabBarPresenterProtocol {
    func showValues(characterCellData: [CharacterCellData])
    func showError()
}

class HomeTabBarPresenter: HomeTabBarPresenterProtocol {
    
    private var view = HomeTabBarController()
    
    func showValues(characterCellData: [CharacterCellData]) {
        characterCellData.forEach { character in
            ImageDownloader.downloadImage(character.image) { _image, urlString in
                self.view.addSomeTabItems()
            }
        }
    }
    
    func showError() {
        print("erro")
    }
    
}

