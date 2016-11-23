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

    internal var sortArray: [Int] = [5,2,5,4,6,8,2,3,4,1,5,8,2,8,3,7,3,8,3,3,3,1,2];
    internal var sortCollectionView: UICollectionView!
    internal var sortButton: UIButton!;
    internal var statusLabel: UILabel!;
    
    typealias Animation = () -> Void
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        setupViews();
        applyAutoLayoutConstraints();
    }
    
    internal func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 6, left: 3, bottom: 6, right: 3)
        layout.itemSize = CGSize(width: 30, height: 30)
        
        return layout;
    }
    
    internal func setupViews() {
        setupCollectionView(layout: createCollectionViewLayout());
        setupSortButton();
        setupStatusLabel();
    }
    
    internal func setupCollectionView(layout: UICollectionViewLayout) {
        
        sortCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        sortCollectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        sortCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(sortCollectionView)
    }
    
    internal func setupSortButton() {
        
        sortButton = UIButton();
        sortButton.setTitle("START", for: .normal);
        sortButton.tag = 0;
        sortButton.addTarget(self, action: #selector(swap), for: .touchUpInside);
        sortButton.backgroundColor = UIColor.black;
        sortButton.setTitleColor(UIColor.white, for: .normal);
        view.addSubview(sortButton);
    }
    
    internal func setupStatusLabel() {
        
        statusLabel = UILabel();
        statusLabel.text = "Tap start to begin";
        statusLabel.textColor = UIColor.black;
        view.addSubview(statusLabel);
    }
    
    //MARK: Autolayout
    
    internal func applyAutoLayoutConstraints() {
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false;
        sortButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        sortButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        sortButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        sortButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false;
        statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }
    
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath);
        
        setupCell(indexPath: indexPath, cell: cell);
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    internal func setupCell(indexPath: IndexPath, cell: UICollectionViewCell) {
        if let cell = cell as? SortCollectionViewCell {
            cell.backgroundColor = UIColor.black;
            cell.valueLabel.text = "\(sortArray[indexPath.row])";
        }
    }
    
    func swap(sender: UIButton) {
        
        sortButton.setTitle("Stop Sorting", for: .normal);
        if(sender.tag == 0) {
            startAnimations(index: 0);
        }
    }
    
    func startAnimations(index: Int) {

        print("not implemented!");
    }
}
