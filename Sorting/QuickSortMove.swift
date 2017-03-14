//
//  QuickSortMov.swift
//  Sorting
//
//  Created by Michael Woodruff on 14/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class QuickSortMove: SortMove {

    var moveAnimation: ViewSortAnimation?
    var moveType: QuickSortMoveType
    
    init(moveType: QuickSortMoveType) {
        
        self.moveType = moveType;
    }

    static func check(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(moveType: .check(positionOne, positionTwo));
    }
    
    static func dontSwap(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        return QuickSortMove(moveType: .dontSwap(positionOne, positionTwo));
    }
    
    static func pivotSwap(positionOne: Position, pivotPosition: Position) -> QuickSortMove {
        return QuickSortMove(moveType: .pivotSwap(positionOne, pivotPosition));
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(moveType: .swap(positionOne, positionTwo));
    }
    
    static func selectSorted(positionOne: Position) -> QuickSortMove {
        
        return QuickSortMove(moveType: .selectSorted(positionOne));
    }
    
    static func selectPivot(positionOne: Position) -> QuickSortMove {
        
        return QuickSortMove(moveType: .selectPivot(positionOne));
    }
    
    static func selectLeftRight(positionOne: Position, positionTwo: Position) -> QuickSortMove {
        
        return QuickSortMove(moveType: .selectLeftRight(positionOne, positionTwo));
    }
}

enum QuickSortMoveType {
    
    case check(Position, Position)
    case dontSwap(Position, Position)
    case pivotSwap(Position, Position)
    case swap(Position, Position)
    case selectSorted(Position)
    case selectLeftRight(Position, Position)
    case selectPivot(Position)
}
