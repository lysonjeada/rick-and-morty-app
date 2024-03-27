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
        characterCellData.forEach { character in
            ImageDownloader.downloadImage(character.image) { _image, urlString in
                let cell = CharacterCell(image: _image ?? UIImage(), name: character.name)
                self.characterList.append(cell)
                self.view?.buildCells(characterCellData: self.characterList)
            }
        }
    }
    
    func showError() {
        print("erro")
    }
    
}
