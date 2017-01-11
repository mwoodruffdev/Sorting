//
//  QuickSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class QuickSortViewController: BaseSortingViewController<QuickSort> {
    
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
        sortCollectionView.backgroundColor = .white
        self.view.addSubview(sortCollectionView)
    }
    
    override func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        
        if let cell = cell as? QuickSortCollectionViewCell {
            cell.backgroundColor = .black;
            cell.valueLabel.text = "\(sortArray[indexPath.row])";
        }
    }
    
    override func createAnimations(moves: [QuickSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
                case .check:
                    
                    let checkAnimation = ViewSortAnimation({
                        self.logView.insertComparison(first: sortMove.positionOne.value, second: sortMove.positionTwo!.value, sign: "<=");
                    });
                    
                    animationArray.append(checkAnimation);
                    break;
                
                case .dontSwap:
                    let dontSwapAnimation = CollectionViewSortAnimation({
                        
                        self.logView.insertNewLine(text: "NO!", color: .black);
                    });
                    
                    animationArray.append(dontSwapAnimation);
                    
                    break;
                
                case .pivotSwap:
                    
                    let textAnimation = ViewSortAnimation({
                        self.logView.insertSwap(text: "Right pointer has reached the pivot. Swap with the pivot");
                    });
                    
                    let pivotSwapAnimation = CollectionViewSortAnimation({
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    });
                    
                    animationArray.append(textAnimation);
                    animationArray.append(pivotSwapAnimation);
                    break;
                
                case .swap:
                
                    let textAnimation = ViewSortAnimation({
                        if(sortMove.positionOne.index != sortMove.positionTwo?.index) {
                            
                            self.logView.insertSwap(text: "YES! Swap the Left and Right pointers");
                        }
                    });
                    
                    let swapAnimation = CollectionViewSortAnimation({
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    });
                    
                    animationArray.append(textAnimation);
                    animationArray.append(swapAnimation);
                    break;
                
                case .incrementLeft:
                    let incrementLeftAnimation = ViewSortAnimation({
                        self.logView.insertLPointer(text: "Increment by one");
                    });
                    
                    animationArray.append(incrementLeftAnimation);
                    break;
                case .incrementRight:
                    let incrementRightAnimation = ViewSortAnimation({
                        self.logView.insertRPointer(text: "Increment by one");
                    });
                    
                    animationArray.append(incrementRightAnimation);
                    break;
                
                case .selectPivot:
                
                    let selectPivotAnimation = ViewSortAnimation({
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell, unHighlightedCell.isSorted == false {
                                
                                unHighlightedCell.reset();
                            }
                        }
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        cell1?.isPivot = true;
                        cell1?.setAsPivot();
                        
                        self.logView.insertPivot(text: "\(sortMove.positionOne.value) (index: \(sortMove.positionOne.index))");
                    });
                    
                    animationArray.append(selectPivotAnimation);
                    break;
                
                case .selectLeftRight:
                
                    let selectLeftRightAnimation = ViewSortAnimation({

                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            
                            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell,
                                unHighlightedCell.isPivot == false, unHighlightedCell.isSorted == false {
                                
                                unHighlightedCell.reset();
                            }
                        }
                        
                        
                        let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                        let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0)) as? QuickSortCollectionViewCell;
                        
                        if(sortMove.positionOne.index == sortMove.positionTwo!.index) {
                        
                            self.logView.insertLRPointer(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index))");
                            cell1?.setAsLAndR();
                        } else {
                        
                            cell1?.setAsL();
                            self.logView.insertLPointer(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index))");
                            
                            cell2?.setAsR();
                            self.logView.insertRPointer(text: "\(sortMove.positionTwo!.value) (index \(sortMove.positionTwo!.index))");
                        }
                    });
                    
                    animationArray.append(selectLeftRightAnimation);
                    break;
                
            case .selectSorted:
                let selectSortedAnimation = ViewSortAnimation({
                    
                    for i in (0 ..< self.sortArray.count) {
                        
                        if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                            continue;
                        }
                        
                        if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell,
                            unHighlightedCell.isPivot == false, unHighlightedCell.isSorted == false {
                            
                            unHighlightedCell.reset();
                        }
                    }
                    
                    let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                    cell1?.isSorted = !cell1!.isSorted;
                    if(cell1!.isSorted) {
                        cell1?.setAsSorted();
                    } else {
                        cell1?.reset();
                    }
                    
                    self.logView.insertSorted(text: "\(sortMove.positionOne.value) (index \(sortMove.positionOne.index))");
                });
                    
                    animationArray.append(selectSortedAnimation);
                    break;
            }
        }
        
        return animationArray;
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
