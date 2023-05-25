//
//  WeatherResultScreen.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import UIKit

class WeatherResultScreen: UIViewController {
    var viewModel: WeatherResultScreenViewModel?
    
    @IBOutlet var locationName: UILabel! {
        didSet {
            locationName.text = viewModel?.locationName ?? ""
        }

    }
    
    @IBOutlet var weatherImage: CachedImageView! {
        didSet {
            if let url = viewModel?.imageUrl{
                weatherImage.loadImage(url: url)
            } else {
                weatherImage.image = UIImage(named: "noimage")
            }
        }
    }
    
    @IBOutlet var currentWeatherText: UILabel! {
        didSet {
            currentWeatherText.text = viewModel?.currentTemperature ?? ""
        }
    }
    @IBOutlet var feelsLikeText: UILabel! {
        didSet {
            feelsLikeText.text = viewModel?.feelsLike ?? ""
        }
    }
    
    @IBOutlet var daysRange: UILabel! {
        didSet {
            daysRange.text = viewModel?.daysRange ?? ""
        }
    }
    
    @IBOutlet var clouds: UILabel! {
        didSet {
            clouds.text = viewModel?.clouds ?? ""
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
