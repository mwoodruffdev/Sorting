//
//  InsertionSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class InsertionSortViewController: BaseSortingViewController<InsertionSort> {

    override func createAnimations(moves: [InsertionSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        for sortMove in moves {
            switch(sortMove.moveType) {
                
                case .dontSwap(let positionOne, let positionTwo):
                    
                    animationArray.append(checkAnimation(positionOne: positionOne, positionTwo: positionTwo));
                    animationArray.append(unCheckAnimation(positionOne: positionOne, positionTwo: positionTwo, didSwap: true));
                    break;
                case .sorted(let sortedPosition):
                    let sortedAnimation = ViewSortAnimation({
                        
                        let sortedIndex = sortedPosition.index;
                        var i = sortedIndex;
                        while i >= 0 {
                            
                            let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                            cell.backgroundColor = .green;
                            cell.sorted = true;
                            i = i - 1;
                        }
                        
                        self.logView.insertSorted(text: String(format: NSLocalizedString("logger_action_sorted_detail_up_to_index", comment: ""), sortedPosition.index));
                    });
                    
                    animationArray.append(sortedAnimation);
                    
                    break;
                case .swap(let positionOne, let positionTwo):
                    
                    animationArray.append(checkAnimation(positionOne: positionOne, positionTwo: positionTwo));
                    
                    let swapAnimation = CollectionViewSortAnimation({
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: positionOne.index, section: 0), to: IndexPath(row: positionTwo.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: positionTwo.index, section: 0), to: IndexPath(row: positionOne.index, section: 0))
                    });
                    
                    animationArray.append(swapAnimation);
                    animationArray.append(unCheckAnimation(positionOne: positionOne, positionTwo: positionTwo, didSwap: true));
                    
                    break;
            }
        }
        
        return animationArray;
    }
    
    private func checkAnimation(positionOne: Position, positionTwo: Position) -> SortAnimation {
        return ViewSortAnimation({
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionOne.index, section: 0));
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionTwo.index, section: 0));
            cell1?.backgroundColor = .red;
            cell2?.backgroundColor = .red;
            
            self.logView.insertComparison(first: positionOne.value, second: positionTwo.value, sign: "<=");
        });
    }
    
    private func unCheckAnimation(positionOne: Position, positionTwo: Position, didSwap: Bool) -> SortAnimation {
        return ViewSortAnimation({
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionOne.index, section: 0)) as! SortCollectionViewCell;
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionTwo.index, section: 0)) as! SortCollectionViewCell;
            
            if(cell1.sorted) {
                
                cell1.backgroundColor = .green;
            } else {
                
                cell1.backgroundColor = .black;
            }
            
            if(cell2.sorted) {
                
                cell2.backgroundColor = .green;
            } else {
                
                cell2.backgroundColor = .black;
            }
            
            if(!didSwap) {
                self.logView.insertNewLine(text: NSLocalizedString("no", comment: ""), color: .black);
            } else {
                self.logView.insertNewLine(text: NSLocalizedString("yes", comment: ""), color: .black);
            }
        });
    }
}
