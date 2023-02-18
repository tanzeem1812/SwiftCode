//
//  CatsShowTests.swift
//  CatsShowTests
//
//  Created by Tanzeem Ahamad
//

import XCTest
@testable import CatsShow

class MockImageAPIService: APIServiceProtocol {
    var fetchResult: DataResult?
    
    func fetchRequest(urlStr: String?, completion: @escaping (DataResult) -> Void) {
        if let result = fetchResult {
            completion(result)
        }
    }
}

class MockDataAPIService: APIServiceProtocol {
    var fetchResult: DataResult?
    
    func fetchRequest(urlStr: String?, completion: @escaping (DataResult) -> Void) {
        if let result = fetchResult {
            completion(result)
        }
    }
}

class MockCatShowViewModelFactDataOutput:CatsShowViewModelFactDataOutput{
    var data:CatDataModel?
    var error:ErrorCodes?

    func handleError(error: ErrorCodes) {
        self.error = error
        print(error)
    }
    
    func updateFactView(dataModel:CatDataModel) {
        data = dataModel
    }
}

class MockCatShowViewModelImageOutput:CatsShowViewModelImageOutput{
    var data:UIImage?
    var error:ErrorCodes?

    func handleError(error: ErrorCodes) {
        self.error = error
        print(error)
    }
    
    func updateImageView(image: UIImage?) {
        data = image
    }
}

final class CatyShowTests: XCTestCase {
    
    private var sut: CatsShowViewModel!
    private var apiService: APIServiceProtocol!
 
    private var mocksut: CatsShowViewModel!
    private var mockAPIService: APIServiceProtocol!
    private var mockOutput: MockCatShowViewModelImageOutput!
    
    private var mockDatasut: CatsShowViewModel!
    private var mockDataAPIService: APIServiceProtocol!
    private var mockDataOutput: MockCatShowViewModelFactDataOutput!
   
    override class func setUp() {
        super.setUp()
        // runs once before all the tests begin
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        apiService = APIService()
        sut = CatsShowViewModel(apiService:apiService )
        
        mockAPIService = MockImageAPIService()
        mocksut = CatsShowViewModel(apiService:mockAPIService)
        mockOutput = MockCatShowViewModelImageOutput()
        mocksut.catImageOutput =  mockOutput
   
        mockDataAPIService = MockDataAPIService()
        mockDatasut = CatsShowViewModel(apiService: mockDataAPIService)
        mockDataOutput = MockCatShowViewModelFactDataOutput()
        mockDatasut.catDataOutput =  mockDataOutput
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
 
        apiService = nil
        sut = nil
        
        mockAPIService = nil
        mocksut = nil
        mockOutput = nil
    
        mockDataAPIService = nil
        mockDatasut = nil
        mockDataOutput = nil
  
        try super.tearDownWithError()
    }
    
    func testCatImageURLUsingCache() { // Real retrieving of Image URL and caching it
        let expectation = self.expectation(description: "ImageURL")
        
        //Given Or Arrange
        let expectedURLStr = "\(Constants.catImagesBaseUrl_random)?image="
        var imageURL:URL?
        
        // when OR Act
        sut.fetchCatImageRequestUsingCache(completion: {result in
            switch result {
            case .success(let data):
                imageURL = data
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        })
        let resultedStr = String(describing: imageURL!)
        self.waitForExpectations(timeout: 4.0, handler: nil)
        
        //Then or Assert
        XCTAssertTrue(resultedStr.contains(expectedURLStr))
    }
    
    func testMockCatImageAPIService_onSuccess_() { // Mocking Cat Image API ..
        //Given OR Arrange
        let jpegImage = UIImage(named: "Cat.jpeg")
        let jpegData = jpegImage!.jpegData(compressionQuality: 0.8 )
        mockAPIService.fetchResult = .success(jpegData!)
        
        //When OR Act
        mocksut.fetchCatImageRequest()
        
        //Then OR Assert
        XCTAssertNotNil(mockOutput.data)
    }
    
    func testMockCatImageAPIService_onBadImageFailure() { // Not Real API ..just mocking
        //Given OR Arrange
        let error:ErrorCodes = .badImage
        mockAPIService.fetchResult = .failure(error)
        
        //When OR Act
        mocksut.fetchCatImageRequest()
        
        //Then OR Assert
        XCTAssertEqual(error,mockOutput.error )
    }
    
    func testCatImageAPIService() { // Real Cat Image API Call
        let expectation = self.expectation(description: "ImageData")
        
        //Given OR Arrance
        var image:UIImage?
        
        // when OR Act
        sut.fetchCatImageRequest(completion: {result in
            switch result {
            case .success(let data):
                image = data
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        })
        
        self.waitForExpectations(timeout: 4.0, handler: nil)
        
        //Then OR Assert
        XCTAssertNotNil(image)
    }
    
    func testCatFactDataAPIService() { // Real Fact Data API Call
        let expectation = self.expectation(description: "FactData")
        
        //Given OR Arrange
        var fact:String?
        
        // when OR Act
        sut.fetchCatDataRequest(completion: {result in
            switch result {
            case .success(let data):
                fact = data.facts[0]
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        })
        
        self.waitForExpectations(timeout: 4.0, handler: nil)
        
        //Then OR Assert
        XCTAssertNotNil(fact!)
    }

    // Write other test cases to handle other failures
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    override class func tearDown() {
        super.tearDown()
        // runs at the end of all tests in the class, and is used to clean up any side effect the class method setup() might have caused.
    }
}
