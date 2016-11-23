//
//  MergeSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class MergeSortViewController: BaseSortingViewController {
    
    var animationMoves: [AnimationBlock]?;
    var sectionArray: [Int] = [];
    var workingArray: [Int] = [];
    
    typealias AnimationBlock  = (Animation, Int);
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        sectionArray.append(sortArray.count);
        view.backgroundColor = UIColor.yellow;
        
        
        if let sortingQueue = MergeSort.sort(unsortedArray: sortArray) as? [MergeSortMove] {
            
            animationMoves = sortCollectionView(moves: sortingQueue);
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionArray[section];
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionArray.count;
    }
    
    override func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        if let cell = cell as? SortCollectionViewCell {
            cell.backgroundColor = UIColor.black;
            
            var text: String;
            if (indexPath.section == 0) {
                text = "\(sortArray[indexPath.row])"
            } else {
                text = "\(workingArray[indexPath.row])"
            }
            cell.valueLabel.text = text
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
    
    func sortCollectionView(moves: [MergeSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .addWorking:
                let animation: Animation = {
                    
                    self.sectionArray.append(0);
                    self.sectionArray[1] = sortMove.high! - sortMove.low! + 1;
                    self.workingArray = sortMove.workingArray!;
                    
                    self.sortCollectionView.insertSections(NSIndexSet(index: 1) as! IndexSet);
                }
                let type = 0;
                let block = (animation, type);
                animationArray.append(block);
                break;
                
            case .applyColor:
                let animation: Animation = {
                    
                    let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.colorIndex!, section: 0));
                    cell?.backgroundColor = sortMove.color;
                }
                let block = (animation, 1)
                animationArray.append(block);
                break;
                
            case .swap:
                let animation: Animation = {
                    
                    let arrayIndex = sortMove.positionOne?.index;
                    let workingIndex = sortMove.positionTwo?.index
                    
                    let ip1 = IndexPath(row:workingIndex!, section: 1)
                    let ip2 = IndexPath(row: arrayIndex!, section: 0)
                    
//                    let cell = self.sortCollectionView.cellForItem(at: ip2) as? SortCollectionViewCell;
//                    cell?.valueLabel.textColor = UIColor.black
                    
                    self.sortCollectionView.moveItem(at: ip1, to: ip2);
                    self.sortCollectionView.moveItem(at: ip2, to: ip1);
                }
                let type = 0;
                let block = (animation, type);
                animationArray.append(block);
                break;
                
            case .removeWorking:
                let animation: Animation = {
                    self.sectionArray.remove(at: 1);
                    self.workingArray = [];
                    self.sortCollectionView.deleteSections(NSIndexSet(index: 1) as! IndexSet);
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
