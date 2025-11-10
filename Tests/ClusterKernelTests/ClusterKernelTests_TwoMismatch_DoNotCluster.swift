//
// ClusterKernelTests_TwoMismatch_DoNotCluster.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 07.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License
//

import XCTest
import Services
@testable import AFSnapshotTesting

final class ClusterKernelTests_TwoMismatch_DoNotCluster: XCTestCase {
    let kernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_OnRightUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_OnBottomRight() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_OnBottomLeft() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_Center() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_LeftUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Up() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_RightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Right() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_BottomRight() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Bottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_BottomLeft() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_OnRightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_OnBottomRight() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_OnBottomLeft() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_Center() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_LeftUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Up() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_RightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Right() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_BottomRight() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Bottom() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_BottomLeft() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 2)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnLeftUp_OnRightUp() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnLeftUp_OnBottomRight() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnLeftUp_OnBottomLeft() throws {
        let (image1, image2) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: image1, rhs: image2, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
}
