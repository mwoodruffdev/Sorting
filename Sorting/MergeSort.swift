//
//  MergeSort.swift
//  Sorting
//
//  Created by Michael Woodruff on 21/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class MergeSort: SortingAlgorithm {

    static func sort(unsortedArray: [Int]) -> [SortMove] {
        
        return [];
    }
    
    internal static func mergeSort(array: [Int]) -> [Int] {
        
        guard array.count > 1 else { return array; }
        
        let middleIndex = array.count / 2
        let leftArray = mergeSort(array: Array(array[0..<middleIndex]));
        let rightArray = mergeSort(array: Array(array[middleIndex..<array.count]));
        
        return merge(leftPile: leftArray, rightPile: rightArray)
    }
    
    internal static func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
        
        // 1
        var leftIndex = 0
        var rightIndex = 0
        
        // 2
        var orderedPile = [Int]()
        
        // 3
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            if leftPile[leftIndex] < rightPile[rightIndex] {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[rightIndex] {
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            } else {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            }
        }
        
        // 4
        while leftIndex < leftPile.count {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < rightPile.count {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
        
        return orderedPile
    }
}
