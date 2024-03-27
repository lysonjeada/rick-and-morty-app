import Foundation
import UIKit

protocol CharacterPresenterProtocol {
    func showValues(characterCellData: [CharacterCellData])
    func showError()
}

class CharacterPresenter: CharacterPresenterProtocol {
    
    private var view: CharacterViewProtocol?
    var characterList: [CharacterCell] = []
    
    init(view: CharacterViewProtocol) {
        self.view = view
    }
    
    func showValues(characterCellData: [CharacterCellData]) {
        view?.buildCells(characterCellData: characterCellData)
    }
    
    func showError() {
        print("erro")
    }
    
}
