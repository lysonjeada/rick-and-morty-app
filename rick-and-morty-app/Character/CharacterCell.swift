import UIKit

class CharacterCell {
    var id: Int
    var image: UIImage
    var imageString: String
    var name: String
    
    public init(id: Int, image: UIImage, name: String, imageString: String) {
        self.id = id
        self.image = image
        self.name = name
        self.imageString = imageString
    }
}
