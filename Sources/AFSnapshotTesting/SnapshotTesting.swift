//
// SnapshotTesting.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 04.02.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE
//

import UIKit
import XCTest
import MetalKit

@available(iOS 10.0, *)
extension XCTestCase {
    public func assertSnapshot(
        _ view: UIView,
        on screen: SnapshotDevice,
        as strategy: Strategy = .naive(threshold: 0),
        inDirectory directoryURL: URL? = nil,
        traits: [UITraitCollection]? = nil,
        record: Bool = false,
        differenceRecord: Bool = true,
        color: MismatchColor = .green,
        file: StaticString = #file,
        line: UInt = #line,
        testName: String = #function,
        className: String? = nil,
        named: String? = nil
    ) {
        assertSnapshot(
            view,
            on: (size: screen.size, scale: screen.scale),
            as: strategy,
            inDirectory: directoryURL,
            traits: traits,
            record: record,
            differenceRecord: differenceRecord,
            file: file,
            line: line,
            testName: testName,
            className: className ?? String(describing: type(of: self)),
            named: named
        )
    }

    public func assertSnapshot(
        _ view: UIView,
        as strategy: Strategy = .naive(threshold: 0),
        inDirectory directoryURL: URL? = nil,
        traits: [UITraitCollection]? = nil,
        record: Bool = false,
        differenceRecord: Bool = true,
        color: MismatchColor = .green,
        file: StaticString = #file,
        line: UInt = #line,
        testName: String = #function,
        className: String? = nil,
        named: String? = nil
    ) {
        assertSnapshot(
            view,
            on: nil,
            as: strategy,
            inDirectory: directoryURL,
            traits: traits,
            record: record,
            differenceRecord: differenceRecord,
            file: file,
            line: line,
            testName: testName,
            className: className ?? String(describing: type(of: self)),
            named: named
        )
    }

    public func assertSnapshot(
        _ view: UIView,
        on screen: (size: CGSize, scale: Int)?,
        as strategy: Strategy = .naive(threshold: 0),
        inDirectory directoryURL: URL? = nil,
        traits: [UITraitCollection]? = nil,
        record: Bool = false,
        differenceRecord: Bool = true,
        color: MismatchColor = .green,
        file: StaticString = #file,
        line: UInt = #line,
        testName: String = #function,
        className: String? = nil,
        named: String? = nil,
        memcmpSpeed: Bool = false
    ) {
        do {
            AFSnapshotTesting.assertSnapshot(
                try Snapshot.renderImage(view: view, on: screen, traits: traits),
                on: screen,
                as: strategy,
                inDirectory: directoryURL,
                record: record,
                differenceRecord: differenceRecord,
                file: file,
                line: line,
                testName: testName,
                className: className ?? String(describing: type(of: self)),
                named: named,
                memcmpSpeed: memcmpSpeed
            )
        } catch {
            XCTFail("Failed for renderImager with error: \(error)", file: file, line: line)
        }
    }
}

public func assertSnapshot(
    _ element: XCUIElement,
    configuration: SnapshotConfiguration = SnapshotConfiguration(),
    file: StaticString = #file,
    line: UInt = #line,
    testName: String = #function,
    className: String,
    memcmpSpeed: Bool = false
) {
    assertSnapshot(
        element.screenshot().image,
        on: configuration.screen,
        as: configuration.strategy,
        inDirectory: configuration.directoryURL,
        record: configuration.record,
        differenceRecord: configuration.differenceRecord,
        file: file,
        line: line,
        testName: testName,
        className: className,
        named: configuration.snapshotName,
        memcmpSpeed: memcmpSpeed
    )
}

