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
    
    static func sort(unsortedArray: [Int]) -> [MoveType] {
        
        return insertionSort(unsortedArray: unsortedArray);
    }
    
    private static func insertionSort(unsortedArray: [Int]) -> [MoveType] {
        
        var unsortedArray = unsortedArray;
        
        var moves: [InsertionSortMove] = [];
        
        for x in 1..<unsortedArray.count {
            
            var y = x;
            if(unsortedArray[y] >= unsortedArray[y-1]) {
                moves.append(InsertionSortMove.dontSwap(positionOne: InsertionSortMove.Position(index: (y-1), value: unsortedArray[y-1]), positionTwo: InsertionSortMove.Position(index: y, value: unsortedArray[y])));
            }
            
            while y > 0 && unsortedArray[y] <= unsortedArray[y-1] {
                
                (unsortedArray[y-1], unsortedArray[y]) = (unsortedArray[y], unsortedArray[y-1]);
                if(unsortedArray[y] != unsortedArray[y-1]) {
                    moves.append(InsertionSortMove.swap(positionOne: InsertionSortMove.Position(index: (y-1), value: unsortedArray[y-1]), positionTwo: InsertionSortMove.Position(index: y, value: unsortedArray[y])));
                }
                y = y - 1;
            }

            moves.append(InsertionSortMove.sorted(positionOne: InsertionSortMove.Position(index: x - 1, value: 0)));
        }
        
        return moves;
    }
}
