//
//  Color.swift
//  Crypton
//
//  Created by Илья Мишин on 20.01.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let backgound = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    let accent = Color("AccentColor")
}
