//
//  Filter.swift
//  Ampel Pilot
//
//  Created by Андрей Гавриков on 28.02.2022.
//  Copyright © 2022 Patrick Valenta. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage

class Filter {
    static let cicontext = CIContext()

    static func mani(buffer: CVImageBuffer) -> CVPixelBuffer? {

        let cameraImage = CIImage(cvImageBuffer: buffer)

        if let colorMatrixFilter = CIFilter(name: "CIColorMatrix") {
            let r:CGFloat = 1
            let g:CGFloat = 1
            let b:CGFloat = 0
            let a:CGFloat = 1

            colorMatrixFilter.setDefaults()
            colorMatrixFilter.setValue(cameraImage, forKey:"inputImage")
            colorMatrixFilter.setValue(CIVector(x:r, y:0, z:0, w:0), forKey:"inputRVector")
            colorMatrixFilter.setValue(CIVector(x:0, y:g, z:0, w:0), forKey:"inputGVector")
            colorMatrixFilter.setValue(CIVector(x:0, y:0, z:b, w:0), forKey:"inputBVector")
            colorMatrixFilter.setValue(CIVector(x:0, y:0, z:0, w:a), forKey:"inputAVector")

            if let ciimage = colorMatrixFilter.outputImage {
                Filter.cicontext.render(ciimage, to: buffer)
                return buffer
            }
        }

        return nil
    }

    static func rotate(_ pixelBuffer: CVImageBuffer, orientation: CGImagePropertyOrientation) -> CVPixelBuffer? {
            var newPixelBuffer: CVPixelBuffer?
            let error = CVPixelBufferCreate(kCFAllocatorDefault,
                                            CVPixelBufferGetHeight(pixelBuffer),
                                            CVPixelBufferGetWidth(pixelBuffer),
                                            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                            nil,
                                            &newPixelBuffer)
            guard error == kCVReturnSuccess else {
                return nil
            }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(orientation)
            let context = CIContext(options: nil)
            context.render(ciImage, to: newPixelBuffer!)
            return newPixelBuffer
        }
}
