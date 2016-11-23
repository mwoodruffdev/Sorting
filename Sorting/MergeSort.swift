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
        
        var moves: [MergeSortMove] = [];
        
        var copy = unsortedArray
        javaSort(moves: &moves, a: &copy, low: 0, high: unsortedArray.count-1);
        
        return moves;
    }
    
    internal static func mergeSort(moves: inout [MergeSortMove], array: [Int], section: Int) -> [Int] {
        
//        guard array.count > 1 else { return array; }
//        
//        let middleIndex = array.count / 2
//        
//        let leftPile = Array(array[0..<middleIndex]);
//        var leftIndexPile: [Int] = [];
//        for i in 0..<middleIndex {
//            leftIndexPile.append(i);
//        }
//        
//        var rightIndexPile: [Int] = [];
//        for i in middleIndex..<array.count {
//            rightIndexPile.append(i);
//        }
//        let rightPile = Array(array[middleIndex..<array.count]);
//        
//        print("split");
//        moves.append(MergeSortMove.newSection(section: section));
//        moves.append(MergeSortMove.split(leftPile: leftIndexPile, rightPile: rightIndexPile, section: section));
//        let leftArray = mergeSort(moves: &moves, array: leftPile, section: section+1);
//        let rightArray = mergeSort(moves: &moves, array: rightPile, section: section+1);
//        
//        //Now we know left array and right array are sorted. So merge them into one sorted list
//        return merge(moves: &moves, leftPile: leftArray, rightPile: rightArray, section: section+1)
        return []
    }
    
    static func javaSort(moves: inout [MergeSortMove], a: inout [Int], low: Int, high: Int) {
        
        if low == high {
            return;
        }
        
        let length = high - low + 1;
        let pivot = (low + high) / 2;
        
        javaSort(moves: &moves, a: &a, low: low, high: pivot);
        javaSort(moves: &moves, a: &a, low: pivot+1, high: high);
        
        var working: [Int] = []
        for i in 0..<length {
            working.append(-1)
            working[i] = a[low + i];
        }
        
        moves.append(MergeSortMove.addWorking(low: low, high: high, workingArray: working));
        var m1 = 0;
        var m2 = pivot-low+1;
        for i in 0..<length {
            
            if(m2 <= high-low) {
                if(m1 <= pivot - low) {
                    if(working[m1] > working[m2]) {
                        a[i+low] = working[m2];
                        let arrayPosition: MergeSortMove.Position = MergeSortMove.Position(index: i+low, value: a[i+low]);
                        let workingPositon: MergeSortMove.Position = MergeSortMove.Position(index: m2, value: working[m2]);
                        moves.append(MergeSortMove.swap(positionOne: arrayPosition, positionTwo: workingPositon));
                        m2 += 1;
                    } else {
                        a[i+low] = working[m1];
                        let arrayPosition: MergeSortMove.Position = MergeSortMove.Position(index: i+low, value: a[i+low]);
                        let workingPositon: MergeSortMove.Position = MergeSortMove.Position(index: m1, value: working[m1]);
                        moves.append(MergeSortMove.swap(positionOne: arrayPosition, positionTwo: workingPositon));
                        m1 += 1;
                    }
                } else {
                    a[i+low] = working[m2]
                    let arrayPosition: MergeSortMove.Position = MergeSortMove.Position(index: i+low, value: a[i+low]);
                    let workingPositon: MergeSortMove.Position = MergeSortMove.Position(index: m2, value: working[m2]);
                    moves.append(MergeSortMove.swap(positionOne: arrayPosition, positionTwo: workingPositon));
                    m2 += 1
                }
            } else {
                a[i + low] = working[m1];
                
                let arrayPosition: MergeSortMove.Position = MergeSortMove.Position(index: i+low, value: a[i+low]);
                let workingPositon: MergeSortMove.Position = MergeSortMove.Position(index: m1, value: working[m1]);
                moves.append(MergeSortMove.swap(positionOne: arrayPosition, positionTwo: workingPositon));
                m1 += 1;
            }
        }
        moves.append(MergeSortMove.removeWorking());
    }
    internal static func merge(moves: inout [MergeSortMove], leftPile: [Int], rightPile: [Int], section: Int) -> [Int] {
        
        print("merge");
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedPile = [Int]()
        
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
