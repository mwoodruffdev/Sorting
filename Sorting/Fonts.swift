//
//  Fonts.swift
//  Sorting
//
//  Created by Michael Woodruff on 24/02/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var standardFont: UIFont { return roboto(size: 16) };
    static var actionButtonFont: UIFont { return roboto(size: 12) };
    
    static func roboto(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!;
    }
}
