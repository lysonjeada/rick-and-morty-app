import UIKit

protocol CharacterViewProtocol {
    func buildCells(characterCellData: [CharacterCellData])
}

struct CharacterCell {
    var image: UIImage
    var name: String
}

class CharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CharacterViewProtocol {
    
    var characterCell: [CharacterCell]? = []
    let cellReuseIdentifier = "ImageCell"
    
    var interactor: CharacterInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        
        interactor?.fetch()
        
        configViews()
        
        // Do any additional setup after loading the view.
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
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? CustomCollectionViewCell else {
            return CustomCollectionViewCell()
        }
        
//        let currentCharacter = characterCellData[indexPath.item]
        if let characterCell = characterCell {
            cell.build(image: characterCell[indexPath.item].image, name: characterCell[indexPath.item].name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characterCell?.count ?? 1
    }
    
    func buildCells(characterCellData: [CharacterCellData]) {
        characterCellData.forEach { character in
            ImageDownloader.downloadImage(character.image) { _image, urlString in
                let cell = CharacterCell(image: _image ?? UIImage(), name: character.name)
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

