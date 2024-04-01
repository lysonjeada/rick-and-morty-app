import Foundation

protocol CharacterInteractorProtocol {
    func fetch()
    func returnNumberOfCount() -> Int
    func unlikeCharacter(characterID: Int)
}

class CharacterInteractor: CharacterInteractorProtocol {
    
    private var presenter: CharacterPresenterProtocol?
    private var useCase: CharacterUseCaseProtocol?
    public var characterCellDataList: [CharacterCellData] = []
    let defaults = UserDefaults.standard
    private(set) var numberOfPosts: Int = 0
    
    init(presenter: CharacterPresenterProtocol, useCase: CharacterUseCaseProtocol) {
        self.presenter = presenter
        self.useCase = useCase
    }
    
    func fetch() {
        useCase?.fetchData { [weak self] result in
            switch result {
            case .success(let success):
                success.forEach { character in
                    let characterCellData = CharacterCellData(id: character.id, name: character.name, image: character.image)
                    self?.characterCellDataList.append(characterCellData)
                }
                self?.numberOfPosts = success.count
                self?.presenter?.showValues(characterCellData: self?.characterCellDataList ?? [])
            case .failure(_):
                self?.presenter?.showError()
            }
        }
    }
    
    func returnNumberOfCount() -> Int {
        let savedCount = defaults.object(forKey: "CharacteresCount") as? Int ?? 1
        return savedCount
    }
    
    func unlikeCharacter(characterID: Int) {
        removeCharacterFromList(characterID: characterID)
        
        // Update the number of posts
        numberOfPosts = characterCellDataList.count
    }
    
    func removeCharacterFromList(characterID: Int) {
        if let index = characterCellDataList.firstIndex(where: { $0.id == characterID }) {
            characterCellDataList.remove(at: index)
            presenter?.showValues(characterCellData: characterCellDataList)
        }
    }
}
