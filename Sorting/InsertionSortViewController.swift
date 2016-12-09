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
                
                case .dontSwap:
                    
                    animationArray.append(checkAnimation(sortMove: sortMove));
                    animationArray.append(unCheckAnimation(sortMove: sortMove, didSwap: true));
                    break;
                case .sorted:
                    let sortedAnimation = ViewSortAnimation({
                        
                        let sortedIndex = sortMove.positionOne.index;
                        var i = sortedIndex;
                        while i >= 0 {
                            
                            let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                            cell.backgroundColor = UIColor.green;
                            cell.sorted = true;
                            i = i - 1;
                        }
                        
                        self.logView.insertNewLine(text: "The list is now sorted from index 0 to index \(sortMove.positionOne.index)", color: .black);
                    });
                    
                    animationArray.append(sortedAnimation);
                    
                    break;
                case .swap:
                    
                    animationArray.append(checkAnimation(sortMove: sortMove));
                    
                    let swapAnimation = CollectionViewSortAnimation({
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    });
                    
                    animationArray.append(swapAnimation);
                    animationArray.append(unCheckAnimation(sortMove: sortMove, didSwap: true));
                    
                    break;
            }
        }
        
        return animationArray;
    }
    
    private func checkAnimation(sortMove: InsertionSortMove) -> SortAnimation {
        return ViewSortAnimation({
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0));
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0));
            cell1?.backgroundColor = UIColor.red;
            cell2?.backgroundColor = UIColor.red;
            
            self.logView.insertNewLine(text: "Is \(sortMove.positionOne.value) <= \(sortMove.positionTwo!.value)?", color: .red);
        });
    }
    
    private func unCheckAnimation(sortMove: InsertionSortMove, didSwap: Bool) -> SortAnimation {
        return ViewSortAnimation({
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as! SortCollectionViewCell;
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as! SortCollectionViewCell;
            
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
                self.logView.insertNewLine(text: "NO!", color: .black);
            } else {
                self.logView.insertNewLine(text: "YES!", color: .black);
            }
        });
    }
}
