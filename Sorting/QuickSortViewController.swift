//
//  QuickSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class QuickSortViewController: BaseSortingViewController {
    
    typealias Animation = () -> Void
    typealias AnimationBlock  = (Animation, Int);
    var animationMoves: [AnimationBlock]?;

    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.green;
        
        let quickSort: QuickSort = QuickSort(unsortedArray: sortArray);
        let sortingQueue = quickSort.sort();
        
        if let testQueue = quickSort as? QuickSort {
            print(testQueue.test);
        }
        
        animationMoves = sortCollectionView(moves: quickSort.test as! [QuickSortMove]);
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
    
    func sortCollectionView(moves: [QuickSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
                case .swap:
                    
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    }
                    
                    let type = 0;
                    let block = (animation, type);
                    animationArray.append(block);
                    
                    break;
                default:
                    break;
            }
        }
        
        return animationArray;
    }
}