public func assertSnapshot(
    _ snapshot: UIImage,
    on screen: (size: CGSize, scale: Int)?,
    as strategy: Strategy = .naive(threshold: 0),
    inDirectory directoryURL: URL? = nil,
    record: Bool = false,
    differenceRecord: Bool = true,
    color: MismatchColor = .green,
    file: StaticString = #file,
    line: UInt = #line,
    testName: String = #function,
    className: String,
    named: String? = nil,
    memcmpSpeed: Bool = false
) {

    let artifactsDirectory: URL

    if let artifactsUrl = ProcessInfo.processInfo.environment["SNAPSHOT_ARTIFACTS"] {
        guard let environmentDirectory = URL(string: "file:///\(artifactsUrl)") else {
            return XCTFail("Failed to create diff image directory from environment for key 'SNAPSHOT_ARTIFACTS'", file: file, line: line)
        }

        artifactsDirectory = environmentDirectory
    } else {
        artifactsDirectory = directoryURL ?? URL(fileURLWithPath: String(describing: file)).deletingLastPathComponent()
    }

    let funcName = named ?? testName.replacingOccurrences(of: "()", with: "")

    let referenceURL = Snapshot.createReferenceURL(
        name: funcName,
        class: className,
        inDirectory: artifactsDirectory
    )

    let differenceURL = Snapshot.createDifferenceImageURL(
        name: funcName,
        class: className,
        inDirectory: artifactsDirectory
    )

    let referenceSnapshotDoesNotExist = !FileManager.default.fileExists(atPath: referenceURL.path)

    if record || referenceSnapshotDoesNotExist {
        do {
            if let errorDescription = validationInput(screen ?? (size: snapshot.size, scale: Int(snapshot.scale)), strategy: strategy) {
                return XCTFail(errorDescription, file: file, line: line)
            }
            try snapshot.data().save(in: referenceURL)
        } catch {
            XCTFail("Failed to save reference snapshot with error: \(error)", file: file, line: line)
        }
        
        if referenceSnapshotDoesNotExist {
            XCTFail("No reference was found on disk. Automatically recorded snapshot: \(referenceURL)", file: file, line: line)
        }
    } else {
        do {
            if let errorDescription = validationInput(screen ?? (size: snapshot.size, scale: Int(snapshot.scale)), strategy: strategy) {
                return XCTFail(errorDescription, file: file, line: line)
            }
            
            guard let snapshotCGImage = snapshot.cgImage else {
                throw SnapshotError.failedToCreateCGImage(snapshotName: "Render for process")
            }
            
            let referenceSnapshot = try Snapshot.createReferenceSnapshot(from: referenceURL)
            
            guard let referenceSnapshotCGImage = referenceSnapshot.cgImage else {
                throw SnapshotError.failedToCreateCGImage(snapshotName: referenceURL.lastPathComponent)
            }
            
            let prepareReferenceSnapshotContext = try Snapshot.normilize(cgImage: referenceSnapshotCGImage)
            let prepareSnapshotContext = try Snapshot.normilize(cgImage: snapshotCGImage)
            
            guard let prepareReferenceSnapshot = prepareReferenceSnapshotContext.makeImage() else {
                throw SnapshotError.failedToPrepareCGImage(description: "Failed to get reference CGImage from context")
            }
            
            guard let prepareSnapshot = prepareSnapshotContext.makeImage() else {
                throw SnapshotError.failedToPrepareCGImage(description: "Failed to get render CGImage from context")
            }
            
            guard prepareSnapshot.width == prepareReferenceSnapshot.width, prepareSnapshot.height == prepareReferenceSnapshot.height else {
                throw SnapshotError.snapshotsSizeDoesNotEqual(description: "Snapshot size does not match. render size: \(prepareSnapshot.width) x \(prepareSnapshot.height), reference size: \(prepareReferenceSnapshot.width) x \(prepareReferenceSnapshot.height)")
            }
            
            if memcmpSpeed {
                guard let referenceData = prepareReferenceSnapshotContext.data, let renderData = prepareSnapshotContext.data else {
                    throw SnapshotError.error(description: "Context data is error")
                }
                
                let pixelCount = prepareSnapshot.width * prepareSnapshot.height
                let byteCount = Snapshot.imageContextBytesPerPixel * pixelCount
                
                guard memcmp(referenceData, renderData, byteCount) != 0 else {
                    return
                }
            }
            
            switch strategy {
            case .naive(threshold: let threshold):
                let difference = try Snapshot.naiveDifference(prepareSnapshot, prepareReferenceSnapshot)
                
                guard difference > threshold else { return }
                
                let differenceCGImage = try NaiveKernelDifferenceImage(with: .init(metalSource: MSLNaiveKernel))
                    .differenceImage(lhs: prepareSnapshot, rhs: prepareReferenceSnapshot, color: color)
                let differenceImage = UIImage(cgImage: differenceCGImage)
                
                guard differenceRecord else {
                    throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference)) is greater than the specified threshold (\(threshold)).", diff: differenceImage)
                }
                
                try differenceImage.data()
                    .save(in: differenceURL)
                
                throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference)) is greater than the specified threshold (\(threshold)). Difference image save to \(differenceURL)", diff: differenceImage)
            case .cluster(threshold: let threshold, clusterSize: let clusterSize):
                let difference = try Snapshot.clusterDifference(prepareSnapshot, prepareReferenceSnapshot, clusterSize: clusterSize)
                
                guard difference > threshold else { return }
                
                let differenceCGImage = try ClusterKernelDifferenceImage(with: .init(metalSource: MetalHeader + MSLClusterKernel))
                    .differenceImage(lhs: prepareSnapshot, rhs: prepareReferenceSnapshot, clusterSize: clusterSize, color: color)
                let differenceImage = UIImage(cgImage: differenceCGImage)
                
                guard differenceRecord else {
                    throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference)) is greater than the specified threshold (\(threshold)).", diff: differenceImage)
                }
                
                try differenceImage.data()
                    .save(in: differenceURL)
                
                throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference) pixels) is greater than the specified threshold (\(threshold)). Difference image save to \(differenceURL)", diff: differenceImage)
            case .perceptualTollerance, .perceptualTollerance_v1, .perceptualTollerance_v2:
                var deltaE: Float
                var threshold: Int
                
                switch strategy {
                case .perceptualTollerance(threshold: let threshold_value, deltaE: let value):
                    threshold = threshold_value
                    deltaE = value
                case .perceptualTollerance_v1(threshold: let threshold_value, perceptualPrecision: let perceptualPrecision):
                    threshold = threshold_value
                    deltaE = (1 - perceptualPrecision) * 100
                case .perceptualTollerance_v2(precission: let precission, perceptualPrecision: let perceptualPrecision):
                    let pixelsCount = Float(referenceSnapshot.size.width * referenceSnapshot.size.height)
                    let accepted = pixelsCount * precission
                    threshold = Int(pixelsCount - (accepted >= 1.0 ? accepted : pixelsCount))
                    deltaE = (1 - perceptualPrecision) * 100
                default:
                    threshold = 0
                    deltaE = 0
                    fatalError("Other stategy should be throw or return")
                }
                
                let difference = try Snapshot.deltaDifference(prepareSnapshot, prepareReferenceSnapshot, deltaE)
                
                guard difference > threshold else { return }
                
                let diffImage: () throws -> UIImage = {
                    let differenceCGImage = try DeltaKernelDifferenceImage(
                        with: Kernel.Configuration(
                            metalSource: MetalHeader + MSLDeltaE2000KernelSafe
                        )
                    ).differenceImage(
                        lhs: prepareSnapshot,
                        rhs: prepareReferenceSnapshot,
                        tollerance: deltaE,
                        color: color
                    )
                    return UIImage(cgImage: differenceCGImage)
                }
                
                let differenceImage = try diffImage()
                
                guard differenceRecord else {
                    throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference)) is greater than the specified threshold (\(threshold)).", diff: differenceImage)
                }
                
                try differenceImage
                    .data()
                    .save(in: differenceURL)
                
                throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference) pixels) is greater than the specified threshold (\(threshold)). Difference image save to \(differenceURL)", diff: differenceImage)
            case .combined(threshold: let threshold, clusterSize: let clusterSize, deltaE: let deltaE):
                let combinedKernel = try ClusterKernel.init(
                    with: Kernel.Configuration(
                        metalSource: MetalHeader + deltaDiffTool(with: deltaE) + MSLClusterKernel
                    )
                )
                
                let difference = try combinedKernel.difference(lhs: prepareSnapshot, rhs: prepareReferenceSnapshot, clusterSize: clusterSize)
                
                guard difference > threshold else { return }
                
                let combinedDifferenceCGImage = try ClusterKernelDifferenceImage(
                    with: Kernel.Configuration(
                        metalSource: MetalHeader + deltaDiffTool(with: deltaE) + MSLClusterKernel
                    )
                )
                
                let differenceCGImage = try combinedDifferenceCGImage.differenceImage(
                    lhs: prepareSnapshot,
                    rhs: prepareReferenceSnapshot,
                    clusterSize: clusterSize,
                    color: color
                )
                
                let differenceImage = UIImage(cgImage: differenceCGImage)
                
                guard differenceRecord else {
                    throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference)) is greater than the specified threshold (\(threshold)).", diff: differenceImage)
                }
                
                try differenceImage.data()
                    .save(in: differenceURL)
                
                throw SnapshotError.snapshotMismatch(description: "Threshold exceeded: current difference (\(difference) pixels) is greater than the specified threshold (\(threshold)). Difference image save to \(differenceURL)", diff: differenceImage)
            }
        } catch {
            guard let snapshotError = error as? SnapshotError else {
                return XCTFail("Failed with unknown error: \(error)", file: file, line: line)
            }
            
            switch snapshotError {
            case .snapshotMismatch(let description, let diffImage):
                XCTContext.runActivity(named: "Attached Recorded Snapshot") { activity in
                    let attachment = XCTAttachment(image: diffImage, quality: .medium)
                    attachment.name = "Screenshot mismatch diff"
                    attachment.lifetime = .keepAlways
                    activity.add(attachment)
                }
                
                XCTFail("Snapshot mismatch: \(description)", file: file, line: line)
            case .scaleDifference,
                    .failedToCreateCGImage,
                    .referenceImageNotFound,
                    .failedToPrepareCGImage,
                    .error,
                    .snapshotsSizeDoesNotEqual:
                XCTFail("Failed with other 'SnapshotError' error: \(error)", file: file, line: line)
            }
        }
    }
}

