//
//  MergeSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class MergeSortViewController: BaseSortingViewController<MergeSort> {
    
    override internal var sortArray: [Int] {
        didSet {
            sectionArray[0] = sortArray.count;
            animationMoves = createAnimations(moves: MergeSort.sort(unsortedArray: sortArray));
        }
    }
    
    var sectionArray: [Int] = [];
    var workingArray: [Int] = [];
    
    override func viewDidLoad() {
        
        //TODO: improve coupled logic here
        sectionArray.append(sortArray.count);
        sectionArray.append(0);
        super.viewDidLoad();
    }
    
    override func applyCollectionViewConstraints() {
        
        super.applyCollectionViewConstraints();
        heightConstraint?.constant = 2 * (kCollectionViewLayoutWidthHeight + (2 * kCollectionViewLayoutTopBottomInset));
    }
    
    override func resetWith(newArray: [Int]) {

        sortButton.setTitle(NSLocalizedString("start", comment: ""), for: .normal);
        animationStep = 0;
        sortArray = newArray;
        workingArray = [];
        sectionArray[1] = self.workingArray.count;
        sortCollectionView.reloadData();
        resetButtonState();
        didFinish = false;
    }
    
    //override as we need a bigger collection view height for the second section
    override func viewDidLayoutSubviews() {}
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionArray[section];
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionArray.count;
    }
    
    override func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        if let cell = cell as? SortCollectionViewCell {
            
            var text: String;
            if (indexPath.section == 0) {
                
                text = "\(sortArray[indexPath.row])"
                
                cell.backgroundColor = UIColor.getRandomRainbowColor(index: indexPath.row);
            } else {
                
                text = "\(workingArray[indexPath.row])"
                cell.backgroundColor = UIColor.black;
            }
            
            cell.valueLabel.text = text
        }
    }
    
    override func createAnimations(moves: [MergeSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .addWorking(let low, let high, let workingArray):
                
                var averageColor: UIColor?;
                let colorAnimation = ViewSortAnimation({
                    var avR: CGFloat = 0;
                    var avG: CGFloat = 0;
                    var avB: CGFloat = 0;
                    let difference: CGFloat = CGFloat(high - low + 1);
                    
                    for i in low..<high + 1 {
                        
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0));
                        let color = cell?.backgroundColor;
                        let colorComponents = (color!.cgColor).components;
                        avR = avR + colorComponents![0];
                        avG = avG + colorComponents![1];
                        avB = avB + colorComponents![2];
                    }
                    
                    avR = avR / difference;
                    avG = avG / difference;
                    avB = avB / difference;
                    averageColor = UIColor(red: avR, green: avG, blue: avB, alpha: 1);
                    
                    for i in low..<high + 1 {
                        
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0));
                        cell?.backgroundColor = averageColor;
                    }
                });
                
                let insertSectionDataAnimation = CollectionViewSortAnimation({
                    self.sectionArray[1] = high - low + 1;
                    self.workingArray = workingArray;
                    self.sortCollectionView.reloadSections(IndexSet(integer:1));
                });
                
                let addSectionAnimation = ViewSortAnimation({
                    self.view.setNeedsLayout();
                    self.view.layoutIfNeeded();
                });
                
                let workingColorAnimation = ViewSortAnimation({
                    for i in 0..<self.sectionArray[1] {
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 1));
                        cell?.backgroundColor = averageColor;
                    }
                });
                
                animationArray.append(colorAnimation);
                animationArray.append(insertSectionDataAnimation);
                animationArray.append(addSectionAnimation);
                animationArray.append(workingColorAnimation);
                break;
                
            case .merge(let left, let right):
                
                let mergeTextAnimation = ViewSortAnimation({
                    
                    self.logView.insertMerge(left: left, right: right);
                });
                
                animationArray.append(mergeTextAnimation);
                break;
                
            case .sorted(let left):
                
                let sortedTextAnimation = ViewSortAnimation({
                    self.logView.insertSorted(arr: left);
                });
                
                animationArray.append(sortedTextAnimation);
                break;
                
            case .swap(let positionOne, let positionTwo):
                let swapAnimation = CollectionViewSortAnimation({
                    let arrayIndex = positionOne.index;
                    let workingIndex = positionTwo.index
                    
                    let ip1 = IndexPath(row:workingIndex, section: 1)
                    let ip2 = IndexPath(row: arrayIndex, section: 0)
                    
                    self.sortCollectionView.moveItem(at: ip1, to: ip2);
                    self.sortCollectionView.moveItem(at: ip2, to: ip1);
                });
                let swappedAnimation = ViewSortAnimation({
                    let arrayIndex = positionTwo.index
                    let ip1 = IndexPath(row:arrayIndex, section: 1)
                    let cell = self.sortCollectionView.cellForItem(at: ip1);
                    cell?.backgroundColor = .red;
                });
                
                animationArray.append(swapAnimation);
                animationArray.append(swappedAnimation);
                break;
            case .removeWorking:
                
                let removeSectionAnimation = CollectionViewSortAnimation({
                    self.removeWorking();
                });
                
                let updateViewSection = ViewSortAnimation({
                    self.view.setNeedsLayout();
                    self.view.layoutIfNeeded();
                });
                
                animationArray.append(removeSectionAnimation);
                animationArray.append(updateViewSection);
                break;
            }
        }
        
        return animationArray;
    }
    
    internal func removeWorking() {
        
        workingArray = [];
        sectionArray[1] = self.workingArray.count;
//        sortCollectionView.reloadSections(IndexSet(integer: 0...1))
        sortCollectionView.reloadSections(IndexSet(integer:1));
    }
    
    override func pressedSort() {
        logView.insertSplit(count: sortArray.count);
        super.pressedSort()
    }
}
