//
//  StringHelpers.swift
//  Sorting
//
//  Created by Michael Woodruff on 16/02/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

class StringHelpers<T> {
    
    static func stringifyArray(array: [T]) -> String {
    
        var outputString = "[";
        array.forEach({
            outputString = outputString + "\($0), ";
        });
        
        let start = outputString.index(outputString.endIndex, offsetBy: -2)
        let end = outputString.index(outputString.endIndex, offsetBy: 0)
        
        return outputString.replacingCharacters(in: start..<end, with: "]");
    }
}
