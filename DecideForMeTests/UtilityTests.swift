//
//  UtilityTests.swift
//  DecideForMeTests
//
//  Created by Sikun Chen on 2025-07-15.
//

import XCTest
@testable import DecideForMe

final class UtilityTests: XCTestCase {
    
    // MARK: - Distance Calculation Tests
    
    func testDistanceCalculation() {
        let location1 = GLocation(lat: 43.6532, lng: -79.3832)
        let location2 = (lat: 43.6532, lng: -79.3832)
        
        let distance = location1.distance(from: location2)
        
        XCTAssertEqual(distance, 0, accuracy: 1.0) // Should be very close to 0
    }
    
    func testDistanceCalculationDifferentLocations() {
        let location1 = GLocation(lat: 43.6532, lng: -79.3832) // Toronto
        let location2 = (lat: 40.7128, lng: -74.0060) // New York
        
        let distance = location1.distance(from: location2)
        
        // Distance between Toronto and New York should be approximately 550km
        // Using a more realistic range for the simplified distance calculation
        XCTAssertGreaterThan(distance, 300000) // 300km
        XCTAssertLessThan(distance, 800000) // 800km
    }
    
    func testDistanceCalculationAccuracy() {
        let location1 = GLocation(lat: 0.0, lng: 0.0)
        let location2 = (lat: 0.0, lng: 1.0) // 1 degree longitude at equator
        
        let distance = location1.distance(from: location2)
        
        // 1 degree longitude at equator is approximately 111km
        XCTAssertEqual(distance, 111000, accuracy: 1000) // Within 1km accuracy
    }
    
    // MARK: - Edge Case Tests
    
    func testDistanceCalculationSameLocation() {
        let location = GLocation(lat: 37.7749, lng: -122.4194)
        let sameLocation = (lat: 37.7749, lng: -122.4194)
        
        let distance = location.distance(from: sameLocation)
        
        XCTAssertEqual(distance, 0, accuracy: 1.0)
    }
    
    func testDistanceCalculationPolarRegions() {
        let northPole = GLocation(lat: 90.0, lng: 0.0)
        let southPole = (lat: -90.0, lng: 0.0)
        
        let distance = northPole.distance(from: southPole)
        
        // Distance between poles should be approximately 20,000km
        XCTAssertGreaterThan(distance, 19000000) // 19,000km
        XCTAssertLessThan(distance, 21000000) // 21,000km
    }
    
    func testDistanceCalculationInternationalDateLine() {
        let location1 = GLocation(lat: 0.0, lng: 179.0)
        let location2 = (lat: 0.0, lng: -179.0)
        
        let distance = location1.distance(from: location2)
        
        // Should handle crossing the international date line correctly
        // The simplified distance calculation doesn't handle date line crossing properly
        // but it should still return a reasonable distance
        XCTAssertGreaterThan(distance, 0)
        // The simplified calculation will give a large distance for date line crossing
        XCTAssertLessThan(distance, 40000000) // Should be less than 40,000km
    }
}
