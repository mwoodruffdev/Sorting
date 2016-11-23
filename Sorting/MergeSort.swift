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
        mergeSort(moves: &moves, a: &copy, low: 0, high: unsortedArray.count-1);
        
        return moves;
    }
    
    static func mergeSort(moves: inout [MergeSortMove], a: inout [Int], low: Int, high: Int) {
        
        if low == high {
            moves.append(MergeSortMove.applyColor(colorIndex: low, color: getRandomRainbowColor(total: a.count, index: low)));
            return;
        }
        
        let length = high - low + 1;
        let pivot = (low + high) / 2;
        
        mergeSort(moves: &moves, a: &a, low: low, high: pivot);
        mergeSort(moves: &moves, a: &a, low: pivot+1, high: high);
        
        var working: [Int] = []
        for i in 0..<length {
            working.append(-1)
            working[i] = a[low + i];
        }
        
        moves.append(MergeSortMove.addWorking(low: low, high: high, workingArray: working));
        var m1 = 0;
        var m2 = pivot-low+1;
        for i in 0..<length {
            
            var workingPosition: MergeSortMove.Position;
            
            if(m2 <= high-low) {
                if(m1 <= pivot - low) {
                    if(working[m1] > working[m2]) {
                        a[i+low] = working[m2];
                        workingPosition = MergeSortMove.Position(index: m2, value: working[m2]);
                        m2 += 1;
                    } else {
                        a[i+low] = working[m1];
                        workingPosition = MergeSortMove.Position(index: m1, value: working[m1]);
                        m1 += 1;
                    }
                } else {
                    a[i+low] = working[m2]
                    workingPosition = MergeSortMove.Position(index: m2, value: working[m2]);
                    m2 += 1
                }
            } else {
                a[i + low] = working[m1];
                workingPosition = MergeSortMove.Position(index: m1, value: working[m1]);
                m1 += 1;
            }
            let arrayPosition: MergeSortMove.Position = MergeSortMove.Position(index: i+low, value: a[i+low]);
            moves.append(MergeSortMove.swap(positionOne: arrayPosition, positionTwo: workingPosition));
        }
        moves.append(MergeSortMove.removeWorking());
    }
    
    static func getRandomRainbowColor(total: Int, index: Int) -> UIColor {
        
        let hue: CGFloat = CGFloat(total) / CGFloat(index);
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1);
    }
}