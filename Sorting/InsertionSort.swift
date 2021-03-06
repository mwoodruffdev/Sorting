//
//  InsertionSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 30/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class InsertionSort: SortingAlgorithm {

    typealias MoveType = InsertionSortMove
    static var name = NSLocalizedString("insertion_sort_title", comment: "");
    static var worstComplexity = BigOhStringFormatter.bigOhOfNSquared();
    static var averageComplexity = BigOhStringFormatter.bigOhOfNSquared();
    static var bestComplexity = BigOhStringFormatter.bigOofN();
    static var worstCase: [Int] = InputArrays.randomSortedArray(length: 5, ascending: false);
    static var bestCase:[Int] = InputArrays.randomSortedArray(length: 5, ascending: true);
    
    static func sort(unsortedArray: [Int]) -> [MoveType] {
        
        return insertionSort(unsortedArray: unsortedArray);
    }
    
    private static func insertionSort(unsortedArray: [Int]) -> [MoveType] {
        
        var unsortedArray = unsortedArray;
        
        var moves: [InsertionSortMove] = [];
        
        for x in 1..<unsortedArray.count {
            
            var y = x;
            if(unsortedArray[y] >= unsortedArray[y-1]) {
                moves.append(InsertionSortMove.dontSwap(positionOne: Position(index: (y-1), value: unsortedArray[y-1]), positionTwo: Position(index: y, value: unsortedArray[y])));
            }
            
            while y > 0 && unsortedArray[y] <= unsortedArray[y-1] {
                
                (unsortedArray[y-1], unsortedArray[y]) = (unsortedArray[y], unsortedArray[y-1]);
                if(unsortedArray[y] != unsortedArray[y-1]) {
                    moves.append(InsertionSortMove.swap(positionOne: Position(index: (y-1), value: unsortedArray[y-1]), positionTwo: Position(index: y, value: unsortedArray[y])));
                }
                y = y - 1;
            }

            moves.append(InsertionSortMove.sorted(positionOne: Position(index: x, value: 0)));
        }
        
        return moves;
    }
}
