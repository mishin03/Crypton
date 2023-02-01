//
//  CoinImageManager.swift
//  Crypton
//
//  Created by Илья Мишин on 24.01.2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageManager {
    
    @Published var image: UIImage? = nil
    
    private var imageSubsciption: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubsciption = NetworkingManager.downloadUrl(url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self, let downloadImage = returnedImage else { return }
                self.image = downloadImage
                self.imageSubsciption?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
