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

    var animationMoves: [AnimationBlock]?;
    
    typealias AnimationBlock  = (Animation, Int);
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        if let sortingQueue = BubbleSort.sort(unsortedArray: sortArray) as? [BubbleSortMove] {
        
            animationMoves = sortCollectionView(moves: sortingQueue);
        }
    }
    
    override func startAnimations(index: Int) {
        
        if(index < animationMoves!.count) {
            
            let block = animationMoves![index];
            if block.1 == 0 {
                self.sortCollectionView.performBatchUpdates(animationMoves![index].0, completion: { (didFinish) in
                    if(didFinish) {
                        self.startAnimations(index: index + 1)
                    }
                })
            } else if block.1 == 1 {
                
                UIView.animate(withDuration: 1, animations: animationMoves![index].0, completion: { (didFinish) in
                    
                    if(didFinish) {
                        self.startAnimations(index: index + 1);
                    }
                })
            }
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
                        self.statusLabel.text = "is  \(sortMove.positionTwo!.value)  > \(sortMove.positionOne.value) ?";
                        self.statusLabel.textColor = UIColor.black;
                    }
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
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
                    }
                    
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
                    
                    break;
                case .swap:
                
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                        
                        self.statusLabel.text = "Yes!";
                        self.statusLabel.textColor = UIColor.green;
                    }
                    
                    let type = 0;
                    let block = (animation, type);
                    animationArray.append(block);
                    
                    break;
                case .dontSwap:
                    self.statusLabel.fadeTransition(duration: 1);
                    self.statusLabel.text = "Nope!";
                    self.statusLabel.textColor = UIColor.red;
                    break;
            }
        }
        
        return animationArray;
    }
}
