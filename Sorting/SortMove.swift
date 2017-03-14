//
//  SortMove.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

protocol SortMove {
    
    associatedtype MoveType    
    var moveAnimation: ViewSortAnimation? {get set};
    var moveType: MoveType {get set};
}

struct Position {
    
    var index: Int;
    var value: Int;
    
    init(index: Int, value: Int) {
        
        self.index  = index;
        self.value = value;
    }
}
