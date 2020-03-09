//
//  UIImage+Extensions.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImage {
  static func resizeImage(originalImage: UIImage, rect: CGRect) -> UIImage {
    let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
    let size = CGSize(width: rect.width, height: rect.height)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
      originalImage.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
