//
// MSLClusterKernel.swift
// AFSnapshotTesting
//
// Created by Afanasy Koryakin on 05.04.2024.
// Copyright © 2024 Afanasy Koryakin. All rights reserved.
// License: MIT License, https://github.com/afanasykoryakin/AFSnapshotTesting/blob/master/LICENSE
//

let MSLClusterKernel = """

#define BUFFER_SIZE 100

uint2 recursiveSearch(int2 buffer[BUFFER_SIZE], uint2 pixel, uint index) {
    ///full buffer. Not contains
    if (index >= BUFFER_SIZE) {
        return uint2(index, 0);
    }

    ///Not contains. Allow append
    if (buffer[index].y == -1 && buffer[index].x == -1) {
        return uint2(index, 1);
    }

    uint2 bufferValue = as_type<uint2>(int2(buffer[index].x, buffer[index].y));

    ///Contains
    if (bufferValue.x == pixel.x && bufferValue.y == pixel.y) {
        return uint2(index, 2);
    }

    return recursiveSearch(buffer, pixel, index + 1);
}

void recursiveFill(int2 buffer[BUFFER_SIZE], int2 value, uint index) {
    if (index >= BUFFER_SIZE) {
        return;
    }
    buffer[index] = value;
    recursiveFill(buffer, value, index + 1);
}

void clusterSize_7(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }

            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);

            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                }
            }
        }
    }
}

void clusterSize_6(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }

            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_7(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize_5(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }

            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_6(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize_4(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }

            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_5(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize_3(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }

            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_4(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize_2(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }
            
            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_3(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize_1(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }
            
            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_2(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

void clusterSize(texture2d<float, access::read> firstImage,
                 texture2d<float, access::read> secondImage,
                 uint2 pixel,
                 uint size[1],
                 int2 buffer[BUFFER_SIZE]) {
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            if (dx == 0 && dy == 0) {
                continue;
            }
            
            int2 check = int2(pixel.x, pixel.y) + int2(dx, dy);
            
            if (check.x < 0 || check.y < 0) {
                continue;
            }
            
            uint2 neighborPixel = pixel + uint2(dx, dy);
            
            float4 firstValue = firstImage.read(neighborPixel);
            float4 secondValue = secondImage.read(neighborPixel);
            
            bool isPixelNotEqual = !DIFF_FUNC(firstValue, secondValue);
            
            if (isPixelNotEqual) {
                uint2 result = recursiveSearch(buffer, neighborPixel, 0);
                
                uint status = result.y;
                uint index = result.x;
                
                if (status == 1) {
                    buffer[index] = int2(neighborPixel.x, neighborPixel.y);
                    size[0] = size[0] + 1;
                    clusterSize_1(firstImage, secondImage, neighborPixel, size, buffer);
                }
            }
        }
    }
}

kernel void clusterKernel(texture2d<float, access::read> inputImage1 [[texture(0)]],
                          texture2d<float, access::read> inputImage2 [[texture(1)]],
                          device atomic_uint* counter [[buffer(0)]],
                          const device uint* threshold [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= inputImage1.get_width() || gid.y >= inputImage1.get_height()) {
        return;
    }

    float4 pixel1 = inputImage1.read(gid);
    float4 pixel2 = inputImage2.read(gid);

    bool isPixelNotEqual = !DIFF_FUNC(pixel1, pixel2);

    if (isPixelNotEqual) {
        int2 buffer[BUFFER_SIZE] = { }; recursiveFill(buffer, int2(-1, -1), 0);
        buffer[0] = int2(gid.x, gid.y);

        uint size[1] = { 1 };
        clusterSize(inputImage1, inputImage2, gid, size, buffer);

        uint clusterSize = size[0];
        uint thresholdValue = *threshold;

        if (clusterSize >= thresholdValue) {
            atomic_fetch_add_explicit(counter, 1, memory_order_relaxed);
        }
    }
}

kernel void clusterKernelTextureRecord(texture2d<float, access::read> inputImage1 [[texture(0)]],
                          texture2d<float, access::read> inputImage2 [[texture(1)]],
                          texture2d<float, access::write> outputImage [[texture(2)]],
                          const device uint* threshold [[buffer(0)]],
                          constant float4& newColor [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    if (gid.x >= inputImage1.get_width() || gid.y >= inputImage1.get_height()) {
        return;
    }

    float4 pixel1 = inputImage1.read(gid);
    float4 pixel2 = inputImage2.read(gid);

    bool isPixelNotEqual = !DIFF_FUNC(pixel1, pixel2);

    if (isPixelNotEqual) {
        int2 buffer[BUFFER_SIZE] = { }; recursiveFill(buffer, int2(-1, -1), 0);
        buffer[0] = int2(gid.x, gid.y);

        uint size[1] = { 1 };
        clusterSize(inputImage1, inputImage2, gid, size, buffer);

        uint clusterSize = size[0];
        uint thresholdValue = *threshold;

        if (clusterSize >= thresholdValue) {
            outputImage.write(newColor, gid);
        } else {
            outputImage.write(pixel1, gid);
        }
    } else {
        outputImage.write(pixel1, gid);
    }
}

"""
