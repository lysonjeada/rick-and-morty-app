import XCTest

@testable import rick_and_morty_app

class CharacterPresenterFake: CharacterPresenterProtocol {
    var showValuesCalled: Bool = false
    var showErrorCalled: Bool = false
    
    func showValues(characterCellData: [CharacterCellData]) {
        showValuesCalled = true
    }
    
    func showError() {
        showErrorCalled = true
    }
}

class CharacterUseCaseSpy: CharacterUseCaseProtocol {
    var isSuccess: Bool = true
    var fetchAllResultToBeReturned: Result<[Character], DataError> = .success([])
    
    enum Methods {
        case requestSuccess
        case requestFailure
    }
    
    var methodsCalled: [Methods]?
    
    func fetchData(completion: @escaping (Result<[Character], DataError>) -> Void) {
        completion(fetchAllResultToBeReturned)
        if isSuccess {
            methodsCalled?.append(.requestSuccess)
        } else {
            methodsCalled?.append(.requestFailure)
        }
    }
}

class CharacteUseCaseTests: XCTestCase {
    let useCase = CharacterUseCaseSpy()
    
    func testFetchSuccess() {
        // Given
        let presenterSpy = CharacterPresenterFake()
        let useCaseSpy = CharacterUseCaseSpy()
        let stubbedCharacters: [Character] = [
            .init(id: 1, name: "Rick", status: "", species: "", type: nil, gender: "", origin: Location(name: "BR", url: ".com.br"), location: Location(name: "BR", url: ".com.br"), image: "", episode: [""], url: "", created: ""),
            .init(id: 2, name: "Morty", status: "", species: "", type: nil, gender: "", origin: Location(name: "BR", url: ".com.br"), location: Location(name: "BR", url: ".com.br"), image: "", episode: [""], url: "", created: "")
        ]
        useCaseSpy.fetchAllResultToBeReturned = .success(stubbedCharacters)
        let interactor = CharacterInteractor(presenter: presenterSpy, useCase: useCaseSpy)
        
        // When
        interactor.fetch()
        
        // Then
        XCTAssertTrue(presenterSpy.showValuesCalled)
        XCTAssertFalse(presenterSpy.showErrorCalled)
        XCTAssertEqual(interactor.numberOfPosts, 2) // Assuming there are 2 characters in stubbedCharacters
    }
    
    func testFetchFailure() {
            // Given
            let presenterSpy = CharacterPresenterFake()
            let useCaseSpy = CharacterUseCaseSpy()
            useCaseSpy.fetchAllResultToBeReturned = .failure(.message(nil))
            let interactor = CharacterInteractor(presenter: presenterSpy, useCase: useCaseSpy)

            // When
            interactor.fetch()

            // Then
            XCTAssertTrue(presenterSpy.showErrorCalled)
            XCTAssertFalse(presenterSpy.showValuesCalled)
            XCTAssertEqual(interactor.numberOfPosts, 0) // Expecting numberOfPosts to be 0 due to failure
        }
}