func validationInput(_ screen: (size: CGSize, scale: Int), strategy: Strategy) -> String? {
    let pixelsCount = Int((screen.size.height * Double(screen.scale)) * (screen.size.width * Double(screen.scale)))
    
    if pixelsCount >= 56250000 {
        return "So far, such sizes are not supported"
    }
    
    if pixelsCount <= 0 {
        return "screen size <= 0"
    }
    
    if case .naive(threshold: let threshold) = strategy, !(0...pixelsCount).contains(threshold) {
        return "The threshold value for the .naive strategy does not fall within the valid pixel range. Expected a value between 0 and \(pixelsCount), but got \(threshold)."
    }
    
    if case .cluster(let threshold, _) = strategy, !(0...pixelsCount).contains(threshold) {
        return "The threshold value for the .cluster strategy does not fall within the valid pixel range. Expected a value between 0 and \(pixelsCount), but got \(threshold)."
    }
    
    if case .cluster(_, let clusterSize) = strategy, !(1...7).contains(clusterSize) {
        return "The cluster size for the .cluster strategy does not fall within the valid range (1 to 7). Got \(clusterSize)."
    }
    
    if case .perceptualTollerance(let threshold, _) = strategy, threshold < 0 {
        return "The threshold \(threshold) value for the .perceptualTollerance strategy cannot be less than zero."
    }
    
    if case .perceptualTollerance(_, let deltaE) = strategy, deltaE < 0.0 {
        return "The deltaE \(deltaE) value for the .perceptualTollerance strategy cannot be less than zero."
    }
    
    if case .perceptualTollerance(_, let deltaE) = strategy, deltaE > 100.0 {
        return "The deltaE \(deltaE) value for the .perceptualTollerance strategy cannot be great than 100."
    }
    
    if case .perceptualTollerance_v1(let threshold, _) = strategy, threshold < 0 {
        return "The threshold \(threshold) value for the .perceptualTollerance_v1 strategy cannot be less than zero."
    }
    
    if case .perceptualTollerance_v1(_, let perceptualPrecision) = strategy, perceptualPrecision < 0.0 {
        return "The perceptualPrecision \(perceptualPrecision) value for the .perceptualTollerance_v1 strategy cannot be less than zero."
    }
    
    if case .perceptualTollerance_v1(_, let perceptualPrecision) = strategy, perceptualPrecision > 1.0 {
        return "The perceptualPrecision \(perceptualPrecision) value for the .perceptualTollerance_v1 strategy cannot be great than 1.0"
    }
    
    if case .perceptualTollerance_v2(let precission, _) = strategy, precission < 0.0 {
        return "The precission \(precission) value for the .perceptualTollerance_v2 strategy cannot be less than zero."
    }
    
    if case .perceptualTollerance_v2(let precission, _) = strategy, precission > 1.0 {
        return "The precission \(precission) value for the .perceptualTollerance_v2 strategy cannot be great than 1."
    }
    
    if case .perceptualTollerance_v2(_, let perceptualPrecision) = strategy, perceptualPrecision > 1.0 {
        return "The perceptualPrecision \(perceptualPrecision) value for the .perceptualTollerance_v2 strategy cannot be great than 1.0"
    }
    
    if case .perceptualTollerance_v2(_, let perceptualPrecision) = strategy, perceptualPrecision < 0.0 {
        return "The perceptualPrecision \(perceptualPrecision) value for the .perceptualTollerance_v2 strategy cannot be less than 0.0"
    }
    
    return nil
}

