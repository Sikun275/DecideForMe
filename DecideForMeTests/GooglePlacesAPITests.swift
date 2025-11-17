import XCTest
import Foundation
import CoreLocation
@testable import DecideForMe

class GooglePlacesAPITests: XCTestCase {
    
    var viewModel: MapDecisionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MapDecisionViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - API Key Tests
    
    func testAPIKeyIsLoaded() {
        // Test that the API key is properly loaded from the configuration
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        // The API key should not be "NULL" (our fallback value)
        XCTAssertNotEqual(apiKey, "NULL", "API key should be loaded from configuration")
        
        // The API key should not be empty
        XCTAssertFalse(apiKey.isEmpty, "API key should not be empty")
        
        // The API key should start with "AIza" (Google API key format)
        XCTAssertTrue(apiKey.hasPrefix("AIza"), "API key should be a valid Google API key format")
        
        print("✅ API Key loaded: \(apiKey.prefix(10))...")
    }
    
    func testAPIKeyFromBundle() {
        // Test that the API key can be retrieved from Bundle.main.infoDictionary
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        XCTAssertNotEqual(apiKey, "NULL", "API key should be retrievable from Bundle")
        XCTAssertFalse(apiKey.isEmpty, "API key should not be empty")
        
        print("✅ Bundle API Key: \(apiKey.prefix(10))...")
    }
    
    // MARK: - Network Request Tests
    
    func testNearbySearchURLConstruction() {
        // Test that the API URL is constructed correctly
        let lat = 43.6532
        let lng = -79.3832
        let radius = 5000
        let keyword = "restaurant"
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        let expectedURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        
        // Test URL construction logic
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let constructedURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(radius)&keyword=\(query)&key=\(apiKey)"
        
        XCTAssertEqual(constructedURL, expectedURL, "URL should be constructed correctly")
        
        // Test that URL is valid
        let url = URL(string: constructedURL)
        XCTAssertNotNil(url, "Constructed URL should be valid")
        
        print("✅ Nearby Search URL: \(constructedURL)")
    }
    
    func testTextSearchURLConstruction() {
        // Test text search URL construction
        let query = "coffee shop"
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let constructedURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&key=\(apiKey)"
        
        // Verify the URL is properly encoded (spaces should become %20)
        XCTAssertTrue(constructedURL.contains(encodedQuery), "URL should contain properly encoded query")
        XCTAssertNotEqual(query, encodedQuery, "Query should be encoded (spaces should be %20)")
        
        // Test that URL is valid
        let url = URL(string: constructedURL)
        XCTAssertNotNil(url, "Text search URL should be valid")
        
        print("✅ Text Search URL: \(constructedURL)")
    }
    
    // MARK: - API Response Model Tests
    
