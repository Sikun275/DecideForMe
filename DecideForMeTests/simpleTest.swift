//
//  simpleTest.swift
//  DecideForMe
//
//  Created by Sikun Chen on 2025-10-02.
//

import XCTest
import CoreLocation
@testable import DecideForMe

class simpletest: XCTestCase{
    
    func test1(){
        NSLog("this is just a simpleTest")
    }
    
    func testCurrentLocation() {
        NSLog("=== Testing Current Location ===")
        
        // Create a MapDecisionViewModel instance
        let viewModel = MapDecisionViewModel()
        
        NSLog("max distance is \(viewModel.maxDistance)")
        
        
        // Request location permission
        viewModel.requestLocationPermission()
        NSLog("After permission request - status: \(viewModel.locationPermissionStatus.rawValue)")
        
        // Set a test location to see the logging
        let testLocation = CLLocation(latitude: 40.7128, longitude: -74.0060) // New York
        viewModel.currentLocation = testLocation
        
        // Log the current location details
        if let location = viewModel.currentLocation {
            NSLog("Current location coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            NSLog("Current location timestamp: \(location.timestamp)")
        } else {
            NSLog("Current location is nil")
        }
        
        // Test with default location (Toronto)
        let defaultLocation = CLLocation(latitude: 43.6532, longitude: -79.3832)
        NSLog("Default location (Toronto): \(defaultLocation.coordinate.latitude), \(defaultLocation.coordinate.longitude)")
        
        NSLog("=== End Location Test ===")
        
        // Assert that we have a location (either current or default)
        XCTAssertNotNil(viewModel.currentLocation)
    }
    
    func testGooglePlacesAPIConnection() {
        NSLog("=== Testing Google Places API Connection ===")
        
        // Test API Key Loading
        let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
        
        if apiKey == "NULL" {
            NSLog("❌ API Key not found in Bundle")
            XCTFail("API Key not loaded from configuration")
        } else if apiKey.isEmpty {
            NSLog("❌ API Key is empty")
            XCTFail("API Key is empty")
        } else if !apiKey.hasPrefix("AIza") {
            NSLog("❌ API Key format invalid: \(apiKey.prefix(10))...")
            XCTFail("API Key format is invalid")
        } else {
            NSLog("✅ API Key loaded successfully: \(apiKey.prefix(10))...")
        }
        
        // Test URL Construction
        let lat = 43.6532
        let lng = -79.3832
        let radius = 5000
        let keyword = "restaurant"
        
        let nearbyURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        
        if let url = URL(string: nearbyURL) {
            NSLog("✅ Nearby Search URL valid: \(url)")
        } else {
            NSLog("❌ Nearby Search URL invalid")
            XCTFail("Nearby Search URL construction failed")
        }
        
        // Test Live API Call
        NSLog("🌐 Testing Live API Call...")
        
        let expectation = XCTestExpectation(description: "API call completes")
        
        URLSession.shared.dataTask(with: URL(string: nearbyURL)!) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("❌ Network error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    NSLog("📡 HTTP Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            let responseString = String(data: data, encoding: .utf8) ?? ""
                            NSLog("📄 Response length: \(responseString.count) characters")
                            
                            // Try to decode the response
                            do {
                                let placesResponse = try JSONDecoder().decode(GPlacesResponse.self, from: data)
                                NSLog("✅ Successfully decoded \(placesResponse.results.count) places")
                                
                                if placesResponse.results.isEmpty {
                                    NSLog("ℹ️ No places found (this might be expected)")
                                } else {
                                    NSLog("📍 First place: \(placesResponse.results[0].name)")
                                }
                            } catch {
                                // Try to decode as error response
                                do {
                                    let errorResponse = try JSONDecoder().decode(GoogleAPIError.self, from: data)
                                    NSLog("⚠️ API Error: \(errorResponse.status) - \(errorResponse.errorMessage)")
                                } catch {
                                    NSLog("❌ Failed to decode response: \(error)")
                                    NSLog("📄 Raw response: \(responseString.prefix(500))")
                                }
                            }
                        } else {
                            NSLog("❌ No data received")
                        }
                    } else {
                        NSLog("❌ HTTP Error: \(httpResponse.statusCode)")
                    }
                }
                
                expectation.fulfill()
            }
        }.resume()
        
        wait(for: [expectation], timeout: 15.0)
        NSLog("=== End Google Places API Test ===")
    }
}
