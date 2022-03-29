//
//  Factories.swift
//  Spotify
//
//  Created by Alperen Selçuk on 9.02.2022.
//  Copyright © 2022 Alperen Selçuk. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let spotifyGreen = UIColor(red: 30 / 255, green: 215 / 255, blue: 96 / 255, alpha: 1.0)
    static let spotifyBlack = UIColor(red: 12 / 255, green: 12 / 255, blue: 12 / 255, alpha: 1)
}


func makeStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = axis
    stack.spacing = 0.8
    
    return stack
}
