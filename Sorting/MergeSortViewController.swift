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
                
                cell.backgroundColor = getRandomRainbowColor(index: indexPath.row);
            } else {
                
                text = "\(workingArray[indexPath.row])"
                cell.backgroundColor = UIColor.black;
            }
            
            cell.valueLabel.text = text
        }
    }
    
    func getRandomRainbowColor(index: Int) -> UIColor {
        
        let hue = CGFloat(Int(arc4random() % 256)) / 256;
        let saturation = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        let brightness = CGFloat(Int(arc4random() % 128)) / 256 + 0.5;
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1);
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
                    var arrayOneText = "[";
                    var arrayTwoText = "[";
                    
                    for i in 0..<left.count {
                        arrayOneText = arrayOneText + "\(left[i])";
                        if(i != left.count-1) {
                            arrayOneText = arrayOneText + ", "
                        } else {
                            arrayOneText = arrayOneText + "]";
                        }
                    }
                    
                    for i in 0..<right.count {
                        arrayTwoText = arrayTwoText + "\(right[i])";
                        
                        if(i != right.count-1) {
                            arrayTwoText = arrayTwoText + ", "
                        } else {
                            arrayTwoText = arrayTwoText + "]";
                        }
                    }
                    
                    self.logView.insertNewLine(text: "MERGE: \(arrayOneText) and \(arrayTwoText)", color: UIColor.black);
                });
                
                animationArray.append(mergeTextAnimation);
                break;
                
            case .sorted(let left):
                
                let sortedTextAnimation = ViewSortAnimation({
                    var sortedArrayText = "SORTED: ["
                    for i in 0..<left.count {
                        sortedArrayText = sortedArrayText + "\(left[i])";
                        if(i != left.count - 1) {
                            sortedArrayText = sortedArrayText + ", ";
                        } else {
                            sortedArrayText = sortedArrayText + "]";
                        }
                    }
                    
                    self.logView.insertNewLine(text: sortedArrayText, color: UIColor.black);
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
                    self.workingArray = [];
                    self.sectionArray[1] = self.workingArray.count;
                    self.sortCollectionView.reloadSections(IndexSet(integer:1));
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
    
    override func sort() {
        
        logView.insertNewLine(text: "SPLIT: Into \(sortArray.count) sub arrays", color: UIColor.black);
        super.sort()
    }
}
