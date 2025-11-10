//
// CombinedKernel.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 10.11.2025.
// Copyright © 2025 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE
//

let MetalHeader = """

    #include <metal_stdlib>
    using namespace metal;

"""

let NaiveDiffTool = """

    #ifndef DIFF_FUNC
    #define DIFF_FUNC naiveDiffPixels
    #endif

    inline bool naiveDiffPixels(float4 pixel1, float4 pixel2) { 
        return ((pixel1.r == pixel2.r) && (pixel1.g == pixel2.g) && (pixel1.b == pixel2.b) && (pixel1.a == pixel2.a)); 
    }

"""

func deltaDiffTool(with tollerance: Float) -> String {
    """

    \(MSLDeltaE2000KernelSafe)

    #ifndef DIFF_FUNC
    #define DIFF_FUNC deltaEDiffPixels
    #endif

    bool deltaEDiffPixels(float4 pixel1, float4 pixel2) {
        float3 lab1 = rgb_to_lab(float3(pixel1.r, pixel1.g, pixel1.b));
        float3 lab2 = rgb_to_lab(float3(pixel2.r, pixel2.g, pixel2.b));
    
        float deltaE = ciede_2000(lab1.r, lab1.g, lab1.b, lab2.r, lab2.g, lab2.b);
        float tollerance = \(tollerance);

        float eps = 0.00001f;
        return !((deltaE > tollerance) & (deltaE > eps));
    }

    """
}
