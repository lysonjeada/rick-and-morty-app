import Foundation

enum FavoritesCharacterFactory {
    case instance
    
    func build() -> FavoritesCharacterViewController {
        let view = FavoritesCharacterViewController()
        let presenter = FavoritesCharacterPresenter(view: view)
        let useCase = CharacterUseCaseFactory.instance.build()
        let interactor = FavoritesCharacterInteractor(presenter: presenter, useCase: useCase)
        
        view.interactor = interactor
        
        return view
    }
}
