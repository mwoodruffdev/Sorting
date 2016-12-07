//
//  SortingController.swift
//  Sorting
//
//  Created by Michael Woodruff on 07/12/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

protocol SortingController {
    
    associatedtype Algorithm: SortingAlgorithm
    
    func createAnimations(moves: [Algorithm.MoveType]) -> [SortAnimation];
}
