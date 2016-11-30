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
    
    var pivotLabel: UILabel!;

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
    
    override func setupViews() {
        
        super.setupViews();
        setupLabels();
    }
    
    internal func setupLabels() {
        
        pivotLabel = UILabel();
        pivotLabel.textColor = UIColor.blue;
        view.addSubview(pivotLabel);
    }
    
    override func applyAutoLayoutConstraints() {
        
        super.applyAutoLayoutConstraints();
        pivotLabel.translatesAutoresizingMaskIntoConstraints = false;
        pivotLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10).isActive = true;
        pivotLabel.centerXAnchor.constraint(equalTo: pivotLabel.superview!.centerXAnchor).isActive = true;
    }
    
    func sortCollectionView(moves: [QuickSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
                case .check:
                    
                    let animation: Animation = {
                        
                        self.statusLabel.fadeTransition(duration: 1);
                        self.statusLabel.textColor = UIColor.black;
                        self.statusLabel.text = "Is \(sortMove.positionOne.value) <= to \(sortMove.positionTwo!.value)";
                    }
                    
                    animationArray.append((animation, .defaultView));
                    break;
                
                case .swap:
                
                    let animation: Animation = {
                        
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.sortCollectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                        
                        if(sortMove.moveType == .swap) {
                            self.statusLabel.fadeTransition(duration: 1);
                            self.statusLabel.text = "Yes!";
                            self.statusLabel.textColor = UIColor.green;
                        } else {
                            self.statusLabel.fadeTransition(duration: 1);
                            self.statusLabel.text = "Nope!";
                            self.statusLabel.textColor = UIColor.red;
                        }
                    }
                    
                    animationArray.append((animation, .collectionView));
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
                        
                        self.pivotLabel.fadeTransition(duration: 1);
                        self.pivotLabel.text = "Pivot is \(sortMove.positionOne.value)";
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
                        
                            cell1?.setAsLAndR();
                            cell1?.backgroundColor = UIColor.orange;
                        } else {
                        
                            cell1?.setAsL();
                            cell2?.setAsR();
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
