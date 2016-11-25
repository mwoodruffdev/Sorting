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
            
            cell.backgroundColor = getRandomRainbowColor(index: indexPath.row);
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
                let animation: Animation = {
                    
                    self.sectionArray.append(0);
                    self.sectionArray[1] = sortMove.high! - sortMove.low! + 1;
                    self.workingArray = sortMove.workingArray!;
                    
//                    for i in sortMove.low!..<sortMove.high! {
//                    
//                        let cell = self.sortCollectionView.cellForItem(at: IndexPath(row: i, section: 0));
//                        cell?.backgroundColor = UIColor.blue;
//                    }
                    
                    self.sortCollectionView.insertSections(NSIndexSet(index: 1) as! IndexSet);
                }
                animationArray.append((animation, .collectionView));
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
                    self.sortCollectionView.deleteSections(NSIndexSet(index: 1) as! IndexSet);
                }
                
                animationArray.append((animation, .collectionView));
                break;
            default:
                break;
            }
            
        }
        
        return animationArray;
    }
}
