//
// ClusterKernelTests_GradientColor.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 07.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License
//

import XCTest
import Services
@testable import AFSnapshotTesting

final class ClusterKernelTests_GradientColor: XCTestCase {
    let kernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))
    let combinedKernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + deltaDiffTool(with: 0.0) + MSLClusterKernel))

    func testClusterKernelGradient_SameImages() throws {
        for deep in [1, 2, 3, 4, 5, 6, 7] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(difference, 0)

            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(combinedDifference, 0)
        }
    }

    func testClusterKernelGradient_FullDifference() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2962440)
        
        // The combined kernel with zero tolerance should just be clusterKernel
        let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(combinedDifference, 2962440)
    }

    func testClusterKernelGradient_BigClustersDifference() throws {
        for deep in [1, 2, 3, 4, 5, 6, 7] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(difference, 418571)
            
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(combinedDifference, 418571)
        }
    }

    func testClusterKernelGradient_SpiderDifference() throws {
        for deep in [1, 2, 3, 4, 5, 6, 7] {
            let expected = (347 * 1175) + (17 * 835) + (564 * 10) + 388
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(difference, expected)
            
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: deep)
            XCTAssertEqual(combinedDifference, expected)
        }
    }

    func testClusterKernelGradient_MaxClusterSizeIsOne() throws {
        for pair in [1:7, 2:0, 3:0, 4: 0, 5:0, 6:0, 7:0] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(difference, pair.value)
            
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(combinedDifference, pair.value)
        }
    }

    func testClusterKernelGradient_MaxClusterSizeIsTwo() throws {
        for pair in [1:18, 2:14, 3:0, 4:0, 5:0, 6:0, 7:0] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(difference, pair.value)
    
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(combinedDifference, pair.value)
        }
    }

    func testClusterKernelGradient_MaxClusterSizeIsThree() throws {
        for pair in [1:10, 2:7, 3:3, 4:0, 5:0, 6:0, 7:0] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(difference, pair.value)
            
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(combinedDifference, pair.value)
        }
    }

    func testClusterKernelGradient_MaxClusterSizeIsFour() throws {
        for pair in [1:14, 2:11, 3:7, 4:4, 5:0, 6:0, 7:0] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(difference, pair.value)
            
            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(combinedDifference, pair.value)
        }
    }

    func testClusterKernelGradient_MaxClusterSizeIsSeven() throws {
        for pair in [1:21, 2:18, 3:14, 4:11, 5:7, 6:7, 7:7] {
            let (lhs, rhs) = images(className: String(describing: type(of: self)), referenceName: "BlueRedGradient")
            let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(difference, pair.value)

            // The combined kernel with zero tolerance should just be clusterKernel
            let combinedDifference = try combinedKernel.difference(lhs: lhs, rhs: rhs, clusterSize: pair.key)
            XCTAssertEqual(combinedDifference, pair.value)
        }
    }
}
