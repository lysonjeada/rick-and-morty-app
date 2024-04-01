import UIKit

class FavoritesCharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellReuseIdentifier = "FavoritesCharacterCell"
    
    lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesCharacterViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = false
        collectionView.layer.cornerRadius = 8
        return collectionView
    }()
    
    override func viewDidLoad() {
        UserDefaults.standard.synchronize()
        
        collectionView.reloadData()
        
        configViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        returnFavorites()?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCharacterCell", for: indexPath) as? FavoritesCharacterViewCell else {
            return FavoritesCharacterViewCell()
        }

        // Retrieve
        if let savedData = UserDefaults.standard.data(forKey: "FavoriteLikeButtonTapped"),
           let decodedCharacterCellObjects = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [CharacterCell] {
            cell.build(image: decodedCharacterCellObjects[indexPath.item].image, name: decodedCharacterCellObjects[indexPath.item].name)
            // Use decodedCharacterCellObjects
        } else {
            // Handle if no data found or unable to deserialize
        }
        
        return cell
    }
    
    func returnFavorites() -> [CharacterCell]? {
        return UserDefaults.standard.object(forKey: "FavoriteLikeButtonTapped") as? [CharacterCell]
    }
    
    func configViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
