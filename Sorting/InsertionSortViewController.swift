//
//  InsertionSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class InsertionSortViewController: BaseSortingViewController {
    
    
    override func viewDidLoad() {
        
        if let sortingQueue = InsertionSort.sort(unsortedArray: sortArray) as? [InsertionSortMove] {
            
            animationMoves = sortCollectionView(moves: sortingQueue);
        }
        
        super.viewDidLoad();
    }

    func sortCollectionView(moves: [InsertionSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        for sortMove in moves {
            switch(sortMove.moveType) {
                case .swap:
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                        
                        self.statusLabel.text = "Yes!";
                        self.statusLabel.textColor = UIColor.green;
                    }
                    
                    animationArray.append((animation, .collectionView));
                    break;
                default:
                    break;
            }
        }
        
        return animationArray;
    }
    
    override func worstCaseText() -> String {
        return "O(n^2)";
    }
    
    override func averageCaseText() -> String {
        return "O(n^2)";
    }
    
    override func bestCaseText() -> String {
        return "O(n)";
    }
}
