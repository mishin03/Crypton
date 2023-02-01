//
//  ChartView.swift
//  Crypton
//
//  Created by Илья Мишин on 30.01.2023.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endDate = Date(coinString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    for index in data.indices {
                        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        let yAxis = maxY - minY
                        let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 5, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.5), radius: 5, x: 0, y: 5)
                .shadow(color: lineColor.opacity(0.2), radius: 5, x: 0, y: 15)
                .shadow(color: lineColor.opacity(0.1), radius: 5, x: 0, y: 25)
            }
            .frame(height: 200)
            .background(
                VStack {
                    Divider()
                    Spacer()
                    Divider()
                    Spacer()
                    Divider()
                }
            )
            .overlay(
                VStack(alignment: .leading) {
                    Text(maxY.formattedWithAbbreviations())
                    Spacer()
                    Text(((maxY + minY) / 2).formattedWithAbbreviations())
                    Spacer()
                    Text(minY.formattedWithAbbreviations())
                }
                    .padding(.horizontal, 4)
                ,alignment: .leading
            )
            HStack {
                Text(startDate.asShortDateString())
                Spacer()
                Text(endDate.asShortDateString())
            }
            .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}
