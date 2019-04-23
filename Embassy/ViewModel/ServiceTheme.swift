//
//  ServiceTheme.swift
//  Embassy
//
//  Created by Nacho González Miró on 06/04/2019.
//  Copyright © 2019 Nacho González Miró. All rights reserved.
//

import UIKit

enum Theme: Int{
    case `default`, dark, graphical
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor{
        switch self {
        case .default:
            return UIColor(red: 85.0/255.0, green: 190.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 14.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 1.0)
            
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .graphical:
            return .default
        case .dark:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .graphical ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .graphical ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundCellColor : UIColor {
        switch self {
        case .default, .graphical:
            return UIColor.white
        case .dark:
            return UIColor(white: 0.4, alpha: 1.0)
        }
    }
    
    var textCellColor: UIColor{
        switch self {
        case .default, .graphical:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    
    func apply(){
        //General
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        
        //UINavigationBar
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        //UITabBar
        UITabBar.appearance().barStyle = barStyle
        UITabBar.appearance().backgroundImage = tabBarBackgroundImage
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets:
            UIEdgeInsets(top:0, left: 5.0, bottom: 0, right: 5.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        //UISegmentedControl
        let controlBackground = UIImage(named: "controlBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top:3, left:3, bottom:3, right:3))
        
        let selectedControlBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top:3, left:3, bottom:3, right:3))
        
        UISegmentedControl.appearance()
            .setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        
        UISegmentedControl.appearance()
            .setBackgroundImage(selectedControlBackground, for: .selected, barMetrics: .default)
        
        //UISwitch
        UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.4)
        UISwitch.appearance().thumbTintColor = mainColor
        
        //UITableViewCell
        UITableViewCell.appearance().backgroundColor = backgroundCellColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textCellColor
    }
}
