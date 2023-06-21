//
//  ImageView.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 06.03.2023.
//

import Foundation
import AlphaWalletFoundation
import Combine
import Kingfisher

enum ImageViewError: Error {
    case imageReadError(error: Error)
}

class ImageView: UIImageView {
    private let subject: PassthroughSubject<ImagePublisher, Never> = .init()
    private var cancellable = Set<AnyCancellable>()

    var hideWhenImageIsNil: Bool = false

    init() {
        super.init(frame: .zero)
        bind()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }

    private func bind() {
        subject
            .flatMapLatest { $0 }
            .sink { [weak self] image in
                switch image {
                case .url(let url):
                    switch url {
                    case .origin(let url):
                        self?.setImageWithRetry(url: url, altUrlValue: URL(string: url.absoluteString.replacingOccurrences(of: "-I.svg", with: ".svg")), placeholder: R.image.iconsTokensPlaceholder())
                    default:
                        break
                    }
                case .image(let image):
                    self?.image = image
                case .none:
                    break
                }

                if self?.hideWhenImageIsNil ?? false {
                    self?.isHidden = image == nil
                }
            }.store(in: &cancellable)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(imageSource: ImagePublisher) {
        subject.send(imageSource)
    }
}
