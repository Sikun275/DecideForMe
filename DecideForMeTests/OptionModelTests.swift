//
//  OptionModelTests.swift
//  DecideForMeTests
//
//  Created by Sikun Chen on 2025-07-15.
//

import XCTest
@testable import DecideForMe

final class OptionModelTests: XCTestCase {
    
    // MARK: - Option Model Tests
    
    func testOptionInitialization() {
        let option = Option(id: UUID(), name: "Test Option", tags: ["tag1", "tag2"], weight: 5)
        
        XCTAssertEqual(option.name, "Test Option")
        XCTAssertEqual(option.tags, ["tag1", "tag2"])
        XCTAssertEqual(option.weight, 5)
    }
    
    func testOptionPersistence() {
        let testOptions = [
            Option(id: UUID(), name: "Option 1", tags: ["tag1"], weight: 1),
            Option(id: UUID(), name: "Option 2", tags: ["tag2"], weight: 2)
        ]
        
        Option.save(testOptions)
        let loadedOptions = Option.load()
        
        XCTAssertEqual(loadedOptions.count, testOptions.count)
        XCTAssertEqual(loadedOptions.first?.name, testOptions.first?.name)
    }
    
    // MARK: - OptionViewModel Tests
    
    func testOptionViewModelAddOption() {
        let viewModel = OptionViewModel()
        let initialCount = viewModel.options.count
        
        viewModel.addOption(name: "Test Option", tags: ["test"])
        
        XCTAssertEqual(viewModel.options.count, initialCount + 1)
        XCTAssertEqual(viewModel.options.last?.name, "Test Option")
        XCTAssertEqual(viewModel.options.last?.tags, ["test"])
    }
    
    func testOptionViewModelRemoveOption() {
        let viewModel = OptionViewModel()
        let option = Option(id: UUID(), name: "Test", tags: [], weight: 1)
        viewModel.options.append(option)
        let initialCount = viewModel.options.count
        
        viewModel.removeOption(option)
        
        XCTAssertEqual(viewModel.options.count, initialCount - 1)
        XCTAssertFalse(viewModel.options.contains(option))
    }
    
    func testOptionViewModelFilteredOptions() {
        let viewModel = OptionViewModel()
        viewModel.addOption(name: "Option 1", tags: ["cheap", "fast"])
        viewModel.addOption(name: "Option 2", tags: ["expensive", "slow"])
        
        viewModel.selectedTags.insert("cheap")
        
        XCTAssertEqual(viewModel.filteredOptions.count, 1)
        XCTAssertEqual(viewModel.filteredOptions.first?.name, "Option 1")
    }
    
    func testOptionViewModelDecide() {
        let viewModel = OptionViewModel()
        viewModel.addOption(name: "Option 1", tags: [], weight: 1)
        viewModel.addOption(name: "Option 2", tags: [], weight: 1)
        
        viewModel.decide()
        
        XCTAssertNotNil(viewModel.selectedOption)
        XCTAssertTrue(viewModel.options.contains(viewModel.selectedOption!))
    }
    
    func testOptionViewModelFeedback() {
        let viewModel = OptionViewModel()
        viewModel.addOption(name: "Test Option", tags: [], weight: 1)
        let initialWeight = viewModel.options.first!.weight
        
        viewModel.decide()
        // Only test feedback if an option was selected
        if viewModel.selectedOption != nil {
            viewModel.feedback(liked: true)
            XCTAssertEqual(viewModel.options.first?.weight, initialWeight + 1)
        } else {
            // If no option was selected, weight should remain the same
            XCTAssertEqual(viewModel.options.first?.weight, initialWeight)
        }
    }
    
    // MARK: - Performance Tests
    
    func testOptionViewModelPerformance() {
        let viewModel = OptionViewModel()
        
        measure {
            for i in 0..<100 {
                viewModel.addOption(name: "Option \(i)", tags: ["tag\(i)"])
            }
        }
    }
}
