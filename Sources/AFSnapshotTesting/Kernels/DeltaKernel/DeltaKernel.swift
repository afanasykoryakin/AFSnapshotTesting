//
// DeltaKernel.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 23.03.2025.
// Copyright © 2025 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE
//

import MetalKit

class DeltaKernel: Kernel {
    init(with configuration: Kernel.Configuration) throws {
        try super.init(with: configuration, function: "deltaKernel")
    }

    func difference(lhs: CGImage, rhs: CGImage, tollerance deltaE: Float) throws -> Int {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            throw KernelError.createCommandBuffer
        }

        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            throw KernelError.createCommandEncoder
        }

        guard let counterBuffer = device.makeBuffer(length: MemoryLayout<uint>.size, options: .storageModeShared) else {
            throw KernelError.createCounterBuffer
        }

        do {
            let texture1 = try textureLoader.newTexture(cgImage: lhs, options: options)
            let texture2 = try textureLoader.newTexture(cgImage: rhs, options: options)

            computeEncoder.setComputePipelineState(pipelineState)
            computeEncoder.setTexture(texture1, index: 0)
            computeEncoder.setTexture(texture2, index: 1)
            computeEncoder.setBuffer(counterBuffer, offset: 0, index: 0)

            var tollerance = deltaE
            let tolleranceKernelBuffer = device.makeBuffer(bytes: &tollerance, length: MemoryLayout<Double>.size, options: [])
            computeEncoder.setBuffer(tolleranceKernelBuffer, offset: 0, index: 1)

            let width = pipelineState.threadExecutionWidth
            let height = pipelineState.maxTotalThreadsPerThreadgroup / width
            let threadsPerThreadgroup = MTLSizeMake(width, height, 1)
            let threadsPerGrid = MTLSize(width: texture1.width, height: texture1.height, depth: 1)

            computeEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
            computeEncoder.endEncoding()
        } catch {
            computeEncoder.endEncoding()
            throw error
        }

        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        let resultPointer = counterBuffer.contents().bindMemory(to: uint.self, capacity: 1)
        let differenceCount = resultPointer.pointee

        return Int(differenceCount)
    }
}