enum SnapshotError: Error {
    case snapshotMismatch(description: String, diff: UIImage)
    case snapshotsSizeDoesNotEqual(description: String)
    case scaleDifference(description: String)
    case failedToCreateCGImage(snapshotName: String)
    case referenceImageNotFound(snapshotName: String)
    case failedToPrepareCGImage(description: String)
    case error(description: String)
}

@available(iOS 10.0, *)
struct Snapshot {
    static func createReferenceURL(
        name testName: String,
        class className: String,
        inDirectory directoryUrl: URL
    ) -> URL {
        directoryUrl
            .appendingPathComponent("Snapshots")
            .appendingPathComponent(className)
            .appendingPathComponent(testName)
            .appendingPathExtension("png")
    }
    
    static func createDifferenceImageURL(
        name testName: String,
        class className: String,
        inDirectory directoryUrl: URL
    ) -> URL {
        directoryUrl
            .appendingPathComponent("Difference")
            .appendingPathComponent(className)
            .appendingPathComponent(testName)
            .appendingPathExtension("diff")
            .appendingPathExtension("png")
    }
    
    static func createReferenceSnapshot(from url: URL) throws -> UIImage {
        guard let referenceSnapshotImage = UIImage(contentsOfFile: url.path) else {
            throw SnapshotError.referenceImageNotFound(snapshotName: url.lastPathComponent)
        }
        
        return referenceSnapshotImage
    }
    
