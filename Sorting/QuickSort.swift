//
//  QuickSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

class QuickSort: SortingAlgorithm {

    var unsortedArray: [Int];
    var pivotLoc: Int = 0;

    var test:[SortMove] = [];
    
    init(unsortedArray: [Int]) {
        
        self.unsortedArray = unsortedArray;
    }
    
    func sort() -> [SortMove] {
        
        guard unsortedArray.count > 1 else {
            return [];
        }
        
        quicksort(v: &unsortedArray, low: 0, high: unsortedArray.count - 1);
        return [];
    }
    
    func quicksort(v: inout [Int], low: Int, high: Int) {
        
        if low < high {
            let pivot = partition(v: &v, low: low, high: high)
            quicksort(v: &v, low: low, high: pivot - 1)
            quicksort(v: &v, low: pivot + 1, high: high)
        }
    }
    
    func partition(v: inout [Int], low: Int, high: Int) -> Int {

        let pivot = v[high]
        
        var i = low
        for j in low..<high {
            if v[j] <= pivot {
                (v[i], v[j]) = (v[j], v[i])
  
                let firstPosition: QuickSortMove.Position = QuickSortMove.Position(index: i, value: v[i]);
                let secondPosition: QuickSortMove.Position = QuickSortMove.Position(index: j, value: v[j]);
                test.append(QuickSortMove(positionOne: firstPosition, positionTwo: secondPosition, moveType: .swap));
                i += 1
            }
        }
        
        (v[i], v[high]) = (v[high], v[i])
        
        let firstPosition: QuickSortMove.Position = QuickSortMove.Position(index: i, value: v[i]);
        let secondPosition: QuickSortMove.Position = QuickSortMove.Position(index: high, value: v[high]);
        test.append(QuickSortMove(positionOne: firstPosition, positionTwo: secondPosition, moveType: .swap));
            
        return i
    }
}
