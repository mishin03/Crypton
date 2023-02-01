//
//  HomeViewModel.swift
//  Crypton
//
//  Created by Илья Мишин on 23.01.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var coins = [CoinModel]()
    @Published var portfolioCoins = [CoinModel]()
    @Published var searchText = ""
    @Published var isLoading: Bool = false
    @Published var statistic: [StatisticModel] = []
    @Published var sortOption: SortOption = .holdings
    
    private let dataManager = CoinDataManager()
    private let marketDataManager = MarketDataManager()
    private let portfolioDataManager = PortfolioDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // Update Coins
        $searchText
            .combineLatest(dataManager.$coins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.coins = returnedCoins
            }
            .store(in: &cancellables)
        // Update Portfolio Coins
        $coins
            .combineLatest(portfolioDataManager.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels.compactMap { coin in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                    
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { returnedCoins in
                self.portfolioCoins = self.sortPortfolio(coins: returnedCoins)
            }
            .store(in: &cancellables)
        // Update Market Data
        marketDataManager.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketData, portfolioCoins) -> [StatisticModel] in
                var statistic: [StatisticModel] = []

                guard let data = marketData else { return statistic}
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)

                let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
                let previousValue = portfolioCoins.map({ (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H / 100
                    let previousValue = currentValue / (1 + percentChange)

                    return previousValue
                }).reduce(0, +)

                let percentChange = ((portfolioValue - previousValue) / previousValue) * 100
                let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.toCurrency(), percentageChange: percentChange)

                statistic.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])

                return statistic
            }
            .sink { [weak self] (returnedStat) in
                self?.statistic = returnedStat
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
        
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let textLowecased = text.lowercased()
        
        let resultCoins = coins.filter { coin in
            return coin.name.lowercased().contains(textLowecased) ||
            coin.symbol.lowercased().contains(textLowecased) ||
            coin.id.lowercased().contains(textLowecased)
        }
        return resultCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolio(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    func reloadData() {
        isLoading = true
        dataManager.fetchCoinData()
        marketDataManager.fetchData()
        HapticManager.notification(type: .success)
    }
    
    func updatePortfolio(_ coin: CoinModel, amount: Double) {
        portfolioDataManager.updatePortfolio(coin, amount: amount)
    }
}
