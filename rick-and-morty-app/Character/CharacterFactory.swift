import Foundation

enum CharacterFactory {
    case instance
    
    func build() -> CharacterViewController {
        let view = CharacterViewController()
        let presenter = CharacterPresenter(view: view)
        let useCase = CharacterUseCaseFactory.instance.build()
        let interactor = CharacterInteractor(presenter: presenter, useCase: useCase)
        
        view.interactor = interactor
        
        return view
    }
}
