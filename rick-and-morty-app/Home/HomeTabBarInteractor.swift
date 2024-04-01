import Foundation

protocol HomeTabBarInteractorProtocol {
    func fetch(completion: @escaping () -> Void)
}

struct CharacterCellData {
    let name: String
    let image: String
}

class HomeTabBarInteractor: HomeTabBarInteractorProtocol {
    
    var presenter: HomeTabBarPresenterProtocol?
    public var characterCellDataList: [CharacterCellData] = []
    let defaults = UserDefaults.standard
    
    init(presenter: HomeTabBarPresenterProtocol?) {
        self.presenter = presenter
    }
    
    func fetch(completion: @escaping () -> Void) {
        let apiManager = CharacterUseCase()
        
        apiManager.fetchData { [weak self] result in
            switch result {
            case .success(let success):
                success.forEach { character in
                    let characterCellData = CharacterCellData(name: character.name, image: character.image)
                    self?.characterCellDataList.append(characterCellData)
                }
                self?.presenter?.showValues(characterCellData: self?.characterCellDataList ?? [])
                completion()
            case .failure(_):
                self?.presenter?.showError()
            }
        }
    }
    
    func returnNumberOfCount() -> Int {
        let savedCount = defaults.object(forKey: "CharacteresCount") as? Int ?? 1
        return savedCount
    }
}

