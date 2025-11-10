//
// ClusterKernelTests_OneMismatch.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 07.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License
//

import XCTest
import Services
@testable import AFSnapshotTesting

final class ClusterKernelTests_OneMismatch: XCTestCase {
    let kernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))

    func testClusterKernelWithOneMismatchPixel_DeepIsOne() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 1)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsOne_OnLeftUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 1)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsOne_OnRightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 1)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsOne_OnLeftBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 1)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsOne_OnRightBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 1)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsTwo() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsTwo_OnLeftUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsTwo_OnRightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsTwo_OnLeftBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsTwo_OnRightBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsThree() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsThree_OnLeftUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsThree_OnRightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsThree_OnLeftBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithOneMismatchPixel_DeepIsThree_OnRightBottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
}
