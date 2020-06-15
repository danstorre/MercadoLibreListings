//
//  DownSampler.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum DownSamplerMethods {
    static func downsample(imageAt imageURL: URL,
                              to pointSize: CGSize? = CGSize(width: 100, height: 100),
                              scale: CGFloat? = 3) -> UIImage? {
           let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
           guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else{
               return nil
           }
           var downsampleOptions: CFDictionary
           if let pointSize = pointSize,
               let scale = scale {
               let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
               downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                    kCGImageSourceShouldCacheImmediately: true,
                                    kCGImageSourceCreateThumbnailWithTransform: true,
                                    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
           }else {
               downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
                                    kCGImageSourceShouldCacheImmediately: kCFBooleanTrue,
                                    kCGImageSourceCreateThumbnailWithTransform: kCFBooleanTrue] as CFDictionary
           }
           let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
           return UIImage(cgImage: downsampledImage)
       }
}
