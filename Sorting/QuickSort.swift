//
//  QuickSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

class QuickSort: SortingAlgorithm {

    var test:[SortMove] = [];
    
    static func sort(unsortedArray: [Int]) -> [SortMove] {
        
        var unsortedCopy = unsortedArray;
        
        guard unsortedArray.count > 1 else {
            return [];
        }
        
        var moves: [QuickSortMove] = [];
        quicksort(moves: &moves, v: &unsortedCopy, low: 0, high: unsortedArray.count - 1);
        
        return moves;
    }
    
    private static func quicksort(moves: inout [QuickSortMove], v: inout [Int], low: Int, high: Int) {
        
        if low < high {
            
            let pivot = partition(moves: &moves, v: &v, low: low, high: high)
            quicksort(moves: &moves, v: &v, low: low, high: pivot - 1)
            quicksort(moves: &moves, v: &v, low: pivot + 1, high: high)
        } else if low == high {
            
            let sortedPosition: QuickSortMove.Position = QuickSortMove.Position(index: low, value: v[low]);
            moves.append(QuickSortMove(positionOne: sortedPosition, moveType: .selectSorted));
        }
    }
    
    internal static func partition(moves: inout [QuickSortMove], v: inout [Int], low: Int, high: Int) -> Int {
        
        let pivot = v[high]
        let selectPivot: QuickSortMove.Position = QuickSortMove.Position(index: high, value: pivot);
        moves.append(QuickSortMove.selectPivot(positionOne: selectPivot));
        
        var left = low
        for right in low..<high {
            
            let leftPosition: QuickSortMove.Position = QuickSortMove.Position(index: left, value: v[left]);
            let rightPosition: QuickSortMove.Position = QuickSortMove.Position(index: right, value: v[right]);
            
            //Highlight the left / right positions
            moves.append(QuickSortMove.selectLeftRight(positionOne: leftPosition, positionTwo: rightPosition));
            moves.append(QuickSortMove.check(positionOne: rightPosition, positionTwo: selectPivot));
            
            if v[right] <= pivot {
                (v[left], v[right]) = (v[right], v[left])
  
                //Yes. So swap
                moves.append(QuickSortMove(positionOne: leftPosition, positionTwo: rightPosition, moveType: .swap));
                moves.append(QuickSortMove.incrementLeft(positionOne: leftPosition));
                left += 1
            } else {
                
                moves.append(QuickSortMove(positionOne: leftPosition, positionTwo: rightPosition, moveType: .dontSwap));
            }
            
            moves.append(QuickSortMove.incrementRight(positionOne: rightPosition));
        }
        
        (v[left], v[high]) = (v[high], v[left])
        
        let leftPosition: QuickSortMove.Position = QuickSortMove.Position(index: left, value: v[left]);
        let pivotPosition: QuickSortMove.Position = QuickSortMove.Position(index: high, value: v[high]);
        
        moves.append(QuickSortMove(positionOne: leftPosition, positionTwo: pivotPosition, moveType: .pivotSwap));
        moves.append(QuickSortMove(positionOne: leftPosition, moveType: .selectSorted));
        
        return left
    }
}
