//
//  ImageMarkModelTests.swift
//  DecideForMeTests
//
//  Created by Sikun Chen on 2025-07-15.
//

import XCTest
@testable import DecideForMe

final class ImageMarkModelTests: XCTestCase {
    
    var viewModel: ImageMarkViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ImageMarkViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - ImageMark Model Tests
    
    func testImageMarkInitialization() {
        let position = CGPoint(x: 100, y: 200)
        let mark = ImageMark(numericId: 1, position: position)
        
        XCTAssertEqual(mark.numericId, 1)
        XCTAssertEqual(mark.displayName, "Mark 1")
        XCTAssertEqual(mark.position, position)
    }
    
    func testImageMarkCodable() {
        var originalMark = ImageMark(numericId: 1, position: CGPoint(x: 100, y: 200))
        originalMark.displayName = "Custom Name"
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(originalMark)
            let decodedMark = try decoder.decode(ImageMark.self, from: data)
            
            XCTAssertEqual(decodedMark.numericId, originalMark.numericId)
            XCTAssertEqual(decodedMark.displayName, originalMark.displayName)
            XCTAssertEqual(decodedMark.position, originalMark.position)
        } catch {
            XCTFail("Failed to encode/decode ImageMark: \(error)")
        }
    }
    
    // MARK: - ImageMarkViewModel Tests
    
    func testImageMarkViewModelAddMark() {
        let position = CGPoint(x: 100, y: 200)
        let initialCount = viewModel.marks.count
        
        viewModel.addMark(at: position)
        
        XCTAssertEqual(viewModel.marks.count, initialCount + 1)
        XCTAssertEqual(viewModel.marks.first?.position, position)
        XCTAssertEqual(viewModel.marks.first?.numericId, 1)
    }
    
    func testImageMarkViewModelRemoveMark() {
        let position = CGPoint(x: 100, y: 200)
        viewModel.addMark(at: position)
        let mark = viewModel.marks.first!
        
        viewModel.removeMark(mark)
        
        XCTAssertEqual(viewModel.marks.count, 0)
    }
    
    func testImageMarkViewModelRenameMark() {
        let position = CGPoint(x: 100, y: 200)
        viewModel.addMark(at: position)
        let mark = viewModel.marks.first!
        
        viewModel.renameMark(mark, newName: "Custom Name")
        
        XCTAssertEqual(viewModel.marks.first?.displayName, "Custom Name")
    }
    
    func testImageMarkViewModelSelectRandomMark() {
        viewModel.addMark(at: CGPoint(x: 100, y: 200))
        viewModel.addMark(at: CGPoint(x: 200, y: 300))
        
        viewModel.selectRandomMark()
        
        XCTAssertNotNil(viewModel.selectedMark)
        XCTAssertTrue(viewModel.marks.contains(viewModel.selectedMark!))
    }
    
    func testImageMarkViewModelClearAllMarks() {
        viewModel.addMark(at: CGPoint(x: 100, y: 200))
        viewModel.addMark(at: CGPoint(x: 200, y: 300))
        viewModel.selectRandomMark()
        
        viewModel.clearAllMarks()
        
        XCTAssertEqual(viewModel.marks.count, 0)
        XCTAssertNil(viewModel.selectedMark)
    }
    
    func testNextNumericIdCalculation() {
        // Test empty marks
        XCTAssertEqual(viewModel.marks.count, 0)
        
        // Test with one mark
        viewModel.addMark(at: CGPoint(x: 100, y: 200))
        XCTAssertEqual(viewModel.marks.first?.numericId, 1)
        
        // Test with multiple marks
        viewModel.addMark(at: CGPoint(x: 200, y: 300))
        XCTAssertEqual(viewModel.marks.last?.numericId, 2)
    }
    
    // MARK: - Performance Tests
    
    func testImageMarkViewModelPerformance() {
        measure {
            for i in 0..<100 {
                viewModel.addMark(at: CGPoint(x: i, y: i))
            }
        }
    }
}
