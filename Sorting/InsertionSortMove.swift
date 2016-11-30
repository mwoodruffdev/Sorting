//
//  InsertionSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 30/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class InsertionSortMove: SortMove {

    var positionOne: Position;
    var positionTwo: Position?;
    var moveType: InsertionSortMoveType;
    
    init(positionOne: Position, positionTwo: Position?, moveType: InsertionSortMoveType) {
        
        self.positionOne = positionOne;
        self.positionTwo = positionTwo;
        self.moveType = moveType;
    }
    
    static func dontSwap(positionOne: Position, positionTwo: Position) -> InsertionSortMove {
        
        return InsertionSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .dontSwap);
    }
    
    static func sorted(positionOne: Position) -> InsertionSortMove {
        
        return InsertionSortMove(positionOne: positionOne, positionTwo: nil, moveType: .sorted);
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> InsertionSortMove {
        
        return InsertionSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .swap);
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

enum InsertionSortMoveType {
 
    case dontSwap
    case sorted
    case swap
}
