//
//  Colors.swift
//  Sorting
//
//  Created by Michael Woodruff on 16/02/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var standardLogTextColor: UIColor { return .black };
    static var sortedLogTextColor: UIColor { return .green }
    static var comparisonLogTextColor: UIColor { return .red }
    static var pivotLogTextColor: UIColor { return .blue }
    static var leftRightPointerTextColor: UIColor { return .orange }
    
    static func getRandomRainbowColor(index: Int) -> UIColor {
        
        let hue = CGFloat(Int(arc4random() % 256)) / 256;
        let saturation = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        let brightness = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1);
    }
}
