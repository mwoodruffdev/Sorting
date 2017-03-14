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
    
    override func registerCells() {
        sortCollectionView.register(QuickSortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let superSize = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath);
        let doubleHeightSize = CGSize(width: superSize.width, height: superSize.height * 2);
        return doubleHeightSize;
    }
    
    override func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        
        if let cell = cell as? QuickSortCollectionViewCell {
            cell.backgroundColor = .black;
            cell.valueLabel.text = "\(sortArray[indexPath.row])";
        }
    }
    
    override func resetWith(newArray: [Int]) {
        resetCells { (cell) -> Bool in
            return true;
        }
        super.resetWith(newArray: newArray);
    }
    
    override func createAnimations(moves: [QuickSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .check(let positionOne, let positionTwo):
            
                let checkAnimation = ViewSortAnimation({
                    self.logView.insertComparison(first: positionOne.value, second: positionTwo.value, sign: "<=");
                });
                
                animationArray.append(checkAnimation);
                break;
                
            case .dontSwap:
                let dontSwapAnimation = CollectionViewSortAnimation({
                    
                    self.logView.insertNewLine(text: NSLocalizedString("no", comment: ""), color: .black);
                });
                
                animationArray.append(dontSwapAnimation);
                
                break;
                
            case .pivotSwap(let positionOne, let pivotPosition):
                
                let textAnimation = ViewSortAnimation({
                    
                    if(positionOne.index == pivotPosition.index) {
                        self.logView.insertNewLine(text: NSLocalizedString("logger_action_L_R_reached_pivot", comment: ""), color: .black);
                    } else {
                        self.logView.insertLSwap();
                    }
                });
                
                animationArray.append(textAnimation);
                if(positionOne.index != pivotPosition.index) {
                    
                    let pivotSwapAnimation = CollectionViewSortAnimation({
                        self.sortCollectionView.moveItem(at: IndexPath(row: positionOne.index, section: 0), to: IndexPath(row: pivotPosition.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: pivotPosition.index, section: 0), to: IndexPath(row: positionOne.index, section: 0))
                    });
                    animationArray.append(pivotSwapAnimation);
                }
                
                
                break;
                
            case .swap(let positionOne, let positionTwo):
                
                if(positionOne.index == positionTwo.index) {
                    continue;
                }
                
                let textAnimation = ViewSortAnimation({
                    
                    self.logView.insertLRSwap();
                });
                
                let swapAnimation = CollectionViewSortAnimation({
                    
                    self.sortCollectionView.moveItem(at: IndexPath(row: positionOne.index, section: 0), to: IndexPath(row: positionTwo.index, section: 0))
                    self.sortCollectionView.moveItem(at: IndexPath(row: positionTwo.index, section: 0), to: IndexPath(row: positionOne.index, section: 0))
                });
                
                animationArray.append(textAnimation);
                animationArray.append(swapAnimation);
                break;
                
            case .selectPivot(let pivotPosition):
                let selectPivotAnimation = ViewSortAnimation({

                    self.resetCells(clause: self.animationCondition);
                    
                    let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: pivotPosition.index, section: 0)) as? QuickSortCollectionViewCell;
                    cell1?.setAsPivot();
                    
                    self.logView.insertPivot(text: "\(pivotPosition.value) (\(String(format: NSLocalizedString("logger_action_detail_index", comment: ""), pivotPosition.index)))");
                });
                
                animationArray.append(selectPivotAnimation);
                break;
                
            case .selectLeftRight(let positionOne, let positionTwo):
                
                let selectLeftRightAnimation = ViewSortAnimation({
                    
                    self.resetCells(clause: self.animationCondition);
                    
                    let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionOne.index, section: 0)) as? QuickSortCollectionViewCell;
                    let cell2 = self.sortCollectionView.cellForItem(at: IndexPath(row: positionTwo.index, section: 0)) as? QuickSortCollectionViewCell;
                    
                    if(positionOne.index == positionTwo.index) {
                        
                        self.logView.insertLRPointer(text: "\(positionOne.value) (\(String(format: NSLocalizedString("logger_action_detail_index", comment: ""), positionOne.index)))");
                        cell1?.setAsLAndR();
                    } else {
                        
                        cell1?.setAsL();
                        self.logView.insertLPointer(text: "\(positionOne.value) (\(String(format: NSLocalizedString("logger_action_detail_index", comment: ""), positionOne.index)))");
                        
                        cell2?.setAsR();
                        self.logView.insertRPointer(text: "\(positionTwo.value) (\(String(format: NSLocalizedString("logger_action_detail_index", comment: ""), positionTwo.index)))");
                    }
                });
                
                animationArray.append(selectLeftRightAnimation);
                break;
                
            case .selectSorted(let sortedPosition):
                
                let selectSortedAnimation = ViewSortAnimation({
                    
                    self.resetCells(clause: self.animationCondition);
                    
                    let cell1 = self.sortCollectionView.cellForItem(at: IndexPath(row: sortedPosition.index, section: 0)) as? QuickSortCollectionViewCell;
                    
                    if(!cell1!.isSorted) {
                        cell1?.setAsSorted();
                    } else {
                        cell1?.reset();
                    }
                    
                    self.logView.insertSorted(text: "\(sortedPosition.value) (\(String(format: NSLocalizedString("logger_action_detail_index", comment: ""), sortedPosition.index)))");
                });
                
                animationArray.append(selectSortedAnimation);
                break;
            }
        }
        
        return animationArray;
    }
    
    internal func resetCells(clause: (QuickSortCollectionViewCell) -> Bool) {
     
        for i in (0 ..< self.sortArray.count) {
            
            if let unHighlightedCell =  self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? QuickSortCollectionViewCell, clause(unHighlightedCell) {
                
                unHighlightedCell.reset();
            }
        }
    }
    
    internal func animationCondition(cell: QuickSortCollectionViewCell) -> Bool {
        return cell.isPivot == false && cell.isSorted == false;
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
