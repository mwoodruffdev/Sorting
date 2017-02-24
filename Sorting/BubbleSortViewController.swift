//
//  BubbleSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSortViewController: BaseSortingViewController<BubbleSort> {
    
    override func createAnimations(moves: [BubbleSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .checking(let positionOne, let positionTwo):
                
                let checkAnimation = ViewSortAnimation({
                    let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionOne.index, section: 0));
                    cell1?.backgroundColor = .red;
                    let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionTwo.index, section: 0));
                    cell2?.backgroundColor = .red;
                    
                    for i in (0 ..< self.sortArray.count) {
                        
                        if i == positionOne.index || i == positionTwo.index {
                            continue;
                        }
                        if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SortCollectionViewCell,
                            !unHighlightedCell.isSortedCell() {
                            
                            unHighlightedCell.backgroundColor = .black;
                        }
                    }
                    
                    self.logView.insertComparison(first: positionTwo.value, second: positionOne.value, sign: ">");
                });
                
                animationArray.append(checkAnimation);
                break;
            case .sortedFrom(let position):
                
                var oldColors:[UIColor] = [];
                
                let sortedAnimation = ViewSortAnimation({
                    
                    var i = 0;
                    while i < self.sortArray.count {
                        
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                        oldColors.append(cell.backgroundColor!);
                        if(i < position.index) {
                            cell.backgroundColor = .black;
                        } else {
                            cell.backgroundColor = .green;
                        }
                        i = i + 1;
                    }
                    
                    self.logView.insertSorted(text: String(format: NSLocalizedString("logger_action_sorted_detail_from_index", comment: ""), position.index));
                });
                
                animationArray.append(sortedAnimation);
                break;
            case .swap(let positionOne, let positionTwo):
                
                let swapAnimation = CollectionViewSortAnimation({
                    self.sortCollectionView.moveItem(at: IndexPath(row: positionOne.index, section: 0), to: IndexPath(row: positionTwo.index, section: 0))
                    self.sortCollectionView.moveItem(at: IndexPath(row: positionTwo.index, section: 0), to: IndexPath(row: positionOne.index, section: 0))
                    
                    self.logView.insertSwap(first: positionTwo.index, second: positionOne.index);
                });
                
                animationArray.append(swapAnimation);
                break;
            }
        }
        
        return animationArray;
    }
}
