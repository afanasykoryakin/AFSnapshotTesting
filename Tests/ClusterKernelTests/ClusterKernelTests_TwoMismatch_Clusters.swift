//
// ClusterKernelTests_TwoMismatch_Cluster.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 07.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License
//

import XCTest
import Services
@testable import AFSnapshotTesting

final class ClusterKernelTests_TwoMismatch_Cluster: XCTestCase {
    let kernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnLeftUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnRightUp_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnRightUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnBottomRight_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnBottomRight_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnBottomLeft_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_OnBottomLeft_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Up() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_RightUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Right() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_RightBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_BottomLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_Left() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsOne_Center_LeftUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 1)
        XCTAssertEqual(difference, 2)
    }
    
    // MARK: Deep is Two
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnLeftUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnRightUp_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnRightUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnBottomRight_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnBottomRight_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnBottomLeft_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_OnBottomLeft_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Up() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_RightUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Right() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_RightBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_BottomLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_Left() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsTwo_Center_LeftUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 2)
        XCTAssertEqual(difference, 2)
    }
    
    // MARK: Deep is Three
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnLeftUp_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnLeftUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }

    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnRightUp_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnRightUp_OnBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnBottomRight_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnBottomRight_OnLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnBottomLeft_OnUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_OnBottomLeft_OnRight() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_Up() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_RightUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_Right() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_RightBottom() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_BottomLeft() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_Left() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
    
    func testClusterKernelWithTwoMismatchPixels_DeepIsThree_Center_LeftUp() throws {
        let (lhs, rhs) = images(className: String(describing: type(of: self)))
        let difference = try kernel.difference(lhs: lhs, rhs: rhs, clusterSize: 3)
        XCTAssertEqual(difference, 0)
    }
}
