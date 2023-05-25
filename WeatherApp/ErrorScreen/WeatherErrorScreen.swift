//
//  WeatherErrorScreen.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import UIKit

class WeatherErrorScreen: UIViewController {

    @IBOutlet var errorTitleLabel: UILabel! {
        didSet {
            errorTitleLabel.text = viewModel?.errorTitle ?? ""
        }
    }
    @IBOutlet var errorMessageLabel: UILabel! {
        didSet {
            errorMessageLabel.text = viewModel?.errorMessage ?? ""
        }
    }
    
    var viewModel: WeatherErrorScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


