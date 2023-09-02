//
//  AGAUIImage.swift
//  Agua
//
//  Created by Muneesh Kumar on 16/01/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    /// blur image
    /// - Parameter image: actual image
    /// - Returns: blured image
    func blurImage() -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = self.imageOrientation
        let originalScale = self.scale
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(10.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        var cgImage: CGImage?
        if let asd = outputImage {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }
        if let cgImageA = cgImage {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }
        return nil
    }
}
