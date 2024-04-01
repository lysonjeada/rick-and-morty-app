import UIKit

class CharacterCell: NSObject, NSCoding {
    var image: UIImage
    var name: String
    
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let image = aDecoder.decodeObject(forKey: "image") as? UIImage,
              let name = aDecoder.decodeObject(forKey: "name") as? String else {
            return nil
        }
        self.init(image: image, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(name, forKey: "name")
    }
}
