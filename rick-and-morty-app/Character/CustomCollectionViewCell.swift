import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let cellReuseIdentifier = "ImageCell"
    var data: Data?
    var characterCell: [CharacterCell]? = []
    
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
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(image: UIImage, name: String) {
        productImage.image = image
        nameLabel.text = name
    }
    
    @objc func likeButtonTapped() {
        isSelected.toggle()
        
        let characterCellObject = CharacterCell(image: productImage.image ?? UIImage(), name: nameLabel.text ?? "")
        characterCell?.append(characterCellObject)
        if isSelected {
            let cellEncodedData = try? NSKeyedArchiver.archivedData(withRootObject: characterCell ?? [], requiringSecureCoding: false)
            UserDefaults.standard.set(cellEncodedData, forKey: "FavoriteLikeButtonTapped")
        }
        
        updateImage()
    }
    
    private func updateImage() {
        let imageName = isSelected ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func showSkeleton() {
        // Enable skeleton view for the image
        //        productImage.isSkeletonable = true
        //        productImage.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        // Hide skeleton view for the image
        //        productImage.hideSkeleton()
    }
    
    func configViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(productImage)
        
        contentView.bringSubviewToFront(nameLabel)
        contentView.bringSubviewToFront(likeButton)
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: -14),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            likeButton.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: -14),
            likeButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

