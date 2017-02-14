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
    var moveAnimation: ViewSortAnimation?;
    var moveType: MergeSortMoveType;
    
    var low: Int?
    var high: Int?
    var left: [Int]?
    var right: [Int]?
    var workingArray: [Int]?
    var colorIndex: Int?;
    var color: UIColor?;
    
    init(moveType: MergeSortMoveType) {
        self.moveType = moveType;
    }

    static func addWorking(low: Int, high: Int, workingArray: [Int]) -> MergeSortMove {
        let move: MergeSortMove = MergeSortMove(moveType: .addWorking);
        move.low = low;
        move.high = high;
        move.workingArray = workingArray;
        return move;
    }
    
    static func merge(left: [Int], right: [Int]) -> MergeSortMove {
        let move = MergeSortMove(moveType: .merge);
        move.left = left;
        move.right = right;
        return move;
    }
    
    static func removeWorking() -> MergeSortMove {
        
        return MergeSortMove(moveType: .removeWorking);
    }
    
    static func sorted(left: [Int]) -> MergeSortMove {
        let move = MergeSortMove(moveType: .sorted);
        move.left = left;
        return move;
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> MergeSortMove {
        
        let move = MergeSortMove(moveType: .swap);
        move.positionOne = positionOne;
        move.positionTwo = positionTwo;
        return move;
    }
}

enum MergeSortMoveType {
    
    case addWorking
    case merge
    case removeWorking
    case sorted
    case swap;
}
