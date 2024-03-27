import UIKit

protocol CharacterViewProtocol {
    func buildCells(characterCellData: [CharacterCell])
}

struct CharacterCell {
    var image: UIImage
    var name: String
}

class CharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CharacterViewProtocol {
    
    var characterCellData: [CharacterCell]?
    let cellReuseIdentifier = "ImageCell"
    
    var interactor: CharacterInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        
        interactor?.fetch(completion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
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
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = false
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? CustomCollectionViewCell else {
            return CustomCollectionViewCell()
        }
        
//        let currentCharacter = characterCellData[indexPath.item]
        if let characterCellData = characterCellData {
            cell.build(image: characterCellData[indexPath.item].image, name: characterCellData[indexPath.item].name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.returnNumberOfCount() ?? 1
    }
    
    func buildCells(characterCellData: [CharacterCell]) {
        self.characterCellData = characterCellData
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

