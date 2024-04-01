import Foundation
import UIKit

protocol FavoritesCharacterPresenterProtocol {
    func showValues(characterCellData: [CharacterCellData])
    func showError()
}

class FavoritesCharacterPresenter: FavoritesCharacterPresenterProtocol {
    
    private var view: FavoritesCharacterViewProtocol?
    
    init(view: FavoritesCharacterViewProtocol) {
        self.view = view
    }
    
    func showValues(characterCellData: [CharacterCellData]) {
        view?.buildCells(characterCellData: characterCellData)
    }
    
    func showError() {
        print("erro")
    }
    
}