    private static func set(traits: UITraitCollection, for view: UIView) {
        let size = CGRect(origin: .zero, size: view.frame.size)
        
        let window = UIWindow(frame: size)
        window.isHidden = false
        
        let viewController = UIViewController()
        viewController.view.frame = size
        viewController.view.addSubview(view)
        viewController.setOverrideTraitCollection(traits, forChild: viewController)
        
        window.rootViewController = viewController
        window.layoutIfNeeded()
    }
    
    static func renderImage(view: UIView, on screen: (size: CGSize, scale: Int)?, traits: [UITraitCollection]? = nil) throws -> UIImage {
        guard let screen else { return
            try renderImage(view: view, traits: traits)
        }
        
        view.frame = CGRect(origin: .zero, size: screen.size)
        
        if let traits {
            set(traits: UITraitCollection(traitsFrom: traits), for: view)
        } else {
            view.layoutIfNeeded()
        }
        
        let image = render(for: screen.size).image { context in
            view.layer.render(in: context.cgContext)
        }
        
        guard image.scale == CGFloat(screen.scale) else {
            throw SnapshotError.scaleDifference(description: "The scale of the selected simulator device (\(image.scale)) does not match the scale of the current selected scale: \(screen.scale). This mismatch may cause rendering differences")
        }
        
        return image
    }
    
