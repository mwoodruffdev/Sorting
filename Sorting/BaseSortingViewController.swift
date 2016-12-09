//
//  BaseSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BaseSortingViewController<Algorithm: SortingAlgorithm>: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    internal var sortArray: [Int] = [5,2,8,4,6,5,2,4,6];
    internal let kAnimationDuration: TimeInterval = 0;
    internal var sortCollectionView: UICollectionView!
    internal var stepBackButton: UIButton;
    internal var stepForwardButton: UIButton;
    internal var sortButton: UIButton;
    internal var logView: SortLogView;
    internal var worstCaseLabel: UILabel;
    internal var averageCaseLabel: UILabel;
    internal var bestCaseLabel: UILabel;
    internal var heightConstraint: NSLayoutConstraint?;
    
    var animationMoves: [SortAnimation]?;
    var isAnimating: Bool = false;
    var animationStep: Int = 0;
    
    init() {
        stepBackButton = UIButton();
        stepForwardButton = UIButton();
        sortButton = UIButton();
        logView = SortLogView();
        worstCaseLabel = UILabel();
        averageCaseLabel = UILabel();
        bestCaseLabel = UILabel();
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        stepBackButton = UIButton();
        stepForwardButton = UIButton();
        sortButton = UIButton();
        logView = SortLogView();
        worstCaseLabel = UILabel();
        averageCaseLabel = UILabel();
        bestCaseLabel = UILabel();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        title = Algorithm.name;
        view.backgroundColor = UIColor.white;
        automaticallyAdjustsScrollViewInsets = false;
        setupViews();
        applyAutoLayoutConstraints();
        animationMoves = createAnimations(moves: Algorithm.sort(unsortedArray: sortArray));
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
        setupButtons();
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
        
        logView.text = "Press start to begin!";
        view.addSubview(logView);
    }
    
    internal func setupComplexityLabels() {
        
        worstCaseLabel.text = "Worst Case: \(Algorithm.worstComplexity)";
        worstCaseLabel.textColor = UIColor.black;
        view.addSubview(worstCaseLabel);
        
        averageCaseLabel.text = "Average Case: \(Algorithm.averageComplexity)";
        averageCaseLabel.textColor = UIColor.black;
        view.addSubview(averageCaseLabel);
        
        bestCaseLabel.text = "Best Case: \(Algorithm.bestComplexity)";
        bestCaseLabel.textColor = UIColor.black;
        view.addSubview(bestCaseLabel);
    }
    
    internal func setupButtons() {
        
        stepBackButton.layer.borderColor = UIColor.white.cgColor
        stepBackButton.layer.borderWidth = 1;
        stepBackButton.setTitle("Back", for: .normal);
        stepBackButton.addTarget(self, action: #selector(stepBack), for: .touchUpInside);
        stepBackButton.backgroundColor = .black;
        stepBackButton.setTitleColor(.white, for: .normal);
        view.addSubview(stepBackButton);

        
        stepForwardButton.layer.borderColor = UIColor.white.cgColor
        stepForwardButton.layer.borderWidth = 1;
        stepForwardButton.setTitle("Next", for: .normal);
        stepForwardButton.addTarget(self, action: #selector(stepForward), for: .touchUpInside);
        stepForwardButton.backgroundColor = .black;
        stepForwardButton.setTitleColor(.white, for: .normal);
        view.addSubview(stepForwardButton);
        
        sortButton.setTitle("START", for: .normal);
        sortButton.addTarget(self, action: #selector(sort), for: .touchUpInside);
        sortButton.backgroundColor = .black;
        sortButton.setTitleColor(.white, for: .normal);
        view.addSubview(sortButton);
    }
    
    //MARK: Autolayout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        heightConstraint?.constant = sortCollectionView.contentSize.height;
    }
    
    internal func applyAutoLayoutConstraints() {
        
        sortCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        sortCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true;
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
        logView.bottomAnchor.constraint(equalTo: stepBackButton.topAnchor, constant: -10).isActive = true;
        
        stepBackButton.translatesAutoresizingMaskIntoConstraints = false;
        stepBackButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        stepBackButton.rightAnchor.constraint(equalTo: stepForwardButton.leftAnchor).isActive = true;
        stepBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        stepBackButton.widthAnchor.constraint(equalToConstant: 50).isActive = true;
        
        stepForwardButton.translatesAutoresizingMaskIntoConstraints = false;
        stepForwardButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        stepForwardButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        stepForwardButton.widthAnchor.constraint(equalTo: stepBackButton.widthAnchor, multiplier: 1).isActive = true;
        stepForwardButton.heightAnchor.constraint(equalTo: stepBackButton.heightAnchor, multiplier: 1).isActive = true;
        
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
    
    internal func createAnimations(moves: [Algorithm.MoveType]) -> [SortAnimation] {
        preconditionFailure("This method must be overridden!");
    }
    
    internal func sort() {
        
        if(!isAnimating) {
            stepBackButton.isEnabled = false;
            stepForwardButton.isEnabled = false;
            sortButton.setTitle("Stop Sorting", for: .normal);
            isAnimating = !isAnimating;
            performAnimation(step: animationStep, completion: nil);
        } else {
            stepBackButton.isEnabled = true;
            stepForwardButton.isEnabled = true;
            isAnimating = !isAnimating;
            sortButton.setTitle("Continue", for: .normal);
        }
    }
    
    internal func stepBack() {
        
    }
    
    internal func stepForward() {
        
        if(!isAnimating) {
            isAnimating = !isAnimating;
            performAnimation(step: animationStep, completion: { 
                self.isAnimating = !self.isAnimating;
            })
        }
    }
    
    internal func performAnimation(step: Int, completion: (()->Void)?) {
        
        if(step < animationMoves!.count && isAnimating) {
            
            let sortAnimation = animationMoves![step];
            
            switch(sortAnimation.type) {
                case .collectionView:
                    self.sortCollectionView.performBatchUpdates(sortAnimation.animation, completion: { (didFinish) in
                        self.animationStep = self.animationStep + 1;
                        if(completion != nil) {
                            completion!();
                        } else {
                            self.performAnimation(step: self.animationStep, completion: nil);
                        }
                    })
                    break;
                case .defaultView:
                    UIView.animate(withDuration: kAnimationDuration, delay: 0, options: .allowUserInteraction, animations: sortAnimation.animation, completion: { (didFinish) in
                        self.animationStep = self.animationStep + 1;
                        if(completion != nil) {
                            completion!();
                        } else {
                            self.performAnimation(step: self.animationStep, completion: nil);
                        }
                    })
                    break;
                }
        }
    }
}
