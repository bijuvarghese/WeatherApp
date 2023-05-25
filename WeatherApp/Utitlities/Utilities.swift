//
//  File.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation
import UIKit
class Utilities {
    /*
     a generic function to load a viewcontroller from story board and returns the type same as that of the assigning variable
     */
    static func instantiateViewController<T>(with identifier: String, storyboard: String, bundle: Bundle) -> T {
        
        guard let viewController = UIStoryboard(name: storyboard, bundle: bundle).instantiateViewController(withIdentifier: identifier) as? T else { fatalError() }
        return viewController
    }
}


