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
    static var navBarColor: UIColor { return UIColor(netHex: 0x212121) }
    static var mainBGColor: UIColor { return UIColor(netHex: 0x303030) }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func getRandomRainbowColor(index: Int) -> UIColor {
        
        let hue = CGFloat(Int(arc4random() % 256)) / 256;
        let saturation = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        let brightness = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1);
    }
}
