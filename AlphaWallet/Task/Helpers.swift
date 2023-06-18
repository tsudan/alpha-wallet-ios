//
//  Helpers.swift
//  AlphaWallet
//
//  Created by Sudan Tuladhar on 18/06/2023.
//

import UIKit
import SVGKit
import Kingfisher
import AlphaWalletFoundation

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

extension ServersCoordinator {
    static var serversOrderedAsTasked: [RPCServer] {
        let startingSequence = ["Fantom Opera", "Binance (BSC)", "Polygon Mainnet"]
        
        return RPCServer.availableServers.sorted().sorted { (a, b) -> Bool in
            if let startingA = startingSequence.firstIndex(of: a.displayName),
                let startingB = startingSequence.firstIndex(of: b.displayName) {
                return startingA < startingB
            } else if let _ = startingSequence.firstIndex(of: a.displayName) {
                return true
            } else if let _ = startingSequence.firstIndex(of: b.displayName) {
                return false
            } else {
                return a.displayName < b.displayName
            }
        }
    }
}
