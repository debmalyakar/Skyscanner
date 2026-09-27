//
//  NetworkingTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 26/09/26.
//

import XCTest
@testable import Skyscanner

struct DummyDecodable: Decodable, Equatable {
    let id: Int
    let name: String
}


final class NetworkingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_invalid_URL() async {
        let sut = NetworkingTests.getDummyApiClient()
        var components = URLComponents()
           components.scheme = "https"
           components.host = "api.open-meteo.com"
           components.path = "v1/forecast"
 
        do{
            _ = try await sut.getResponse(from: components)
            XCTFail("expected invalidURL but got a result successfully")
        }
        catch let error as NetworkError{
            XCTAssert(error == .invalidURL, "invalid URL fired correctly as URL is blank")
        }
        catch  {
            XCTFail("expected invalidURL but got a different error \(error) ")
        }
    }
    
    func test_Url_Components_with_query_items() async throws {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            .init(name: "name", value: "query"),
            .init(name: "count", value: "1"),
            .init(name: "language", value: "en"),
            .init(name: "format", value: "json")]
            
            let sut = MockUrlSession.success(data: Data())
        let apiClient = NetworkingTests.getDummyApiClient(from: sut)
        
           _ = try? await apiClient.getResponse(from: components)
           XCTAssert(sut.urls[0].absoluteString == "https://geocoding-api.open-meteo.com/v1/search?name=query&count=1&language=en&format=json", "Correct url")
    }
    
    func test_Url_should_be_called_once() async throws {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            .init(name: "name", value: "query"),
            .init(name: "count", value: "1"),
            .init(name: "language", value: "en"),
            .init(name: "format", value: "json")]
            
            let sut = MockUrlSession.success(data: Data())
        let apiClient = NetworkingTests.getDummyApiClient(from: sut)
        
           _ = try? await apiClient.getResponse(from: components)
        XCTAssert(sut.urls.count == 1, "Should be called once")
    }
    
    func test_invalidJSON_response() async throws {
        let invalidResponse = """
            {
            id1 : "1",
            name : "Any Name"
            }
            """
        let sut = MockUrlSession.success(data: invalidResponse.data(using: .utf8)!)
        let apiClient = NetworkingTests.getDummyApiClient(from: sut)
        let urlComponent = URLComponents(string: "any url")
        do{
            _ = try await apiClient.getResponse(from: urlComponent!)
            XCTFail("this should fail with the wrong json format")
        }catch let error as NetworkError {
            XCTAssert(error == .parseError , "the json format is wrong")
        }catch {
            XCTFail("this should fail with the wrong json format")
        }
        
    }
    
    func test_Correct_response() async throws {
        let correctResponse = """
            {
            "id" : 1,
            "name" : "Any Name"
            }
            """
        
         let sut = MockUrlSession.success(data: correctResponse.data(using: .utf8)!)
        let apiClient = NetworkingTests.getDummyApiClient(from: sut)
        let urlComponent = URLComponents(string: "any url")
        
        let result: DummyDecodable = try await apiClient.getResponse(from: urlComponent!)
        XCTAssert(result.id == 1, "the json format is correct")
        XCTAssert(result.name == "Any Name", "the json format is correct")
    }
    
    func test_500_response() async throws {
        let sut = MockUrlSession.success(statusCode: 500 , data: Data())
        let apiClient = NetworkingTests.getDummyApiClient(from: sut)
        let urlComponent = URLComponents(string: "any url")
        do{
            _ = try await apiClient.getResponse(from: urlComponent!)
            XCTFail("badresponse is expected")
        }catch let error as NetworkError {
            XCTAssert(error == .badResponse, "500 bad response")
        }catch {
            XCTFail("badresponse is expected")
        }
    }

}

extension NetworkingTests {
    static func getDummyApiClient(response : (Data, URLResponse)? = nil , error : Error? = nil) -> DummyApiClient {
        let mockUrlSession =  MockUrlSession(response : response , error : error)
        return DummyApiClient(urlSession: mockUrlSession)
    }
    
    static func getDummyApiClient(from mockUrlSession : URLSessionProtocol) -> DummyApiClient {
        return DummyApiClient(urlSession: mockUrlSession)
    }
}
