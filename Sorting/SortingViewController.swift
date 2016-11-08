//
//  BaseSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

protocol SortingViewController {
    
    var sortArray: [Int] {set get}
    var sortCollectionView: UICollectionView! {set get};
}

class BaseSortingViewController: UIViewController, SortingViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    internal var sortArray: [Int] = [3, 1, 0, 4, 2];
    internal var sortCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        layout.itemSize = CGSize(width: 30, height: 30)
        
        sortCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        sortCollectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        sortCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(sortCollectionView)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100));
        button.setTitle("SWAP PLEASE", for: .normal);
        button.tag = 0;
        button.addTarget(self, action: #selector(swap), for: .touchUpInside);
        button.setTitleColor(UIColor.white, for: .normal);
        view.addSubview(button);
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
    
    func swap(sender: UIButton) {
        
        if(sender.tag == 0) {
            startAnimations(index: 0);
        }
    }
    
    func startAnimations(index: Int) {

        print("not implemented!");
    }
}