    static func renderImage(view: UIView, traits: [UITraitCollection]? = nil) throws -> UIImage {
        guard view.frame != .zero else {
            throw SnapshotError.error(description: "The frame of the view is zero, which may indicate that it has not been properly initialized.")
        }
        
        view.layoutIfNeeded()
        
        if let traits {
            set(traits: UITraitCollection(traitsFrom: traits), for: view)
        }
        
        let image = render(for: view.frame.size).image { context in
            view.layer.render(in: context.cgContext)
        }
        
        return image
    }
    
    private static func render(for size: CGSize) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.preferredRange = .standard
        
        return UIGraphicsImageRenderer(size: size, format: format)
    }
    
    static let imageContextBytesPerPixel = 4
    
    private static let clusterKernel: ClusterKernel = try! ClusterKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLClusterKernel))
    
    static func clusterDifference(_ lhs: CGImage, _ rhs: CGImage, clusterSize: Int) throws -> Int {
        return try clusterKernel.difference(lhs: lhs, rhs: rhs, clusterSize: clusterSize)
    }
    
    private static let naiveKernel: NaiveKernel = try! NaiveKernel(with: Kernel.Configuration(metalSource: MSLNaiveKernel))
    
    static func naiveDifference(_ lhs: CGImage, _ rhs: CGImage) throws -> Int {
        return try naiveKernel.difference(lhs: lhs, rhs: rhs)
    }
    
    private static let deltaKernel: DeltaKernel = try! DeltaKernel(with: Kernel.Configuration(metalSource: MetalHeader + NaiveDiffTool + MSLDeltaE2000KernelSafe))
    
    static func deltaDifference(_ lhs: CGImage, _ rhs: CGImage, _ deltaE : Float) throws -> Int {
        return try deltaKernel.difference(lhs: lhs, rhs: rhs, tollerance: deltaE)
    }
    
    // remap colorspace
    static func normilize(cgImage: CGImage) throws -> CGContext {
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = width * imageContextBytesPerPixel
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard
            let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
            let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            )
        else {
            throw SnapshotError.failedToPrepareCGImage(description: "Failed to create bitmap context")
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return context
    }
}

private extension UIImage {
    func data() throws -> Data {
        guard let data = pngData() else {
            throw SnapshotError.error(description: "Failed to convert image to PNG data.")
        }
        
        return data
    }
}

private extension Data {
    func save(in url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try write(to: url)
    }
}

public struct SnapshotDevice {
    let size: CGSize
    let scale: Int
    
