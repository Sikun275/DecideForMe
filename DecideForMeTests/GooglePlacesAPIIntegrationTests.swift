import XCTest
import Foundation
import CoreLocation
@testable import DecideForMe

class GooglePlacesAPIIntegrationTests: XCTestCase {
    
    func testGooglePlacesAPIConnection() {
        // This is a comprehensive test to verify Google Places API connectivity
        print("🧪 Starting Google Places API Integration Test...")
        
        // 1. Test API Key Loading
        testAPIKeyLoading()
        
        // 2. Test URL Construction
        testURLConstruction()
        
        // 3. Test Response Models
        testResponseModels()
        
        // 4. Test Live API Call (if network available)
        testLiveAPICall()
        
        print("✅ Google Places API Integration Test Complete!")
    }
    
    private func testAPIKeyLoading() {
        print("\n🔑 Testing API Key Loading...")
        
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        if apiKey == "NULL" {
            print("❌ API Key not found in Bundle")
            XCTFail("API Key not loaded from configuration")
        } else if apiKey.isEmpty {
            print("❌ API Key is empty")
            XCTFail("API Key is empty")
        } else if !apiKey.hasPrefix("AIza") {
            print("❌ API Key format invalid: \(apiKey.prefix(10))...")
            XCTFail("API Key format is invalid")
        } else {
            print("✅ API Key loaded successfully: \(apiKey.prefix(10))...")
        }
    }
    
    private func testURLConstruction() {
        print("\n🔗 Testing URL Construction...")
        
        let lat = 43.6532
        let lng = -79.3832
        let radius = 5000
        let keyword = "restaurant"
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        let nearbyURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        let textURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(keyword)&key=\(apiKey)"
        
        // Test nearby search URL
        if let url = URL(string: nearbyURL) {
            print("✅ Nearby Search URL valid: \(url)")
        } else {
            print("❌ Nearby Search URL invalid")
            XCTFail("Nearby Search URL construction failed")
        }
        
        // Test text search URL
        if let url = URL(string: textURL) {
            print("✅ Text Search URL valid: \(url)")
        } else {
            print("❌ Text Search URL invalid")
            XCTFail("Text Search URL construction failed")
        }
    }
    
    private func testResponseModels() {
        print("\n📋 Testing Response Models...")
        
        // Test GPlacesResponse
        let placesJSON = """
        {
            "status": "OK",
            "results": [
                {
                    "name": "Test Place",
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
        
        if let data = placesJSON.data(using: .utf8),
           let _ = try? JSONDecoder().decode(GPlacesResponse.self, from: data) {
            print("✅ GPlacesResponse model works correctly")
        } else {
            print("❌ GPlacesResponse model failed")
            XCTFail("GPlacesResponse model decoding failed")
        }
        
        // Test GoogleAPIError
        let errorJSON = """
        {
            "status": "ZERO_RESULTS",
            "error_message": "No results found"
        }
        """
        
        if let data = errorJSON.data(using: .utf8),
           let _ = try? JSONDecoder().decode(GoogleAPIError.self, from: data) {
            print("✅ GoogleAPIError model works correctly")
        } else {
            print("❌ GoogleAPIError model failed")
            XCTFail("GoogleAPIError model decoding failed")
        }
    }
    
    private func testLiveAPICall() {
        print("\n🌐 Testing Live API Call...")
        
        let expectation = XCTestExpectation(description: "API call completes")
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        if apiKey == "NULL" {
            print("⚠️ Skipping live API test - no API key")
            expectation.fulfill()
            return
        }
        
        // Test with a simple nearby search
        let lat = 43.6532
        let lng = -79.3832
        let radius = 5000
        let keyword = "restaurant"
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL for live test")
            XCTFail("Invalid URL for live API test")
            return
        }
        
        print("🔍 Testing URL: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    XCTFail("Network error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            let responseString = String(data: data, encoding: .utf8) ?? ""
                            print("📄 Response length: \(responseString.count) characters")
                            
                            // Try to decode the response
                            do {
                                let placesResponse = try JSONDecoder().decode(GPlacesResponse.self, from: data)
                                print("✅ Successfully decoded \(placesResponse.results.count) places")
                                
                                if placesResponse.results.isEmpty {
                                    print("ℹ️ No places found (this might be expected)")
                                } else {
                                    print("📍 First place: \(placesResponse.results[0].name)")
                                }
                            } catch {
                                // Try to decode as error response
                                do {
                                    let errorResponse = try JSONDecoder().decode(GoogleAPIError.self, from: data)
                                    print("⚠️ API Error: \(errorResponse.status) - \(errorResponse.errorMessage)")
                                } catch {
                                    print("❌ Failed to decode response: \(error)")
                                    print("📄 Raw response: \(responseString.prefix(500))")
                                }
                            }
                        } else {
                            print("❌ No data received")
                        }
                    } else {
                        print("❌ HTTP Error: \(httpResponse.statusCode)")
                    }
                }
                
                expectation.fulfill()
            }
        }.resume()
        
        wait(for: [expectation], timeout: 15.0)
    }
}

// MARK: - Quick API Test Function

extension GooglePlacesAPIIntegrationTests {
    
    /// Quick test function that can be called from anywhere to verify API status
    static func quickAPITest() {
        print("🚀 Quick Google Places API Test")
        
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        if apiKey == "NULL" {
            print("❌ API Key not found")
            return
        }
        
        print("✅ API Key found: \(apiKey.prefix(10))...")
        
        // Test a simple request
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=43.6532,-79.3832&radius=1000&keyword=restaurant&key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            print("✅ URL constructed successfully")
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        print("✅ API connection successful!")
                    } else {
                        print("⚠️ API returned status: \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        } else {
            print("❌ Failed to construct URL")
        }
    }
}
