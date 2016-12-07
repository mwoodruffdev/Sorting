//
//  SortingAlgorithm.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation

import UIKit

protocol SortingAlgorithm {
    
    associatedtype MoveType: SortMove;
    static func sort(unsortedArray: [Int]) -> [MoveType];
}
