//
//  WeatherHomeScreen.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import UIKit
import SwiftUI
import CoreLocation
// https://api.openweathermap.org/geo/1.0/direct?q=London&limit=2&appid=537d73fbddd2d5e904facbc0bf26849b
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

/*
 App Structure is Divided into two parts
 Top Portion -> Search bar
 Remaining Portion -> Has three states
                1.Error Screen(WeatherErrorScreen)
                2.Processing Screen(WeatherProcessingScreen)
                3.Result Screen(WeatherResultScreen)
 
*/
class WeatherHomeScreen: UIViewController {

    var viewModel: WeatherHomeScreenViewModel?
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        // Request location
        viewModel?.requestLocation()
    }
    
    func bindViewModel() {
        self.viewModel = WeatherHomeScreenViewModel(locationFinder: LocationFinderUtility(), storage: Storage(), weatherApiManager: WeatherApiManager(), actions: { [weak self] viewState in
            DispatchQueue.main.async {
                self?.handleViewStates(state: viewState)
            }
        })
    }

    /*
     shows screens based on view states
     */
    func handleViewStates(state: ViewState) {
        switch state {
        case .result(let response):
            self.showResultsScreen(response: response)
        case .error(let error):
            if error == .locationInputEmptyError {
                makeTextFieldToErrorMode()
            } else {
                self.showErrorScreen(error: error)
            }
        case .loading:
            self.showProcessingScreen()
        }
    }
    
    /*
     Show results when an app gets the data from the api
     */
    func showResultsScreen(response: WeatherResponse) {
        removeOtherChilds()
        let vc: WeatherResultScreen = Utilities.instantiateViewController(with: "WeatherResultScreen", storyboard: AppConfig.mainStoryboard, bundle: Bundle.main)
        vc.viewModel = WeatherResultScreenViewModel(response: response)
        pinViewToContainer(vc: vc)
    }
    
    /*
     Show processing screen when app uses location and calls the api
     */
    func showProcessingScreen() {
        removeOtherChilds()
        let vc: WeatherProcessingScreen = Utilities.instantiateViewController(with: "WeatherProcessingScreen", storyboard: AppConfig.mainStoryboard, bundle: Bundle.main)
        pinViewToContainer(vc: vc)
    }

    /*
     Show error screen when an error occurs in web service or a user denies the location sharing.
     */
    func showErrorScreen(error: WeatherAppError) {
        removeOtherChilds()
        let vc: WeatherErrorScreen = Utilities.instantiateViewController(with: "WeatherErrorScreen", storyboard: AppConfig.mainStoryboard, bundle: Bundle.main)
        vc.viewModel = WeatherErrorScreenViewModel(error: error)
        pinViewToContainer(vc: vc)
    }
    
    /*
     Pins child viewcontrollers to container view
     */
    func pinViewToContainer(vc: UIViewController) {
        addChild(vc)
        self.containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        AutoLayoutHelper.addAnchorConstraintsToAllSides(childView: vc.view, parentView: self.containerView)
    }
    /*
     removes previously added child controllers so that the memory can be optimized
     */
    func removeOtherChilds() {
        let viewControllers:[UIViewController] = self.children
        for viewContoller in viewControllers{
            viewContoller.willMove(toParent: nil)
            viewContoller.view.removeFromSuperview()
            viewContoller.removeFromParent()
        }
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
       let _ = handleTextFieldInput()
    }
    
    func handleTextFieldInput() {
        if viewModel?.isValidInput(text: searchField.text ?? "") ?? false {
            searchField.resignFirstResponder()
            viewModel?.callGeoCoderAPI(text: searchField.text ?? "")
        }
    }
    
    func makeTextFieldToErrorMode() {
        searchField.layer.borderColor = UIColor.red.cgColor
        searchField.layer.borderWidth = 1
        searchField.placeholder = "Please type in a location"
    }
    
    func clearTextFieldError() {
        searchField.layer.borderWidth = 0
    }
}

extension WeatherHomeScreen: UITextFieldDelegate {
    // when a user tap on search button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldInput()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if viewModel?.isValidInput(text: newString) ?? false {
            clearTextFieldError()
        } else {
            makeTextFieldToErrorMode()
        }
        return true
    }
}


