//
//  QuickSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class QuickSort: SortingAlgorithm {
    
    typealias MoveType = QuickSortMove
    static var name = NSLocalizedString("quick_sort_title", comment: "");
    static var worstComplexity = BigOhStringFormatter.bigOhOfNSquared();
    static var averageComplexity = BigOhStringFormatter.bigOhOfNLogN();
    static var bestComplexity = BigOhStringFormatter.bigOhOfNLogN();
    static var worstCase: [Int] = [0, 1, 2, 3, 4];
    static var bestCase:[Int] = [4, 3, 2, 1, 0];
    
    static func sort(unsortedArray: [Int]) -> [MoveType] {
        
        var unsortedCopy = unsortedArray;
        
        guard unsortedArray.count > 1 else {
            return [];
        }
        
        var moves: [MoveType] = [];
        quicksort(moves: &moves, v: &unsortedCopy, low: 0, high: unsortedArray.count - 1);
        
        return moves;
    }
    
    private static func quicksort(moves: inout [QuickSortMove], v: inout [Int], low: Int, high: Int) {
        
        if low < high {
            
            let pivot = partition(moves: &moves, v: &v, low: low, high: high)
            quicksort(moves: &moves, v: &v, low: low, high: pivot - 1)
            quicksort(moves: &moves, v: &v, low: pivot + 1, high: high)
        } else if low == high {
            
            let sortedPosition: Position = Position(index: low, value: v[low]);
            moves.append(QuickSortMove.selectSorted(positionOne: sortedPosition));
        }
    }
    
    internal static func partition(moves: inout [QuickSortMove], v: inout [Int], low: Int, high: Int) -> Int {
        
        let pivot = v[high]
        let selectPivot: Position = Position(index: high, value: pivot);
        moves.append(QuickSortMove.selectPivot(positionOne: selectPivot));
        
        var left = low
        for right in low..<high {
            
            let leftPosition: Position = Position(index: left, value: v[left]);
            let rightPosition: Position = Position(index: right, value: v[right]);
            
            //Highlight the left / right positions
            moves.append(QuickSortMove.selectLeftRight(positionOne: leftPosition, positionTwo: rightPosition));
            moves.append(QuickSortMove.check(positionOne: rightPosition, positionTwo: selectPivot));
            
            if v[right] <= pivot {
                (v[left], v[right]) = (v[right], v[left])
  
                moves.append(QuickSortMove.swap(positionOne: leftPosition, positionTwo: rightPosition));
                left += 1
            } else {
                
                moves.append(QuickSortMove.dontSwap(positionOne: leftPosition, positionTwo: rightPosition));
            }
        }
        
        (v[left], v[high]) = (v[high], v[left])
        
        let leftPosition: Position = Position(index: left, value: v[left]);
        let pivotPosition: Position = Position(index: high, value: v[high]);
        
        moves.append(QuickSortMove.pivotSwap(positionOne: leftPosition, pivotPosition: pivotPosition));
        moves.append(QuickSortMove.selectSorted(positionOne: leftPosition));
        
        return left
    }
}
