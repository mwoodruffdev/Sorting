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
        quickSort.sort();
        
        animationMoves = sortCollectionView(moves: quickSort.test as! [QuickSortMove]);
    }
    
    override func setupCollectionView(layout: UICollectionViewLayout) {
        
        sortCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        sortCollectionView.register(QuickSortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        sortCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(sortCollectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! QuickSortCollectionViewCell;
        
        cell.backgroundColor = UIColor.black;
        cell.valueLabel.text = "\(sortArray[indexPath.row])";
        return cell
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
                
                case .selectPivot:
                
                    let animation: Animation = {
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                            }
                        }
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        cell1?.isPivot = true;
                        cell1?.backgroundColor = UIColor.blue;
                    }
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
                    break;
                
                case .addWall:
                
                    let animation: Animation = {
                        
                        let leftWallCell = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        let rightWallCell = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as? QuickSortCollectionViewCell;
                        
                        leftWallCell?.leftWall.isHidden = false;
                        rightWallCell?.rightWall.isHidden = false;
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                                unHighlightedCell.hideWalls();
                            }
                        }
                    }
                    
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
                    break;
                
                case .selectLeftRight:
                
                    let animation: Animation = {
                    
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell,
                                unHighlightedCell.isPivot == false, unHighlightedCell.sorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                            }
                        }
                        
                        let leftCell = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        let rightCell = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as? QuickSortCollectionViewCell;
                        leftCell?.backgroundColor = UIColor.red;
                        rightCell?.backgroundColor = UIColor.red;
                    }
                    
                    let type = 1;
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
