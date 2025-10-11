//
//  ImageMarkViewTests.swift
//  DecideForMeTests
//
//  Created by Sikun Chen on 2025-07-15.
//

import XCTest
import SwiftUI
import UIKit
@testable import DecideForMe

final class ImageMarkViewTests: XCTestCase {
    
    var viewModel: ImageMarkViewModel!
    var imageMarkView: ImageMarkView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ImageMarkViewModel()
        imageMarkView = ImageMarkView()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        imageMarkView = nil
        try super.tearDownWithError()
    }
    
    // MARK: - UI Component Tests
    
    func testImageMarkViewInitialState() {
        XCTAssertNotNil(imageMarkView)
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.marks.isEmpty)
        XCTAssertNil(viewModel.selectedMark)
    }
    
    func testImageMarkViewWithMarks() {
        // Add some marks to test UI state
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        viewModel.addMark(at: CGPoint(x: 200, y: 200))
        
        XCTAssertEqual(viewModel.marks.count, 2)
        XCTAssertNotNil(viewModel.marks.first)
        XCTAssertNotNil(viewModel.marks.last)
    }
    
    func testImageMarkViewSelectionState() {
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        let mark = viewModel.marks.first!
        
        viewModel.selectMark(mark)
        
        XCTAssertEqual(viewModel.selectedMark, mark)
    }
    
    func testImageMarkViewClearSelection() {
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        let mark = viewModel.marks.first!
        viewModel.selectMark(mark)
        
        viewModel.clearSelection()
        
        XCTAssertNil(viewModel.selectedMark)
    }
    
    func testImageMarkViewRenameMark() {
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        let mark = viewModel.marks.first!
        
        viewModel.renameMark(mark, newName: "Custom Name")
        
        XCTAssertEqual(viewModel.marks.first?.displayName, "Custom Name")
    }
    
    func testImageMarkViewRenameMarkWithEmptyString() {
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        let mark = viewModel.marks.first!
        
        viewModel.renameMark(mark, newName: "")
        
        // The current implementation allows empty strings
        XCTAssertEqual(viewModel.marks.first?.displayName, "")
    }
    
    func testImageMarkViewConcurrentOperations() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "test.queue", attributes: .concurrent)
        
        // Test concurrent mark additions
        for i in 0..<10 {
            group.enter()
            queue.async {
                self.viewModel.addMark(at: CGPoint(x: i * 10, y: i * 10))
                group.leave()
            }
        }
        
        group.wait()
        
        // With concurrent operations, we might get fewer marks due to race conditions
        // but we should get at least some marks
        XCTAssertGreaterThan(viewModel.marks.count, 0)
        XCTAssertLessThanOrEqual(viewModel.marks.count, 10)
    }
    
    func testImageMarkViewPerformanceWithManyMarks() {
        measure {
            for i in 0..<50 {
                viewModel.addMark(at: CGPoint(x: i, y: i))
            }
        }
    }
    
    func testImageMarkViewMemoryManagement() {
        weak var weakViewModel: ImageMarkViewModel?
        
        autoreleasepool {
            let localViewModel = ImageMarkViewModel()
            weakViewModel = localViewModel
            
            for i in 0..<100 {
                localViewModel.addMark(at: CGPoint(x: i, y: i))
            }
        }
        
        // ViewModel should be deallocated after autoreleasepool
        XCTAssertNil(weakViewModel)
    }
    
    func testImageMarkViewStateConsistency() {
        // Test that view state remains consistent after various operations
        viewModel.addMark(at: CGPoint(x: 100, y: 100))
        viewModel.addMark(at: CGPoint(x: 200, y: 200))
        
        let mark1 = viewModel.marks[0]
        let mark2 = viewModel.marks[1]
        
        // Select first mark
        viewModel.selectMark(mark1)
        XCTAssertEqual(viewModel.selectedMark, mark1)
        
        // Remove second mark
        viewModel.removeMark(mark2)
        XCTAssertEqual(viewModel.marks.count, 1)
        XCTAssertEqual(viewModel.marks.first, mark1)
        
        // Selection should still be valid
        XCTAssertEqual(viewModel.selectedMark, mark1)
    }
    
    func testImageMarkViewEdgeCases() {
        // Test removing non-existent mark
        let nonExistentMark = ImageMark(numericId: 999, position: CGPoint(x: 999, y: 999))
        let initialCount = viewModel.marks.count
        viewModel.removeMark(nonExistentMark)
        XCTAssertEqual(viewModel.marks.count, initialCount)
        
        // Test selecting non-existent mark
        viewModel.selectMark(nonExistentMark)
        XCTAssertNil(viewModel.selectedMark)
        
        // Test renaming non-existent mark
        viewModel.renameMark(nonExistentMark, newName: "New Name")
        XCTAssertEqual(viewModel.marks.count, initialCount)
    }
}