    public static let iPhone14ProMax = SnapshotDevice(size: CGSize(width: 430, height: 932), scale: 3)
    public static let iPhone14Pro = SnapshotDevice(size: CGSize(width: 393, height: 852), scale: 3)
    public static let iPhone14 = SnapshotDevice(size: CGSize(width: 390, height: 844), scale: 3)
    public static let iPhoneSE = SnapshotDevice(size: CGSize(width: 320, height: 568), scale: 2)
    public static let iPhone8 = SnapshotDevice(size: CGSize(width: 375, height: 667), scale: 2)
    public static let iPhoneX = SnapshotDevice(size: CGSize(width: 375, height: 812), scale: 3)
    public static let iPhoneXsMax = SnapshotDevice(size: CGSize(width: 414, height: 896), scale: 3)
}

public struct MismatchColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    
    public static let red = MismatchColor(red: 1.0, green: 0.0, blue: 0.0)
    public static let green = MismatchColor(red: 0.0, green: 1.0, blue: 0.0)
    public static let blue = MismatchColor(red: 0.0, green: 0.0, blue: 1.0)
}

/// Strategies for image comparison in visual testing.
///
/// Common parameters:
/// - `threshold`: Max absolute mismatched pixels allowed.
/// - `clusterSize`: Min cluster size to count mismatches (smaller clusters ignored as noise).
/// - `deltaE`: Perceptual color difference threshold (CIE Delta E).
///   0: perfect color match, 1–2: Noticeable upon close inspection, 2–10: Noticeable, 11–49: similar, 100: opposite.
/// - `precision`:  1.0 = 100%, 0.99 = 99% required images match.
/// - `perceptualPrecision`: 1.0 = 100%, 0.99 = 99% allowed perceptual match (deltaE).
public enum Strategy {
    /// Simple pixel count, no clustering, no color tolerance.
    case naive(threshold: Int = 0)
    
    /// Counts mismatches only in clusters larger than `clusterSize`, total ≤ `threshold`.
    case cluster(threshold: Int = 0, clusterSize: Int = 1)
    
    /// Combines color tolerance (deltaE) and clustering.
    case combined(threshold: Int, clusterSize: Int, deltaE: Float)
    
    /// DeltaE2000 tollerance
    case perceptualTollerance(threshold: Int = 0, deltaE: Float = 0.0)
    case perceptualTollerance_v1(threshold: Int = 0, perceptualPrecision: Float = 1.0)
    case perceptualTollerance_v2(precission: Float = 1.0, perceptualPrecision: Float = 1.0)
}

public struct SnapshotConfiguration{
    /// Size configuration (size and scale).
    public var screen: (size: CGSize, scale: Int)?
    
    /// The comparison strategy.
    public var strategy: Strategy
    
    /// The directory where reference snapshots are stored/read. (SNAPSHOT_DIFF_ARTIFACTS is most priority parameter)
    public var directoryURL: URL?
    
    /// The trait collections to apply when rendering.
    public var traits: [UITraitCollection]?
    
    /// If `true`, records a new reference snapshot instead of comparing.
    public var record: Bool
    
    /// If `true`, saves a diff image as file when snapshots don’t match.
    public var differenceRecord: Bool
    
    /// The color used to highlight mismatched areas.
    public var mismatchColor: MismatchColor
    
    /// An optional custom name for the snapshot. If `nil`, the test name is used.
    public var snapshotName: String?
    
    public init(
        screen: (size: CGSize, scale: Int)? = nil,
        strategy: Strategy = .naive(threshold: 0),
        directoryURL: URL? = nil,
        traits: [UITraitCollection]? = nil,
        record: Bool = false,
        differenceRecord: Bool = true,
        mismatchColor: MismatchColor = .green,
        snapshotName: String? = nil
    ) {
        self.screen = screen
        self.strategy = strategy
        self.directoryURL = directoryURL
        self.traits = traits
        self.record = record
        self.differenceRecord = differenceRecord
        self.mismatchColor = mismatchColor
        self.snapshotName = snapshotName
    }
}
