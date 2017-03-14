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
        static var worstComplexity: NSAttributedString {get};
    static var averageComplexity: NSAttributedString {get};
    static var bestComplexity: NSAttributedString {get};
    static var worstCase: [Int] {get};
    static var bestCase:[Int] {get};
    static func sort(unsortedArray: [Int]) -> [MoveType];

}
