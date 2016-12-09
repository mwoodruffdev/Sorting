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
    static var name: String {get};
    static var worstComplexity: String {get};
    static var averageComplexity: String {get};
    static var bestComplexity: String {get};
    
    static func sort(unsortedArray: [Int]) -> [MoveType];

}
