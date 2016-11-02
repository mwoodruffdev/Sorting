//
//  BubbleSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

struct BubbleSortMove: SortMove {

    var positionOne: Position;
    var positionTwo: Position?;
    var moveType: BubbleSortMoveType;
    
    init(positionOne: Position, moveType: BubbleSortMoveType) {
    
        self.positionOne = positionOne;
        self.moveType = moveType;
    }
    
    init(positionOne: Position, positionTwo: Position, moveType: BubbleSortMoveType) {
        
        self.positionOne = positionOne;
        self.positionTwo = positionTwo;
        self.moveType = moveType;
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> BubbleSortMove {
        
        return BubbleSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .swap);
    }
    
    static func checking(positionOne: Position, positionTwo: Position) -> BubbleSortMove {
        
        return BubbleSortMove(positionOne: positionOne, positionTwo: positionTwo, moveType: .checking);
    }
    
    static func sortedFrom(sortedPosition: Position) -> BubbleSortMove {
        
        return BubbleSortMove(positionOne: sortedPosition, moveType: .sortedFrom);
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

enum BubbleSortMoveType {
    
    case swap
    case checking
    case sortedFrom
}
