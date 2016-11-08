//
//  BubbleSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSortViewController: UIViewController, SortingViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let sortArray = [3, 1, 0, 4, 2];
    
    var collectionView: UICollectionView!;
    var animationMoves: [AnimationBlock]?;
    
    typealias Animation = () -> Void
    typealias AnimationBlock  = (Animation, Int);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.red;
        
        let bubbleSort = BubbleSort(unsortedArray: sortArray);
        let sortingQueue = bubbleSort.sort();
        
        animationMoves = sortCollectionView(moves: sortingQueue as! [BubbleSortMove]);
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        layout.itemSize = CGSize(width: 30, height: 30)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100));
        button.setTitle("SWAP PLEASE", for: .normal);
        button.tag = 0;
        button.addTarget(self, action: #selector(swap), for: .touchUpInside);
        button.setTitleColor(UIColor.white, for: .normal);
        view.addSubview(button);
    }
    
    func startAnimations(index: Int) {
        
        if(index < animationMoves!.count) {
            
            let block = animationMoves![index];
            if block.1 == 0 {
                self.collectionView.performBatchUpdates(animationMoves![index].0, completion: { (didFinish) in
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
    
    func swap(sender: UIButton) {
        
        if(sender.tag == 0) {
            startAnimations(index: 0);
        }
    }
    
    func sortCollectionView(moves: [BubbleSortMove]) -> [AnimationBlock] {
        
        var animationArray: [AnimationBlock] = [];

        for sortMove in moves {

            switch(sortMove.moveType) {

                case .checking:
                    let animation: Animation = {
                        
                        let cell1 = self.collectionView.cellForItem(at: IndexPath(row: sortMove.positionOne.index, section: 0));
                        cell1?.backgroundColor = UIColor.red;
                        let cell2 = self.collectionView.cellForItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0));
                        cell2?.backgroundColor = UIColor.red;
                        
                        for i in (0 ..< self.sortArray.count) {
                            
                            if i == sortMove.positionOne.index || i == sortMove.positionTwo?.index {
                                continue;
                            }
                            if let unHighlightedCell =  self.collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SortCollectionViewCell,
                            unHighlightedCell.sorted == false {
                                
                                unHighlightedCell.backgroundColor = UIColor.black;
                            }
                        }
                    }
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
                    break;
                case .sortedFrom:

                    let animation: Animation = {
                        
                        let sortedIndex = sortMove.positionOne.index;
                        
                        var i = 0;
                        while i < self.sortArray.count {
                            
                            let cell = self.collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! SortCollectionViewCell;
                            if(i < sortedIndex) {
                                cell.backgroundColor = UIColor.black;
                                cell.sorted = false;
                            } else {
                                cell.backgroundColor = UIColor.green;
                                cell.sorted = true;
                            }
                            i = i + 1;
                        }
                    }
                    
                    let type = 1;
                    let block = (animation, type);
                    animationArray.append(block);
                    
                    break;
                case .swap:
                    
                    let animation: Animation = {
                        
                        self.collectionView.moveItem(at: IndexPath(row: sortMove.positionOne.index, section: 0), to: IndexPath(row: sortMove.positionTwo!.index, section: 0))
                        self.collectionView.moveItem(at: IndexPath(row: sortMove.positionTwo!.index, section: 0), to: IndexPath(row: sortMove.positionOne.index, section: 0))
                    }
                    
                    let type = 0;
                    let block = (animation, type);
                    animationArray.append(block);
                    
                    break;
            }
        }
        
        return animationArray;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortArray.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SortCollectionViewCell;
        
        cell.backgroundColor = UIColor.black;
        cell.valueLabel.text = "\(sortArray[indexPath.row])";
        return cell
    }
    
    func sort() {
        
    } 
}
