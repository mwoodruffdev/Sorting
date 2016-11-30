//
//  InsertionSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 30/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class InsertionSort: SortingAlgorithm {

    static func sort(unsortedArray: [Int]) -> [SortMove] {
        
        var copyArray = unsortedArray;
        insertionSort(a: &copyArray);
        return [];
    }
    
    private static func insertionSort(a: inout [Int]) -> [Int] {
        
        for x in 1..<a.count {
            var y = x;
            while y > 0 && a[y] < a[y-1] {
                (a[y-1], a[y]) = (a[y], a[y-1]);
                y = y - 1;
            }
        }
        return a;
    }
}
