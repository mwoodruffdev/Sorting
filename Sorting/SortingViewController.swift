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

    internal var sortArray: [Int] = [5,2,8,4,6,5,2,4,6];
    internal let kAnimationDuration: TimeInterval = 2;
    internal var sortCollectionView: UICollectionView!
    internal var sortButton: UIButton!;
    internal var logView: SortLogView!;
    internal var worstCaseLabel: UILabel!;
    internal var averageCaseLabel: UILabel!;
    internal var bestCaseLabel: UILabel!;
    internal var heightConstraint: NSLayoutConstraint?;
    
    typealias AnimationBlock  = (Animation, AnimationType);
    typealias Animation = () -> Void
    
    var animationMoves: [AnimationBlock]?;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        view.backgroundColor = UIColor.white;
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
        setupComplexityLabels()
        setupSortButton();
        setupLogView();
    }
    
    internal func setupCollectionView(layout: UICollectionViewLayout) {
        
        sortCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        sortCollectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        sortCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(sortCollectionView)
    }
    
    internal func setupLogView() {
    
        logView = SortLogView();
        logView.text = "Press start to begin!";
        view.addSubview(logView);
    }
    
    internal func setupComplexityLabels() {
        
        worstCaseLabel = UILabel();
        worstCaseLabel.text = "Worst Case: \(worstCaseText())";
        worstCaseLabel.textColor = UIColor.black;
        view.addSubview(worstCaseLabel);
        
        averageCaseLabel = UILabel();
        averageCaseLabel.text = "Average Case: \(averageCaseText())";
        averageCaseLabel.textColor = UIColor.black;
        view.addSubview(averageCaseLabel);
        
        bestCaseLabel = UILabel();
        bestCaseLabel.text = "Best Case: \(bestCaseText())";
        bestCaseLabel.textColor = UIColor.black;
        view.addSubview(bestCaseLabel);
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
    
    //MARK: Autolayout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        heightConstraint?.constant = sortCollectionView.contentSize.height;
    }
    
    internal func applyAutoLayoutConstraints() {
        
        sortCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        sortCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        sortCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        sortCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        
        heightConstraint = sortCollectionView.heightAnchor.constraint(equalToConstant: 0);
        heightConstraint?.isActive = true;
        
        worstCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        worstCaseLabel.topAnchor.constraint(equalTo: sortCollectionView.bottomAnchor, constant: 10).isActive = true
        worstCaseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        
        averageCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        averageCaseLabel.topAnchor.constraint(equalTo: worstCaseLabel.bottomAnchor, constant: 10).isActive = true
        averageCaseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        
        bestCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        bestCaseLabel.topAnchor.constraint(equalTo: averageCaseLabel.bottomAnchor, constant: 10).isActive = true
        bestCaseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        
        logView.translatesAutoresizingMaskIntoConstraints = false;
        logView.topAnchor.constraint(equalTo: bestCaseLabel.bottomAnchor, constant: 20).isActive = true;
        logView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        logView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true;
        logView.bottomAnchor.constraint(equalTo: sortButton.topAnchor, constant: -10).isActive = true;
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false;
        sortButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        sortButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        sortButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        sortButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
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
    
    //MARK: Animations
    
    internal func swap(sender: UIButton) {
        
        sortButton.setTitle("Stop Sorting", for: .normal);
        if(sender.tag == 0) {
            startAnimations(index: 0);
        }
    }
    
    internal func startAnimations(index: Int) {
        
        if(index < animationMoves!.count) {
            
            let block = animationMoves![index];
            if block.1 == .collectionView {
                self.sortCollectionView.performBatchUpdates(animationMoves![index].0, completion: { (didFinish) in
                    if(didFinish) {
                        self.startAnimations(index: index + 1)
                    }
                })
            } else if block.1 == .defaultView {
                
                UIView.animate(withDuration: kAnimationDuration, delay: 0, options: .allowUserInteraction, animations: animationMoves![index].0, completion: { (didFinish) in
                    if(didFinish) {
                        self.startAnimations(index: index + 1);
                    }
                })
            }
        }
    }
    
    enum AnimationType {
        case collectionView, defaultView;
    }
    
    //MARK: Complexity
    internal func worstCaseText() -> String {
        return "";
    }
    
    internal func averageCaseText() -> String {
        return "";
    }
    
    internal func bestCaseText() -> String {
        return "";
    }
}
