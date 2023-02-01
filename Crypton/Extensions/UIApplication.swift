//
//  UIApplication.swift
//  Crypton
//
//  Created by Илья Мишин on 26.01.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
