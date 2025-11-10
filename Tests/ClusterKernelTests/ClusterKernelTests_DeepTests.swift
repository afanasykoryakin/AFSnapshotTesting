//
// ClusterKernelTests_DeepTests.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 07.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License
//

import XCTest
import Services
@testable import AFSnapshotTesting

final class ClusterKernelTests_DeepTests: XCTestCase {
    let kernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))
    let combinedKernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + deltaDiffTool(with: 0.0) + MSLClusterKernel))

    func testClusterKernelDeep_DeepClusterIsThree_DeepIsTwo() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 3)

        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(combinedDifference, 3)
    }
    
    func testClusterKernelDeep_DeepClusterIsThree_DeepIsThree() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 3)

        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(combinedDifference, 3)
    }

    func testClusterKernelDeep_DeepClusterIsThree_DeepIsFive() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(difference, 0)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(combinedDifference, 0)
    }
    
    func testClusterKernelDeep_DeepClusterIsThree_DeepIsSeven() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(difference, 0)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(combinedDifference, 0)
    }
    
    func testClusterKernelDeep_DeepClusterIsFive_DeepIsTwo() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 5)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(combinedDifference, 5)
    }
    
    func testClusterKernelDeep_DeepClusterIsFive_DeepIsThree() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 5)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(combinedDifference, 5)
    }
    
    func testClusterKernelDeep_DeepClusterIsFive_DeepIsFive() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(difference, 5)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(combinedDifference, 5)
    }
    
    func testClusterKernelDeep_DeepClusterIsFive_DeepIsSeven() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(difference, 0)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(combinedDifference, 0)
    }
    
    func testClusterKernelDeep_DeepClusterIsSeven_DeepIsTwo() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 7)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(combinedDifference, 7)
    }
    
    func testClusterKernelDeep_DeepClusterIsSeven_DeepIsThree() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 7)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(combinedDifference, 7)
    }
    
    func testClusterKernelDeep_DeepClusterIsSeven_DeepIsFive() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(difference, 7)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 5)
        XCTAssertEqual(combinedDifference, 7)
    }
    
    func testClusterKernelDeep_DeepClusterIsSeven_DeepIsSeven() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(difference, 7)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 7)
        XCTAssertEqual(combinedDifference, 7)
    }
}
