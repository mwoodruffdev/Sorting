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

    override func viewDidLoad() {
        super.viewDidLoad();
    
        if let sortingQueue = QuickSort.sort(unsortedArray: sortArray) as? [QuickSortMove] {
            animationMoves = sortCollectionView(moves: sortingQueue);
        }
    }
    
    override func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        layout.itemSize = CGSize(width: 30, height: 60)
        
        return layout;
    }
    
    override func setupCollectionView(layout: UICollectionViewLayout) {
        
        sortCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        sortCollectionView.register(QuickSortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        sortCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(sortCollectionView)
    }
    
    override func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        
        if let cell = cell as? QuickSortCollectionViewCell {
            cell.backgroundColor = UIColor.black;
            cell.valueLabel.text = "\(sortArray[indexPath.row])";
        }
    }
    
    func sortCollectionView(moves: [QuickSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
                case .check:
                    
                    let animation: Animation = {
                        
                        self.logView.insertNewLine(text: "Is \(sortMove.positionOne.value) <= \(sortMove.positionTwo!.value)?", color: UIColor.red);
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                
                case .dontSwap:
                    let dontSwapAnimation = {
                        
                        self.logView.insertNewLine(text: "NO!", color: UIColor.black);
                    }
                    
                    animationArray.append((dontSwapAnimation, .collectionView));
                    
                    break;
                
                case .pivotSwap:
                    
                    let textAnimation: Animation = {
                        self.logView.insertNewLine(text: "Right pointer has reached the pivot. Swap with the pivot", color: UIColor.black);
                    }
                    
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    }
                    
                    animationArray.append((textAnimation, .defaultView));
                    animationArray.append((animation, .collectionView));
                    break;
                
                case .swap:
                
                    let textAnimation: Animation = {
                        if(sortMove.positionOne.index != sortMove.positionTwo?.index) {
                            self.logView.insertNewLine(text: "YES! Swap the Left and Right pointers", color: UIColor.black);
                        } else {
                            self.logView.insertNewLine(text: "YES!", color: UIColor.black);
                        }
                    }
                    
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    }
                    
                    animationArray.append((textAnimation, .defaultView));
                    animationArray.append((animation, .collectionView));
                    break;
                
                case .incrementLeft:
                    let incrementLeftAnimation: Animation = {
                        self.logView.insertNewLine(text: "Increment Left", color: UIColor.black);
                    }
                    
                    animationArray.append((incrementLeftAnimation, .defaultView));
                    break;
                case .incrementRight:
                    let incrementRightAnimation: Animation = {
                        self.logView.insertNewLine(text: "Increment Right", color: UIColor.black);
                    }
                    
                    animationArray.append((incrementRightAnimation, .defaultView));
                    break;
                
                case .selectPivot:
                
                    let animation: Animation = {
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell, unHighlightedCell.isSorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                                unHighlightedCell.resetLR();
                            }
                        }
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        cell1?.isPivot = true;
                        cell1?.backgroundColor = UIColor.blue;
                        
                        self.logView.insertNewLine(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index)) is the pivot", color: UIColor.blue);
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                
                case .selectLeftRight:
                
                    let animation: Animation = {

                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell,
                                unHighlightedCell.isPivot == false, unHighlightedCell.isSorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                                unHighlightedCell.resetLR();
                            }
                        }
                        
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as? QuickSortCollectionViewCell;
                        
                        if(sortMove.positionOne.index == sortMove.positionTwo!.index) {
                        
                            self.logView.insertNewLine(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index)) is the left and right pointer", color: UIColor.orange);
                            cell1?.setAsLAndR();
                            cell1?.backgroundColor = UIColor.orange;
                        } else {
                        
                            cell1?.setAsL();
                            self.logView.insertNewLine(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index)) is the left pointer", color: UIColor.orange);
                            
                            cell2?.setAsR();
                            self.logView.insertNewLine(text: "\(sortMove.positionTwo!.value) (index \(sortMove.positionTwo!.index)) is the right pointer", color: UIColor.orange);
                            
                            cell1?.backgroundColor = UIColor.orange;
                            cell2?.backgroundColor = UIColor.orange;
                        }
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                
            case .selectSorted:
                    let animation: Animation = {
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell,
                                unHighlightedCell.isPivot == false, unHighlightedCell.isSorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                                unHighlightedCell.resetLR();
                            }
                        }
                        
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        cell1?.isSorted = true;
                        cell1?.backgroundColor = UIColor.green;
                        
                        self.logView.insertNewLine(text: "\(sortMove.positionOne.value) (index \(sortMove.positionTwo?.index) is now sorted", color: UIColor.green);
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
        return "O(n log n)";
    }
    
    override func bestCaseText() -> String {
        return "O(n log n)";
    }
}

extension UIView {
    func fadeTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionFade)
    }
}
