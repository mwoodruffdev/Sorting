//
//  BubbleSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSort: SortingAlgorithm {
    
    typealias MoveType = BubbleSortMove
    static var name = "Bubble Sort";
    
    static var worstComplexity = BigOhStringFormatter.bigOhOfNSquared();
    static var averageComplexity = BigOhStringFormatter.bigOhOfNSquared();
    static var bestComplexity = BigOhStringFormatter.bigOofN();
    static var worstCase: [Int] = [4, 3, 2, 1, 0];
    static var bestCase:[Int] = [0, 1, 2, 3, 4];
    
    static func sort(unsortedArray: [Int]) -> [MoveType] {
     
        var sortedAboveIndex = unsortedArray.count;
        var sortedArray = unsortedArray;
        var moves: [BubbleSortMove] = [];
        
        repeat {
            var lastSwapIndex = 0;
            for i in 1 ..< sortedAboveIndex {
                let firstPosition: BubbleSortMove.Position = BubbleSortMove.Position(index: i, value: sortedArray[i]);
                let secondPosition: BubbleSortMove.Position = BubbleSortMove.Position(index: i-1, value: sortedArray[i-1]);
                
                moves.append(BubbleSortMove.checking(positionOne: firstPosition, positionTwo: secondPosition));
                if (sortedArray[i - 1] > sortedArray[i]) {
                    swap(&sortedArray[i], &sortedArray[i-1])
                    moves.append(BubbleSortMove.swap(positionOne: firstPosition, positionTwo: secondPosition));
                    lastSwapIndex = i
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            let sortedAbovePosition: BubbleSortMove.Position = BubbleSortMove.Position(index: sortedAboveIndex, value: sortedArray[sortedAboveIndex]);
            moves.append(BubbleSortMove.sortedFrom(sortedPosition: sortedAbovePosition));
        } while (sortedAboveIndex != 0)
        
        return moves;
    }
}
