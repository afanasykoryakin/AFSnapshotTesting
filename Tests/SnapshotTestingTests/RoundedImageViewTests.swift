//
// RoundedImageViewTests.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 16.02.2025.
// Copyright © 2025 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE
//

import XCTest
import AFSnapshotTesting

class RoundedImageViewTests: XCTestCase {
    func testRoundedImageView() {
        let imageView = createRoundedImageView(cornerRadius: 100)
        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageView")
    }

    func testRoundedImageViewWithBorder() {
        let imageView = createRoundedImageView(cornerRadius: 100)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageViewWithBorder")
    }

    func testRoundedImageViewWithTransparency() {
        let imageView = createRoundedImageView(cornerRadius: 100)
        imageView.alpha = 0.5
        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageViewWithTransparency")
    }

    func testRoundedImageViewWithShadow() {
        let imageView = createRoundedImageView(cornerRadius: 100)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageViewWithShadow")
    }

    func testRoundedImageViewWithGradientMask() {
        let imageView = createRoundedImageView(cornerRadius: 100)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        let maskLayer = CALayer()
        maskLayer.frame = imageView.bounds
        maskLayer.addSublayer(gradientLayer)

        imageView.layer.mask = maskLayer

        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageViewWithGradientMask")
    }

    func testRoundedImageViewWithLayerMask() {
        let imageView = createRoundedImageView(cornerRadius: 100)

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.bounds
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 50).cgPath
        imageView.layer.mask = shapeLayer

        assertSnapshot(imageView, on: (size: CGSize(width: 200, height: 200), scale: 3), named: "RoundedImageViewWithLayerMask")
    }

    func testRoundedImageViewWithLayerMask_as_perceptualTollerance() {
        let imageView = createRoundedImageView(cornerRadius: 100)

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.bounds
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 50).cgPath
        imageView.layer.mask = shapeLayer
        let size = (size: CGSize(width: 200, height: 200), scale: 3)

        assertSnapshot(imageView,on: size, as: .perceptualTolerance(threshold: 0, deltaE: 0.0))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance(threshold: 0, deltaE: 100.0))
        
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 0, perceptualPrecision: 1.0))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 0, perceptualPrecision: 0.998))
        
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 0.5, perceptualPrecision: 0.5))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 0.9999, perceptualPrecision: 0.99998))
    }

    func testRoundedImageViewWithMismatch_as_perceptualTollerance() {
        let imageView = createRoundedImageView(cornerRadius: 100)

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = imageView.bounds
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 50).cgPath
        imageView.layer.mask = shapeLayer
        let size = (size: CGSize(width: 200, height: 200), scale: 3)

        assertSnapshot(imageView, on: size, as: .perceptualTolerance(threshold: 2439, deltaE: 0.0))
        assertSnapshot(imageView, on: size, as: .perceptualTolerance(threshold: 0, deltaE: 8.0))

        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 2439, perceptualPrecision: 1.0))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 2439, perceptualPrecision: 0.999))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 1895, perceptualPrecision: 0.98))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 1723, perceptualPrecision: 0.97))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 1605, perceptualPrecision: 0.96))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v1(threshold: 0, perceptualPrecision: 0.2))

        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 0.95, perceptualPrecision: 1.0))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 0.98, perceptualPrecision: 0.999))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 1.0, perceptualPrecision: 0.94))
        assertSnapshot(imageView,on: size, as: .perceptualTolerance_v2(precision: 1.0, perceptualPrecision: 0.2))
    }

    // MARK: - Helper

    private func createRoundedImageView(cornerRadius: CGFloat) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = UIImage(systemName: "person.circle.fill") // SF Symbol как пример
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
}
