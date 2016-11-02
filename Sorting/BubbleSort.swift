//
//  BubbleSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

class BubbleSort: NSObject {
    
    var unsortedArray: [Int];
    
    init(unsortedArray: [Int]) {
        
        self.unsortedArray = unsortedArray;
    }
    
    func sort() -> [BubbleSortMoves] {
    
        var sortedAboveIndex = unsortedArray.count;
        var sortedArray = unsortedArray;
        var moveArray: [BubbleSortMoves] = [];
        
        repeat {
            var lastSwapIndex = 0;
            for i in 1 ..< sortedAboveIndex {
            
                if (sortedArray[i - 1] > sortedArray[i]) {
                    swap(&sortedArray[i], &sortedArray[i-1])
                    moveArray.append(.swap);
                    lastSwapIndex = i
                }
            }
             sortedAboveIndex = lastSwapIndex
        } while (sortedAboveIndex != 0)
        
        print("unsorted array: \(unsortedArray)");
        print("sorted array: \(sortedArray)");
        return moveArray;
    }
    
    
}
