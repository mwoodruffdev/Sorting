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
                
                case .dontSwap:
                    
                    animationArray.append((checkAnimation(sortMove: sortMove), .defaultView));
                    animationArray.append((unCheckAnimation(sortMove: sortMove), .defaultView));
                    break;
                case .sorted:
                    let sortedAnimation: Animation = {
                        
                        let sortedIndex = sortMove.positionOne.index;
                        var i = sortedIndex;
                        while i >= 0 {
                            
                            let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                            cell.backgroundColor = UIColor.green;
                            cell.sorted = true;
                            i = i - 1;
                        }
                    }
                    
                    animationArray.append((sortedAnimation, .defaultView));
                    
                    break;
                case .swap:
                    
                    animationArray.append((checkAnimation(sortMove: sortMove), .defaultView));
                    
                    let swapAnimation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                        
                        //TODO: Update Log View
                    }
                    
                    animationArray.append((swapAnimation, .collectionView));
                    
                    animationArray.append((unCheckAnimation(sortMove: sortMove), .defaultView));
                    
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
    
    private func checkAnimation(sortMove: InsertionSortMove) -> Animation {
        return {
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0));
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0));
            cell1?.backgroundColor = UIColor.red;
            cell2?.backgroundColor = UIColor.red;
        }
    }
    
    private func unCheckAnimation(sortMove: InsertionSortMove) -> Animation {
        return {
            let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as! SortCollectionViewCell;
            let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as! SortCollectionViewCell;
            
            if(cell1.sorted) {
                
                cell1.backgroundColor = UIColor.green;
            } else {
                
                cell1.backgroundColor = UIColor.black;
            }
            
            if(cell2.sorted) {
                
                cell2.backgroundColor = UIColor.green;
            } else {
                
                cell2.backgroundColor = UIColor.black;
            }
        }
    }
}
