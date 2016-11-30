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

        super.viewDidLoad()
        
        sectionArray.append(sortArray.count);
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
        
        let hue: CGFloat = CGFloat(sectionArray[0]) / CGFloat(index);
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1);
    }
    
    func sortCollectionView(moves: [MergeSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];
        
        for sortMove in moves {
            
            switch(sortMove.moveType) {
                
            case .addWorking:
                
                var averageColor: UIColor?;
                let colorAnimation: Animation = {
                    
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
                    averageColor = averageColor?.modified(withAdditionalHue: 1, additionalSaturation: 1, additionalBrightness: 1);
                    
                    for i in sortMove.low!..<sortMove.high! + 1 {
                        
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0));
                        cell?.backgroundColor = averageColor;
                    }
                }
                
                let insertSectionAnimation: Animation = {
                    
                    self.sectionArray.append(0);
                    self.sectionArray[1] = sortMove.high! - sortMove.low! + 1;
                    self.workingArray = sortMove.workingArray!;
                    self.sortCollectionView.insertSections(IndexSet(integer: 1));
                }
                
                let workingColorAnimation: Animation = {
                    for i in 0..<self.sectionArray[1] {
                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 1));
                        cell?.backgroundColor = averageColor;
                    }
                }
                
                animationArray.append((colorAnimation, .defaultView));
                animationArray.append((insertSectionAnimation, .collectionView));
                animationArray.append((workingColorAnimation, .defaultView));
                break;
                
            case .swap:
                let animation: Animation = {
                    
                    let arrayIndex = sortMove.positionOne?.index;
                    let workingIndex = sortMove.positionTwo?.index
                    
                    let ip1 = IndexPath(row:workingIndex!, section: 1)
                    let ip2 = IndexPath(row: arrayIndex!, section: 0)
                    
                    self.sortCollectionView.moveItem(at: ip1, to: ip2);
                    self.sortCollectionView.moveItem(at: ip2, to: ip1);
                }
                
                animationArray.append((animation, .collectionView));
                break;
            case .removeWorking:
                let animation: Animation = {
                    self.sectionArray.remove(at: 1);
                    self.workingArray = [];
                    self.sortCollectionView.deleteSections(IndexSet(integer: 1));
                }
                
                animationArray.append((animation, .collectionView));
                break;
            }
            
        }
        
        return animationArray;
    }
    
    override func swap(sender: UIButton) {
        
        super.swap(sender: sender);
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

extension UIColor {
    
    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
}
