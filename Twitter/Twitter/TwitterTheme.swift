//
//  TwitterTheme.swift
//  Twitter
//
//  Created by Kaushik on 10/8/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

enum TwitterTheme : Int {
    case `default`, dark
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: TwitterTheme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return TwitterTheme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default:
            return .default
        case .dark:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return  nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red:0.11, green:0.15, blue:0.22, alpha:1.0)
                //UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
                //UIColor(red:0.11, green:0.16, blue:0.17, alpha:1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    
    var screenNameColor: UIColor {
        switch self {
        case .default:
            return UIColor.darkGray
        case .dark:
            return UIColor(red:0.52, green:0.58, blue:0.63, alpha:1.0)
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
//        UIApplication.shared.delegate?.window??.tintColor = mainColor
//        
//        UINavigationBar.appearance().barStyle = barStyle
//        UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
//        
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
//        
//        UITabBar.appearance().barStyle = barStyle
//        UITabBar.appearance().backgroundImage = tabBarBackgroundImage
        
        
//        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
//        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
//        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
//        
//        let controlBackground = UIImage(named: "controlBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        
//        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        
//        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
//        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
//        
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
//        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
//        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
//        
//        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
//        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
//            .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
//        
//        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
//        
//        UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.3)
//        UISwitch.appearance().thumbTintColor = mainColor
        
//        UISegmentedControl.appearance().backgroundColor = screenNameColor
        UISegmentedControl.appearance().tintColor = backgroundColor
        UITableViewCell.appearance().backgroundColor = backgroundColor
        TwitterBGView.appearance().backgroundColor = backgroundColor
        UITextView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UITextView.appearance(whenContainedInInstancesOf: [ProfileViewController.self]).textColor = textColor

//        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance().textColor = textColor
        TwitterScreenNameLabel.appearance().textColor = screenNameColor
        UIImageView.appearance().tintColor = screenNameColor
        TwitterThemeButton.appearance().tintColor = screenNameColor
//        UIToolbar.appearance().backgroundColor = backgroundColor

    }
}
