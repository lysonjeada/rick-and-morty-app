import Foundation

enum CharacterUseCaseFactory {
    case instance
    
    func build() -> CharacterUseCaseProtocol {
        return CharacterUseCase()
    }
}
