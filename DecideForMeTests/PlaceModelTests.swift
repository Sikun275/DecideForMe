//
//  PlaceModelTests.swift
//  DecideForMeTests
//
//  Created by Sikun Chen on 2025-07-15.
//

import XCTest
import CoreLocation
@testable import DecideForMe

final class PlaceModelTests: XCTestCase {
    
    // MARK: - Place Model Tests
    
    func testPlacePersistence() {
        let testPlaces = [
            Place(name: "Place 1", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "1", weight: 2),
            Place(name: "Place 2", distance: 2000, rating: 3.0, lat: 43.6532, lng: -79.3832, placeId: "2", weight: 1)
        ]
        
        Place.save(testPlaces)
        let loadedPlaces = Place.load()
        
        XCTAssertEqual(loadedPlaces.count, testPlaces.count)
        XCTAssertEqual(loadedPlaces.first?.name, testPlaces.first?.name)
        XCTAssertEqual(loadedPlaces.first?.weight, testPlaces.first?.weight)
    }
    
    func testPlaceCombinedScore() {
        let closePlace = Place(name: "Close Place", distance: 1000, rating: 4.0, lat: 43.6532, lng: -79.3832, placeId: "close", weight: 1)
        let farPlace = Place(name: "Far Place", distance: 40000, rating: 4.0, lat: 43.6532, lng: -79.3832, placeId: "far", weight: 1)
        
        let closeScore = closePlace.combinedScore()
        let farScore = farPlace.combinedScore()
        
        NSLog("the close score is: \(closeScore)")
        NSLog("the far score is: \(farScore)")
        XCTAssertGreaterThan(closeScore, farScore)
    }
    
    // MARK: - MapDecisionViewModel Tests
    
    func testMapDecisionViewModelFilteredPlaces() {
        let viewModel = MapDecisionViewModel()
        let place1 = Place(name: "Place 1", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "1", weight: 1)
        let place2 = Place(name: "Place 2", distance: 2000, rating: 3.0, lat: 43.6532, lng: -79.3832, placeId: "2", weight: 1)
        
        viewModel.places = [place1, place2]
        viewModel.minRating = 4.0
        viewModel.maxDistance = 1500
        
        XCTAssertEqual(viewModel.filtered.count, 1)
        XCTAssertEqual(viewModel.filtered.first?.name, "Place 1")
    }
    
    func testMapDecisionViewModelDecide() {
        let viewModel = MapDecisionViewModel()
        let place1 = Place(name: "Place 1", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "1", weight: 1)
        let place2 = Place(name: "Place 2", distance: 2000, rating: 3.0, lat: 43.6532, lng: -79.3832, placeId: "2", weight: 1)
        
        viewModel.places = [place1, place2]
        viewModel.decide()
        
        XCTAssertNotNil(viewModel.selectedPlace)
        XCTAssertTrue(viewModel.places.contains(viewModel.selectedPlace!))
    }
    
    func testMapDecisionViewModelRemovePlace() {
        let viewModel = MapDecisionViewModel()
        let place = Place(name: "Test Place", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "test", weight: 1)
        viewModel.places = [place]
        
        viewModel.removePlace(place)
        
        XCTAssertEqual(viewModel.places.count, 0)
    }
    
    func testMapDecisionViewModelFeedback() {
        let viewModel = MapDecisionViewModel()
        let place = Place(name: "Test Place", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "test", weight: 1)
        viewModel.places = [place]
        viewModel.selectedPlace = place
        
        let initialWeight = place.weight
        viewModel.feedback(liked: true)
        
        XCTAssertEqual(viewModel.places.first?.weight, initialWeight + 1)
    }
    
    func testMapDecisionViewModelLocation() {
        let viewModel = MapDecisionViewModel()
        
        // Test initial location state
        print("=== Location Test Results ===")
        print("Initial location permission status: \(viewModel.locationPermissionStatus.rawValue)")
        print("Initial current location: \(viewModel.currentLocation?.description ?? "nil")")
        
        // Test default location (Toronto)
        let defaultLocation = CLLocation(latitude: 43.6532, longitude: -79.3832)
        print("Default location (Toronto): \(defaultLocation.coordinate.latitude), \(defaultLocation.coordinate.longitude)")
        
        // Test location permission request
        viewModel.requestLocationPermission()
        print("After permission request - status: \(viewModel.locationPermissionStatus.rawValue)")
        
        // Test location update simulation
        let testLocation = CLLocation(latitude: 40.7128, longitude: -74.0060) // New York
        viewModel.currentLocation = testLocation
        print("Test location set to: \(testLocation.coordinate.latitude), \(testLocation.coordinate.longitude)")
        
        // Test distance calculation from test location
        let place = Place(name: "Test Place", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "test", weight: 1)
        let distance = place.distance
        print("Place distance from current location: \(distance) meters")
        
        // Test combined score with location
        let score = place.combinedScore()
        print("Place combined score: \(score)")
        print("=== End Location Test ===")
        
        // Assertions
        XCTAssertNotNil(viewModel.currentLocation)
        XCTAssertEqual(viewModel.currentLocation?.coordinate.latitude, testLocation.coordinate.latitude)
        XCTAssertEqual(viewModel.currentLocation?.coordinate.longitude, testLocation.coordinate.longitude)
    }
    
    func testMapDecisionViewModelLocationManagerDelegate() {
        let viewModel = MapDecisionViewModel()
        
        print("=== Location Manager Delegate Test ===")
        
        // Test location update delegate method
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let locations = [testLocation]
        
        print("Before delegate call - current location: \(viewModel.currentLocation?.description ?? "nil")")
        viewModel.locationManager(CLLocationManager(), didUpdateLocations: locations)
        print("After delegate call - current location: \(viewModel.currentLocation?.description ?? "nil")")
        
        // Test location failure delegate method
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        print("Before error delegate call - current location: \(viewModel.currentLocation?.description ?? "nil")")
        viewModel.locationManager(CLLocationManager(), didFailWithError: testError)
        print("After error delegate call - current location: \(viewModel.currentLocation?.description ?? "nil")")
        
        // Test authorization change delegate method
        print("Before authorization change - status: \(viewModel.locationPermissionStatus.rawValue)")
        viewModel.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)
        print("After authorization change - status: \(viewModel.locationPermissionStatus.rawValue)")
        
        print("=== End Location Manager Delegate Test ===")
        
        // Assertions
        XCTAssertNotNil(viewModel.currentLocation)
        XCTAssertEqual(viewModel.locationPermissionStatus, .authorizedWhenInUse)
    }
}
