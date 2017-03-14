//
//  InputArrays.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/02/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

class InputArrays {
    
    static func randomInputArray(length: Int) -> [Int] {
        var tempArray = [Int]();
        
        for _ in 0...length-1 {
            let randomNumber = Int(arc4random_uniform(50));
            tempArray.append(randomNumber);
        }
        return tempArray;
    }
    
    static func randomSortedArray(length: Int, ascending: Bool) -> [Int] {
     
        let array = randomInputArray(length: length);
        return array.sorted {
            if(ascending) {
                return $0 < $1;
            } else {
                return $1 < $0;
            }
        }
    }
}
