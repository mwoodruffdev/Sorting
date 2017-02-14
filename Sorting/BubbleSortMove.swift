//
//  BubbleSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

struct BubbleSortMove: SortMove {
    
    var moveAnimation: ViewSortAnimation?;
    var moveType: BubbleSortMoveType;
    
    init(moveType: BubbleSortMoveType) {
        self.moveType = moveType;
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> BubbleSortMove {
        return BubbleSortMove(moveType: .swap(positionOne, positionTwo));
    }

    static func checking(positionOne: Position, positionTwo: Position) -> BubbleSortMove {
        return BubbleSortMove(moveType: .checking(positionOne, positionTwo));
    }
    
    static func sortedFrom(sortedPosition: Position) -> BubbleSortMove {
        return BubbleSortMove(moveType: .sortedFrom(sortedPosition));
    }
}

enum BubbleSortMoveType {
    
    case swap(Position, Position)
    case checking(Position, Position)
    case sortedFrom(Position)
}
