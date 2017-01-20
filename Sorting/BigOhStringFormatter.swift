//
//  BigOhStringFormatter.swift
//  Sorting
//
//  Created by Michael Woodruff on 20/01/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

class BigOhStringFormatter {

    static func bigOhOfNSquared() -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: "O(n2)");
        attributedString.addAttributes([NSBaselineOffsetAttributeName : 5], range: NSMakeRange(3,1));
        return NSAttributedString(attributedString: attributedString);
    }
    
    static func bigOofN() -> NSAttributedString {
        return NSAttributedString(string: "O(n)");
    }
    
    static func bigOhOfNLogN() -> NSAttributedString {
        return NSAttributedString(string: "O(n Log n)");
    }
}
