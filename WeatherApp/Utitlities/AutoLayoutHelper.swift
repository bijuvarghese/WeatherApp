//
//  AutoLayoutHelper.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation
import UIKit

class AutoLayoutHelper {
    class func addAnchorConstraintsToAllSides(childView: UIView, parentView: UIView) {
        let leftConstraint = childView.leftAnchor.constraint(equalTo: parentView.leftAnchor)
        let rightConstraint = childView.rightAnchor.constraint(equalTo: parentView.rightAnchor)
        let topConstraint = childView.topAnchor.constraint(equalTo: parentView.topAnchor)
        let bottomConstaint = childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstaint])
    }
}


