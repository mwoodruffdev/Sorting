//
//  QuickSortMov.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class QuickSortMove: SortMove {

    var positionOne: Position;
    var positionTwo: Position?;
    var moveType: QuickSortMoveType;
    
    init(positionOne: Position, positionTwo: Position, moveType: QuickSortMoveType) {
        
        self.positionOne = positionOne;
        self.positionTwo = positionTwo;
        self.moveType = moveType;
    }
    
    init(positionOne: Position, moveType: QuickSortMoveType) {
        
        self.positionOne = positionOne;
        self.moveType = moveType;
    }

    static func check(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .check);
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .swap);
    }
    
    static func selectSorted(positionOne: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, moveType: .selectSorted);
    }
    
    static func selectPivot(positionOne: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, moveType: .selectPivot);
    }
    
    static func selectLeftRight(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .selectLeftRight);
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

enum QuickSortMoveType {
    
    case check
    case selectLeftRight
    case swap
    case selectPivot
    case selectSorted
}