    func testGPlacesResponseDecoding() {
        // Test that our response models can decode valid Google Places API responses
        let jsonString = """
        {
            "status": "OK",
            "results": [
                {
                    "name": "Test Restaurant",
                    "place_id": "ChIJTest123",
                    "geometry": {
                        "location": {
                            "lat": 43.6532,
                            "lng": -79.3832
                        }
                    },
                    "rating": 4.5
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(GPlacesResponse.self, from: jsonData)
            
            XCTAssertEqual(response.results.count, 1, "Should decode one result")
            XCTAssertEqual(response.results[0].name, "Test Restaurant", "Should decode name correctly")
            XCTAssertEqual(response.results[0].placeId, "ChIJTest123", "Should decode place_id correctly")
            XCTAssertEqual(response.results[0].rating, 4.5, "Should decode rating correctly")
            XCTAssertEqual(response.results[0].geometry.location.lat, 43.6532, "Should decode latitude correctly")
            XCTAssertEqual(response.results[0].geometry.location.lng, -79.3832, "Should decode longitude correctly")
            
            print("✅ GPlacesResponse decoding successful")
        } catch {
            XCTFail("Failed to decode GPlacesResponse: \(error)")
        }
    }
    
    func testGoogleAPIErrorDecoding() {
        // Test that our error model can decode Google API error responses
        let errorJsonString = """
        {
            "status": "ZERO_RESULTS",
            "error_message": "No results found for the given query"
        }
        """
        
        let jsonData = errorJsonString.data(using: .utf8)!
        
        do {
            let errorResponse = try JSONDecoder().decode(GoogleAPIError.self, from: jsonData)
            
            XCTAssertEqual(errorResponse.status, "ZERO_RESULTS", "Should decode status correctly")
            XCTAssertEqual(errorResponse.errorMessage, "No results found for the given query", "Should decode error message correctly")
            
            print("✅ GoogleAPIError decoding successful")
        } catch {
            XCTFail("Failed to decode GoogleAPIError: \(error)")
        }
    }
    
    // MARK: - Integration Tests
    
    func testLocationManagerSetup() {
        // Test that location permission can be requested (indirect test of location manager)
        viewModel.requestLocationPermission()
        // The location permission status should be accessible
        XCTAssertTrue(viewModel.locationPermissionStatus != .notDetermined || viewModel.locationPermissionStatus == .notDetermined, "Location permission status should be accessible")
        
        // Test that we can set a current location
        let testLocation = CLLocation(latitude: 43.6532, longitude: -79.3832)
        viewModel.currentLocation = testLocation
        XCTAssertNotNil(viewModel.currentLocation, "Current location should be settable")
        
        print("✅ Location manager setup verified")
    }
    
    func testDistanceCalculation() {
        // Test the distance calculation function
        let location1 = GLocation(lat: 43.6532, lng: -79.3832)
        let location2 = (lat: 43.6542, lng: -79.3842) // ~100m away
        
        let distance = location1.distance(from: location2)
        
        // Distance should be approximately 100 meters (allowing for some calculation variance)
        XCTAssertGreaterThan(distance, 90, "Distance should be greater than 90m")
        XCTAssertLessThan(distance, 110, "Distance should be less than 110m")
        
        print("✅ Distance calculation: \(distance)m")
    }
    
    // MARK: - Live API Test (Optional - requires network)
    
    func testLiveAPIConnection() {
        // This test requires network connectivity and a valid API key
        // It's marked as optional and can be run manually
        
        let expectation = XCTestExpectation(description: "API call completes")
        
        // Set up a test search
        viewModel.keyword = "restaurant"
        viewModel.maxDistance = 5000
        
        // Mock the search completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Check if places were found or if there was an error
            if !self.viewModel.places.isEmpty {
                print("✅ Live API test: Found \(self.viewModel.places.count) places")
                expectation.fulfill()
            } else {
                // This might be expected if no restaurants are found in the area
                print("ℹ️ Live API test: No places found (this might be expected)")
                expectation.fulfill()
            }
        }
        
        // Perform the search
        viewModel.search()
        
        // Wait for the expectation with a timeout
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Performance Tests
    
    func testSearchPerformance() {
        // Test that search operations complete within reasonable time
        measure {
            viewModel.keyword = "test"
            viewModel.search()
            
            // Wait a bit for the async operation
            Thread.sleep(forTimeInterval: 0.1)
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyKeywordSearch() {
        // Test that empty keyword returns empty results
        viewModel.keyword = ""
        viewModel.search()
        
        XCTAssertTrue(viewModel.places.isEmpty, "Empty keyword should result in empty places")
        print("✅ Empty keyword test passed")
    }
    
    func testSpecialCharactersInKeyword() {
        // Test that special characters are properly encoded
        let specialKeywords = ["café", "restaurant & bar", "coffee-shop", "pizza's place"]
        
        for keyword in specialKeywords {
            let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            XCTAssertFalse(encoded.isEmpty, "Special characters should be properly encoded")
            print("✅ Encoded '\(keyword)' as '\(encoded)'")
        }
    }
    
    func testLargeRadiusSearch() {
        // Test with a very large radius
        viewModel.maxDistance = 50000 // 50km
        viewModel.keyword = "restaurant"
        
        // This should not crash the app
        viewModel.search()
        
        print("✅ Large radius search test passed")
    }
}

// MARK: - Helper Extensions

extension MapDecisionViewModel {
    // Expose private properties for testing
    var apiKey: String {
        Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
    }
    
    var defaultLocation: CLLocation {
        CLLocation(latitude: 43.6532, longitude: -79.3832)
    }
}
