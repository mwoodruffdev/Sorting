//
//  MergeSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 22/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class MergeSortMove: SortMove {

    var positionOne: Position?;
    var positionTwo: Position?;
    var low: Int?
    var high: Int?
    var workingArray: [Int]?
    var moveType: MergeSortMoveType;
    var colorIndex: Int?;
    var color: UIColor?;
    
    init(moveType: MergeSortMoveType) {
        
        self.moveType = moveType;
    }
    
    init(positionOne: Position, positionTwo: Position, moveType: MergeSortMoveType) {
        
        self.positionOne = positionOne;
        self.positionTwo = positionTwo;
        self.moveType = moveType;
    }
    
    init(positionOne: Position, moveType: MergeSortMoveType) {
        
        self.positionOne = positionOne;
        self.moveType = moveType;
    }
    
    init(low: Int, high: Int, workingArray:[Int], moveType: MergeSortMoveType) {
        
        self.low = low;
        self.high = high;
        self.workingArray = workingArray;
        self.moveType = moveType;
    }
    
    init(colorIndex: Int, color: UIColor, moveType: MergeSortMoveType) {
        self.colorIndex = colorIndex;
        self.color = color;
        self.moveType = moveType;
    }
    
    static func addWorking(low: Int, high: Int, workingArray: [Int]) -> MergeSortMove {
        return MergeSortMove(low: low, high: high, workingArray: workingArray, moveType: .addWorking);
    }
    
    static func applyColor(colorIndex: Int, color: UIColor) -> MergeSortMove {
        return MergeSortMove(colorIndex: colorIndex, color: color, moveType: .applyColor);
    }
    
    static func removeWorking() -> MergeSortMove {
        
        return MergeSortMove(moveType: .removeWorking);
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> MergeSortMove {
        
        return MergeSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .swap);
    }
    
    struct Position {
        
        var index: Int;
        var value: Int;
        
        init(index: Int, value: Int) {
            
            self.index  = index;
            self.value = value;
        }
    }
}

enum MergeSortMoveType {
    
    case addWorking
    case applyColor
    case removeWorking
    case swap;
}