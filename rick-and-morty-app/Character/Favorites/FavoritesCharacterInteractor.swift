import Foundation

protocol FavoritesCharacterInteractorProtocol {
    func fetch()
    func returnFavoriteIds() -> [Int]
}

class FavoritesCharacterInteractor: FavoritesCharacterInteractorProtocol {
    
    private var presenter: FavoritesCharacterPresenterProtocol?
    private var useCase: CharacterUseCaseProtocol?
    public var characterCellDataList: [CharacterCellData] = []
    let defaults = UserDefaults.standard
    private(set) var numberOfPosts: Int = 0
    
    init(presenter: FavoritesCharacterPresenterProtocol, useCase: CharacterUseCaseProtocol) {
        self.presenter = presenter
        self.useCase = useCase
    }
    
    func fetch() {
        useCase?.fetchData { [weak self] result in
            switch result {
            case .success(let success):
                success.forEach { character in
                    if self?.returnFavoriteIds().contains(character.id) == true {
                        let characterCellData = CharacterCellData(id: character.id, name: character.name, image: character.image)
                        self?.characterCellDataList.append(characterCellData)
                    }
                }
                self?.numberOfPosts = success.count
                self?.presenter?.showValues(characterCellData: self?.characterCellDataList ?? [])
            case .failure(_):
                self?.presenter?.showError()
            }
        }
    }
    
    func returnFavoriteIds() -> [Int] {
        let savedCount = defaults.object(forKey: "FavoriteLikeButtonId") as? [Int] ?? []
        return savedCount
    }
}

