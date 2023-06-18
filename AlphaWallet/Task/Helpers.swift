//
//  Helpers.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 18/06/2023.
//

import UIKit
import SVGKit
import Kingfisher

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}

extension URL {
    var isSVG: Bool {
        (self.absoluteString as NSString).pathExtension == "svg"
    }
}
