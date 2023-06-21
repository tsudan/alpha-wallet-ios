//
//  UIImageView+Extension.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 17.11.2021.
//

import Foundation
import Kingfisher
import SVGKit

extension UIImageView {

    func setImage(url urlValue: URL?, placeholder: UIImage? = .none) {
        if let url = urlValue {
            let resource = ImageResource(downloadURL: url)
            var options: KingfisherOptionsInfo = []

            if let value = placeholder {
                options.append(.onFailureImage(value))
            }
            
            if url.isSVG {
                options.append( .processor(SVGImgProcessor()))
            }
            
            kf.setImage(with: resource, placeholder: placeholder, options: options)
        } else {
            image = placeholder
        }
    }
    
    func setImageWithRetry(url urlValue: URL?, altUrlValue: URL?, placeholder: UIImage? = .none) {
        if let url = urlValue {
            let resource = ImageResource(downloadURL: url)
            var options: KingfisherOptionsInfo = []

            if let value = placeholder {
                options.append(.onFailureImage(value))
            }
            
            if let altUrl = altUrlValue {
                options.append(.alternativeSources([.network(ImageResource(downloadURL: altUrl))]))
            }
            
            if url.isSVG {
                options.append( .processor(SVGImgProcessor()))
            }
            
            kf.setImage(with: resource, placeholder: placeholder, options: options)
        } else {
            image = placeholder
        }
    }
}
