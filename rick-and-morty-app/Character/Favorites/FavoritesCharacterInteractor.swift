import Foundation
import CoreData

protocol FavoritesCharacterInteractorProtocol {
    func returnFavorites(with context: NSManagedObjectContext) -> [FavoriteCharacter]
    func returnFavoritesCount(context: NSManagedObjectContext) -> Int
    var oldCount: Int? { get }
}

class FavoritesCharacterInteractor: FavoritesCharacterInteractorProtocol {
    
    private var presenter: FavoritesCharacterPresenterProtocol?
    private var useCase: CharacterUseCaseProtocol?
    public var characterCellDataList: [CharacterCellData] = []
    private var favoriteList: [FavoriteCharacter] = []
    private(set) var numberOfPosts: Int = 0
    public var oldCount: Int? = nil
    
    init(presenter: FavoritesCharacterPresenterProtocol, useCase: CharacterUseCaseProtocol) {
        self.presenter = presenter
        self.useCase = useCase
    }
    
    
    func returnFavoritesCount(context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Characteres")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (oldCount == result.count)
            {
                return oldCount ?? result.count
            }
            oldCount = result.count
            for data in result as! [NSManagedObject]
            {
                if isFavoriteAlreadyAdded(name: data.value(forKey: "name") as! String) {
                 continue
                }
                let favoriteCharacter = FavoriteCharacter(name: data.value(forKey: "name") as! String, image: data.value(forKey: "image") as! String)
                favoriteList.append(favoriteCharacter)
                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            print("Failed")
        }
        return favoriteList.count
    }
    
    func isFavoriteAlreadyAdded(name: String) -> Bool {
        // Check if the favorite with the given name already exists in the favoriteList
        return favoriteList.contains { $0.name == name }
    }
    
    func returnFavorites(with context: NSManagedObjectContext) -> [FavoriteCharacter] {
        return favoriteList
    }
    
    
}

