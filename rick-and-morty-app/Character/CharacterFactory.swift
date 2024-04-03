import Foundation
import UIKit

enum CharacterFactory {
    case instance
    
    func build() -> CharacterViewController {
        let view = CharacterViewController()
        let presenter = CharacterPresenter(view: view)
        let useCase = CharacterUseCaseFactory.instance.build()
        let interactor = CharacterInteractor(presenter: presenter, useCase: useCase)
        
        var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        interactor.persistentContainer = context
        view.interactor = interactor
        
        return view
    }
}
