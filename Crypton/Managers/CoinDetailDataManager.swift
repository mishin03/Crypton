//
//  CoinDetailDataManager.swift
//  Crypton
//
//  Created by Илья Мишин on 30.01.2023.
//

import Foundation
import Combine

/*
 URL: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
*/

class CoinDetailDataManager {
    
    @Published var coinDetails: CoinDetailsModel?
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        fetchCoinDetailsData()
    }
    
    func fetchCoinDetailsData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager.downloadUrl(url)
            .decode(type: CoinDetailsModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
