import UIKit

class CharacterCell {
    var id: Int
    var image: UIImage
    var name: String
    
    public init(id: Int, image: UIImage, name: String) {
        self.id = id
        self.image = image
        self.name = name
    }
}
