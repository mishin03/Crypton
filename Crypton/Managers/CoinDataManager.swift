//
//  CoinDataManager.swift
//  Crypton
//
//  Created by Илья Мишин on 23.01.2023.
//

import Foundation
import Combine

/*
 1)
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 2) Work
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h
 
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=249&page=1&sparkline=true&price_change_percentage=24h
 */

class CoinDataManager {
    
    @Published var coins = [CoinModel]()
    
    var coinSubscription: AnyCancellable?
    
    init() {
        fetchCoinData()
    }
    
    func fetchCoinData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkingManager.downloadUrl(url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.coins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
