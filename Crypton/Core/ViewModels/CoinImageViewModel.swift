//
//  CoinImageViewModel.swift
//  Crypton
//
//  Created by Илья Мишин on 24.01.2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let imageManager: CoinImageManager
    private var cancellabels = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageManager = CoinImageManager(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        imageManager.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellabels)
    }
}
