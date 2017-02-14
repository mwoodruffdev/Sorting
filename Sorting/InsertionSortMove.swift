//
//  InsertionSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 30/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class InsertionSortMove: SortMove {

    var moveType: InsertionSortMoveType;
    var moveAnimation: ViewSortAnimation?
    
    init(moveType: InsertionSortMoveType) {
        
        self.moveType = moveType;
    }
    
    static func dontSwap(positionOne: Position, positionTwo: Position) -> InsertionSortMove {
        
        return InsertionSortMove(moveType: .dontSwap(positionOne, positionTwo));
    }
    
    static func sorted(positionOne: Position) -> InsertionSortMove {
        
        return InsertionSortMove(moveType: .sorted(positionOne));
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> InsertionSortMove {
        
        return InsertionSortMove(moveType: .swap(positionOne, positionTwo));
    }
}

enum InsertionSortMoveType {
 
    case dontSwap(Position, Position)
    case sorted(Position)
    case swap(Position, Position)
}
