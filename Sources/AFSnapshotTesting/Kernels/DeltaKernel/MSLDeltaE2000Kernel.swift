//
// MSLDeltaE2000Kernel.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 23.03.2025.
// Copyright © 2025 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE

let MSLDeltaE2000KernelSafe = """

#define M_PI  3.14159265358979323846f
#define M_PI_2 1.57079632679489661923f

// Safe square root function
// Ensures sqrt(x) does not receive a negative input, which would result in NaN.
// If x is negative, it returns a small nonzero value instead of NaN.

float safe_sqrt(float x, float eps = 1e-6f) {
    return (x >= 0.0f) ? sqrt(x) : sqrt(fabs(x)) * eps;
}

// Safe division function
// Prevents division by zero, which would result in NaN or infinity.
// If the denominator is too close to zero, it returns the maximum floating-point value
// with the same sign as the numerator to maintain mathematical consistency.

float safe_div(float num, float denom, float eps = 1e-6f) {
    return (fabs(denom) > eps) ? (num / denom) : copysign(FLT_MAX, num);
}

// Safe atan2 function
// Prevents undefined behavior when both x and y are zero, which would result in NaN.
// If both inputs are very close to zero, it returns a small epsilon value instead.

float safe_atan2(float y, float x, float eps = 1e-6f) {
    return (fabs(y) < eps && fabs(x) < eps) ? eps : atan2(y, x);
}

float hypot(float a, float b) {
    return sqrt(a * a + b * b);
}

float ciede_2000(float l_1, float a_1, float b_1, float l_2, float a_2, float b_2) {
    // Working with the CIEDE2000 color-difference formula.
    // k_l, k_c, k_h are parametric factors to be adjusted according to
    // different viewing parameters such as textures, backgrounds...

    const float k_l = 1.0f, k_c = 1.0f, k_h = 1.0f;
    float n = (hypot(a_1, b_1) + hypot(a_2, b_2)) * 0.5f;
    n = n * n * n * n * n * n * n; // n^7

    // A factor involving chroma raised to the power of 7 designed to make
    // the influence of chroma on the total color difference more accurate.

    n = 1.0f + 0.5f * (1.0f - safe_sqrt(n / (n + 6103515625.0f)));

    // hypot calculates the Euclidean distance while avoiding overflow/underflow.
    float c_1 = hypot(a_1 * n, b_1);
    float c_2 = hypot(a_2 * n, b_2);

    // atan2 is preferred over atan because it accurately computes the angle of
    // a point (x, y) in all quadrants, handling the signs of both coordinates.

    float h_1 = safe_atan2(b_1, a_1 * n);
    float h_2 = safe_atan2(b_2, a_2 * n);

    h_1 += (h_1 < 0.0f) ? 2.0f * M_PI : 0.0f;
    h_2 += (h_2 < 0.0f) ? 2.0f * M_PI : 0.0f;

    float delta_h = fabs(h_2 - h_1);
    delta_h = (delta_h > M_PI - 1e-14f && delta_h < M_PI + 1e-14f) ? M_PI : delta_h;

    float h_m = 0.5f * h_1 + 0.5f * h_2;
    float h_d = (h_2 - h_1) * 0.5f;

    float should_adjust = float(delta_h > M_PI); // 1.0 true, 0.0 false
    float h_d_sign = (h_d > 0.0f) ? -1.0f : 1.0f;

    h_d += should_adjust * h_d_sign * M_PI;
    h_m += should_adjust * M_PI;

    float c_avg = (c_1 + c_2) * 0.5f;
    float c_avg_pow7 = c_avg * c_avg * c_avg * c_avg * c_avg * c_avg * c_avg;

    float p = (36.0f * h_m - 55.0f * M_PI);
    float r_t = -2.0f * safe_sqrt(c_avg_pow7 / (c_avg_pow7 + 6103515625.0f))
                      * sin(M_PI / 3.0f * exp(p * p / (-25.0f * M_PI * M_PI)));

    float l_avg = (l_1 + l_2) * 0.5f;
    l_avg = (l_avg - 50.0f) * (l_avg - 50.0f);

    // Lightness.
    float l_diff = safe_div(l_2 - l_1, k_l * (1.0f + 0.015f * l_avg / safe_sqrt(20.0f + l_avg)));

    // These coefficients adjust the impact of different harmonic
    // components on the hue difference calculation.

    float t = 1.0f
              + 0.24f * sin(2.0f * h_m + M_PI_2)
              + 0.32f * sin(3.0f * h_m + 8.0f * M_PI / 15.0f)
              - 0.17f * sin(h_m + M_PI / 3.0f)
              - 0.20f * sin(4.0f * h_m + 3.0f * M_PI_2 / 10.0f);

    // Hue.
    float h_diff = safe_div(2.0f * safe_sqrt(c_1 * c_2) * sin(h_d), k_h * (1.0f + 0.0075f * (c_1 + c_2) * t));

    // Chroma.
    float c_diff = safe_div(c_2 - c_1, k_c * (1.0f + 0.0225f * (c_1 + c_2)));

    return safe_sqrt(l_diff * l_diff + c_diff * c_diff + h_diff * h_diff + r_t * c_diff * h_diff);
}

constant constexpr float gamma_threshold = 0.0404482362771082f;
constant constexpr float gamma_coeff = 2.4f;
constant constexpr float refX = 95.047f;
constant constexpr float refY = 100.0f;
constant constexpr float refZ = 108.883f;

inline float3 rgb_to_xyz(float3 rgb) {
    // Gamma correction
    float3 linear = select(rgb / 12.92f, pow((rgb + 0.055f) / 1.055f, gamma_coeff), rgb > gamma_threshold);

    // Matrix convert
    float3 xyz = float3(0.0f, 0.0f, 0.0f);
    xyz.x = 100.0f * (linear.x * 0.4124564390896921f +
                      linear.y * 0.357576077643909f +
                      linear.z * 0.18043748326639894f);

    xyz.y = 100.0f * (linear.x * 0.21267285140562248f +
                      linear.y * 0.715152155287818f +
                      linear.z * 0.07217499330655958f);

    xyz.z = 100.0f * (linear.x * 0.019333895582329317f +
                      linear.y * 0.119192025881303f +
                      linear.z * 0.9503040785363677f);
    
    return xyz;
}

inline float3 xyz_to_lab(float3 xyz) {
    // Normalize to white point
    xyz /= float3(refX, refY, refZ);
    
    // Nonlinear transformation
    constexpr float epsilon = 216.0f / 24389.0f;
    constexpr float kappa = 841.0f / 108.0f;
    constexpr float offset = 4.0f / 29.0f;
    
    xyz = select(
        (kappa * xyz) + offset,
        pow(xyz, 1.0f/3.0f),
        xyz > epsilon
    );
    
    return float3(
        116.0f * xyz.y - 16.0f,    // L
        500.0f * (xyz.x - xyz.y),   // a
        200.0f * (xyz.y - xyz.z)    // b
    );
}

inline float3 rgb_to_lab(float3 rgb) {
    return xyz_to_lab(rgb_to_xyz(rgb));
}

kernel void deltaKernel(texture2d<float, access::read> inputImage1 [[texture(0)]],
                          texture2d<float, access::read> inputImage2 [[texture(1)]],
                          device atomic_uint* counter [[buffer(0)]],
                          const device float* tollerance [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= inputImage1.get_width() || gid.y >= inputImage1.get_height()) {
        return;
    }

    float4 pixel1 = inputImage1.read(gid);
    float4 pixel2 = inputImage2.read(gid);

    float3 lab1 = rgb_to_lab(float3(pixel1.r, pixel1.g, pixel1.b));
    float3 lab2 = rgb_to_lab(float3(pixel2.r, pixel2.g, pixel2.b));

    float deltaE = ciede_2000(lab1.r, lab1.g, lab1.b, lab2.r, lab2.g, lab2.b);
    float tolleranceValue = *tollerance;

    float eps = 0.00001f;
    int value = int((deltaE > tolleranceValue) & (deltaE > eps));
    atomic_fetch_add_explicit(counter, value, memory_order_relaxed);
}

kernel void deltaKernelTextureRecord(texture2d<float, access::read> inputImage1 [[texture(0)]],
                          texture2d<float, access::read> inputImage2 [[texture(1)]],
                          texture2d<float, access::write> outputImage [[texture(2)]],
                          const device float* tollerance [[buffer(0)]],
                          constant float4& newColor [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= inputImage1.get_width() || gid.y >= inputImage1.get_height()) {
        return;
    }

    float4 pixel1 = inputImage1.read(gid);
    float4 pixel2 = inputImage2.read(gid);

    float3 lab1 = rgb_to_lab(float3(pixel1.r, pixel1.g, pixel1.b));
    float3 lab2 = rgb_to_lab(float3(pixel2.r, pixel2.g, pixel2.b));

    float deltaE = ciede_2000(lab1.r, lab1.g, lab1.b, lab2.r, lab2.g, lab2.b);
    float tolleranceValue = *tollerance;

    float eps = 0.00001f;
    int isPixelNotEqual = int((deltaE > tolleranceValue) & (deltaE > eps));

    if (isPixelNotEqual == 1) {
        outputImage.write(newColor, gid);
    } else {
        outputImage.write(pixel1, gid);
    }
}
"""
