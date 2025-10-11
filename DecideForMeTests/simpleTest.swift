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
}
