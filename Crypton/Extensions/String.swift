//
//  String.swift
//  Crypton
//
//  Created by Илья Мишин on 31.01.2023.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
