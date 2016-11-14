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
    
    static func swap(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .swap);
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
    
    case swap
    case checking
    case sortedFrom
}
