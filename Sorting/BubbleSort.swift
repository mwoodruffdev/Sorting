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
    
    func sort() -> [BubbleSortMove] {
    
        var sortedAboveIndex = unsortedArray.count;
        var sortedArray = unsortedArray;
        var moveArray: [BubbleSortMove] = [];
        
        repeat {
            var lastSwapIndex = 0;
            for i in 1 ..< sortedAboveIndex {
                let firstPosition: BubbleSortMove.Position = BubbleSortMove.Position(index: i, value: sortedArray[i]);
                let secondPosition: BubbleSortMove.Position = BubbleSortMove.Position(index: i-1, value: sortedArray[i-1]);
                
                moveArray.append(BubbleSortMove.checking(positionOne: firstPosition, positionTwo: secondPosition));
                if (sortedArray[i - 1] > sortedArray[i]) {
                    swap(&sortedArray[i], &sortedArray[i-1])
                    moveArray.append(BubbleSortMove.swap(positionOne: firstPosition, positionTwo: secondPosition));
                    lastSwapIndex = i
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            let sortedAbovePosition: BubbleSortMove.Position = BubbleSortMove.Position(index: sortedAboveIndex, value: sortedArray[sortedAboveIndex]);
            moveArray.append(BubbleSortMove.sortedFrom(sortedPosition: sortedAbovePosition));
        } while (sortedAboveIndex != 0)
        
        
        return moveArray;
    }
}
