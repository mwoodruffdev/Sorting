//
//  BubbleSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSortViewController: BaseSortingViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        title = "Bubble Sort";
        if let sortingQueue = BubbleSort.sort(unsortedArray: sortArray) as? [BubbleSortMove] {
        
            animationMoves = sortCollectionView(moves: sortingQueue);
        }
    }
    
    func sortCollectionView(moves: [BubbleSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];

        for sortMove in moves {

            switch(sortMove.moveType) {

                case .checking:
                    let animation: Animation = {
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0));
                        cell1?.backgroundColor = UIColor.red;
                        let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0));
                        cell2?.backgroundColor = UIColor.red;
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SortCollectionViewCell,
                            unHighlightedCell.sorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                            }
                        }
                        
                        self.logView.insertNewLine(text: "Is \(sortMove.positionTwo!.value) > \(sortMove.positionOne.value)?", color: UIColor.red);
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                case .sortedFrom:

                    let animation: Animation = {
                        
                        let sortedIndex = sortMove.positionOne.index;
                        
                        var i = 0;
                        while i < self.sortArray.count {
                            
                            let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                            if(i < sortedIndex) {
                                cell.backgroundColor = UIColor.black;
                                cell.sorted = false;
                            } else {
                                cell.backgroundColor = UIColor.green;
                                cell.sorted = true;
                            }
                            i = i + 1;
                        }
                        
                        self.logView.insertNewLine(text: "The list is now sorted from index \(sortMove.positionOne.index)", color: UIColor.green);
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                case .swap:
                
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                        
                        self.logView.insertNewLine(text: "YES! Swap index \(sortMove.positionTwo!.index) and index \(sortMove.positionOne.index)", color: UIColor.black);
                    }
                    
                    animationArray.append((animation, .collectionView));
                    break;
                case .dontSwap:
                    //TODO: Log View
                    let animation: Animation = {
                        
                        self.logView.insertNewLine(text: "NO!", color: UIColor.black);
                    }
                    animationArray.append((animation, .defaultView));
                    
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
