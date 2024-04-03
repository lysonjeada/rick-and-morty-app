import Foundation
import CoreData

protocol CharacterInteractorProtocol {
    func fetch()
    func returnNumberOfCount() -> Int
    func unlikeCharacter(characterID: Int)
    func saveFavorite(with context: NSManagedObjectContext)
    func deleteFavorites()
}

class CharacterInteractor: CharacterInteractorProtocol {
    
    private var presenter: CharacterPresenterProtocol?
    private var useCase: CharacterUseCaseProtocol?
    public var characterCellDataList: [CharacterCellData] = []
    let defaults = UserDefaults.standard
    private(set) var numberOfPosts: Int = 0
    var favoriteIds: [Int]? = []
    var persistentContainer: NSPersistentContainer?
    
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
    
    func saveFavorite(with context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("error-Saving data")
        }
    }
    
    func deleteFavorites() {
        // Get a reference to a NSPersistentStoreCoordinator
        guard let storeContainer = persistentContainer?.persistentStoreCoordinator else {
            // Handle error when persistent container or store coordinator is nil
            return
        }
        
        // Delete each existing persistent store
        for store in storeContainer.persistentStores {
            do {
                if let url = store.url {
                    try storeContainer.destroyPersistentStore(
                        at: url,
                        ofType: store.type,
                        options: nil
                    )
                }
            } catch {
                // Handle error occurred during store deletion
                print("Error deleting store: \(error)")
            }
        }
        
        // Re-create the persistent container
        persistentContainer = NSPersistentContainer(name: "rick-and-morty")
        
        // Calling loadPersistentStores will re-create the persistent stores
        persistentContainer?.loadPersistentStores { (store, error) in
            // Handle errors occurred during store loading
            if let error = error {
                print("Error loading store: \(error)")
            }
        }
    }
}
