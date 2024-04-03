import UIKit
import CoreData

protocol FavoritesCharacterViewProtocol {
    func buildCells(characterCellData: [CharacterCellData])
    func reloadData()
}

class FavoritesCharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FavoritesCharacterViewProtocol {
    
    var interactor: FavoritesCharacterInteractorProtocol?
    var characterCell: [CharacterCell]? = []
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
        configViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return interactor?.returnFavoritesCount(context: context) ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCharacterCell", for: indexPath) as? FavoritesCharacterViewCell else {
            return FavoritesCharacterViewCell()
        }
        
        cell.delegate = self
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        interactor?.returnFavorites(with: context).forEach({ character in
            cell.build(image: character.image, name: character.name)
        })
        
//        if let characterCell = characterCell, characterCell.count > indexPath.item {
//            cell.build(image: characterCell[indexPath.row].image, name: characterCell[indexPath.row].name)
//        } else {
//            print("vai abrir nao")
//        }
        
        return cell
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func buildCells(characterCellData: [CharacterCellData]) {
        characterCellData.forEach { character in
            ImageDownloader.downloadImage(character.image) { _image, urlString in
                let cell = CharacterCell(id: character.id, image: _image ?? UIImage(), name: character.name, imageString:  character.image)
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
