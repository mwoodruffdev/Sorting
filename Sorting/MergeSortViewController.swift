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
    
    var sectionArray: [Int] = [];
    var workingArray: [Int] = [];
    
    override func viewDidLoad() {

        super.viewDidLoad();
        title = "Merge Sort";
        sectionArray.append(sortArray.count);
        sectionArray.append(0);
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
    
    func sortCollectionView(moves: [MergeSortMove]) -> [SortAnimation] {
        
        var animationArray: [SortAnimation] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .addWorking:
                
                var averageColor: UIColor?;
                let colorAnimation = ViewSortAnimation({
                    var avR: CGFloat = 0;
                    var avG: CGFloat = 0;
                    var avB: CGFloat = 0;
                    let difference: CGFloat = CGFloat(sortMove.high! - sortMove.low! + 1);
                    
                    for i in sortMove.low!..<sortMove.high! + 1 {
                        
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
                    
                    for i in sortMove.low!..<sortMove.high! + 1 {
                        
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0));
                        cell?.backgroundColor = averageColor;
                    }
                });
                
                let insertSectionDataAnimation = CollectionViewSortAnimation({
                    self.sectionArray[1] = sortMove.high! - sortMove.low! + 1;
                    self.workingArray = sortMove.workingArray!;
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
                
            case .merge:
                
                let mergeTextAnimation = ViewSortAnimation({
                    var arrayOneText = "Array: [";
                    var arrayTwoText = "Array: [";
                    
                    for i in 0..<sortMove.left!.count {
                        arrayOneText = arrayOneText + "\(sortMove.left![i])";
                        if(i != sortMove.left!.count-1) {
                            arrayOneText = arrayOneText + ", "
                        } else {
                            arrayOneText = arrayOneText + "]";
                        }
                    }
                    
                    for i in 0..<sortMove.right!.count {
                        arrayTwoText = arrayTwoText + "\(sortMove.right![i])";
                        
                        if(i != sortMove.right!.count-1) {
                            arrayTwoText = arrayTwoText + ", "
                        } else {
                            arrayTwoText = arrayTwoText + "]";
                        }
                    }
                    
                    self.logView.insertNewLine(text: "Merge \(arrayOneText) and \(arrayTwoText)", color: UIColor.black);
                });
                
                animationArray.append(mergeTextAnimation);
                break;
            
            case .sorted:
                
                let sortedTextAnimation = ViewSortAnimation({
                    var sortedArrayText = "Sorted Array: ["
                    for i in 0..<sortMove.left!.count {
                        sortedArrayText = sortedArrayText + "\(sortMove.left![i])";
                        if(i != sortMove.left!.count - 1) {
                            sortedArrayText = sortedArrayText + ", ";
                        } else {
                            sortedArrayText = sortedArrayText + "]";
                        }
                    }
                    
                    self.logView.insertNewLine(text: sortedArrayText, color: UIColor.black);
                });
                
                animationArray.append(sortedTextAnimation);
                break;
                
            case .swap:
                let swapAnimation = CollectionViewSortAnimation({
                    let arrayIndex = sortMove.positionOne?.index;
                    let workingIndex = sortMove.positionTwo?.index
                    
                    let ip1 = IndexPath(row:workingIndex!, section: 1)
                    let ip2 = IndexPath(row: arrayIndex!, section: 0)
                    
                    self.sortCollectionView.moveItem(at: ip1, to: ip2);
                    self.sortCollectionView.moveItem(at: ip2, to: ip1);
                });
                
                animationArray.append(swapAnimation);
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
    
    override func swap(sender: UIButton) {

        logView.insertNewLine(text: "Array split into \(sortArray.count) sub arrays", color: UIColor.black);
        super.swap(sender: sender)
    }
    
    override func worstCaseText() -> String {
        return "O(n log n)";
    }
    
    override func averageCaseText() -> String {
        return "O(n log n)";
    }
    
    override func bestCaseText() -> String {
        return "O(n log n)";
    }
}
