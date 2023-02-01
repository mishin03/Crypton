//
//  MarketDataManager.swift
//  Crypton
//
//  Created by Илья Мишин on 26.01.2023.
//

import Foundation
import SwiftUI
import Combine

class MarketDataManager {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.downloadUrl(url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.marketData = returnedData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
