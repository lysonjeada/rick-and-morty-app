import UIKit

protocol CharacterViewProtocol {
    func buildCells(characterCellData: [CharacterCellData])
    func unlikeCharacter(characterID: Int)
}

class CharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CharacterViewProtocol {
    
    var characterCell: [CharacterCell]? = []
    let cellReuseIdentifier = "ImageCell"
    var favoriteIds: [Int]? = []
    
    var interactor: CharacterInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fetch()
        
        configViews()
    }
    
    lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = false
        collectionView.layer.cornerRadius = 8
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? CustomCollectionViewCell else {
            return CustomCollectionViewCell(delegate: self)
        }
        
        if let characterCell = characterCell {
            cell.build(id: characterCell[indexPath.item].id, image: characterCell[indexPath.item].image, name: characterCell[indexPath.item].name)
        }
        
        cell.likeButton.tag = indexPath.item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characterCell?.count ?? 1
    }
    
    func unlikeCharacter(characterID: Int) {
        interactor?.unlikeCharacter(characterID: characterID)
    }
    
    func buildCells(characterCellData: [CharacterCellData]) {
        characterCellData.forEach { character in
            ImageDownloader.downloadImage(character.image) { _image, urlString in
                let cell = CharacterCell(id: character.id, image: _image ?? UIImage(), name: character.name)
                self.characterCell?.append(cell)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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

