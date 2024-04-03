import UIKit

class FavoritesCharacterViewCell: UICollectionViewCell {
    
    let cellReuseIdentifier = "FavoritesCharacterCell"
    var data: Data?
    var delegate: FavoritesCharacterViewProtocol?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    lazy var productImage: UIImageView = {
        let image = UIImageView(frame: contentView.bounds)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(image: String, name: String) {
        ImageDownloader.downloadImage(image) { _image, urlString in
            DispatchQueue.main.async {
                self.nameLabel.text = name
                self.productImage.image = _image
                self.delegate?.reloadData()
            }
        }
        
    }

    func configViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(productImage)
        
        contentView.bringSubviewToFront(nameLabel)
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: -14),
            nameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

