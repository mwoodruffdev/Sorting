//
//  MergeSortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 22/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class MergeSortMove: SortMove {

    var moveAnimation: ViewSortAnimation?
    var moveType: MergeSortMoveType
    
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
        
        return MergeSortMove(moveType: .addWorking(low, high, workingArray));
    }
    
    static func merge(left: [Int], right: [Int]) -> MergeSortMove {
        return MergeSortMove(moveType: .merge(left, right));
    }
    
    static func removeWorking() -> MergeSortMove {
        
        return MergeSortMove(moveType: .removeWorking);
    }
    
    static func sorted(left: [Int]) -> MergeSortMove {
        return MergeSortMove(moveType: .sorted(left));
    }
    
    static func swap(positionOne: Position, positionTwo: Position) -> MergeSortMove {
        
        return MergeSortMove(moveType: .swap(positionOne, positionTwo));
    }
}

enum MergeSortMoveType {
    
    case addWorking(Int, Int, [Int])
    case merge([Int], [Int])
    case removeWorking
    case sorted([Int])
    case swap(Position, Position);
}
