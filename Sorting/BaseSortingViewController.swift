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
    
    //consts
    internal let kAnimationDuration: TimeInterval = 0.5;
    internal let kMaxAmount: Int = 50;
    
    //Data
    internal var sortArray: [Int] = [] {
        didSet {
            animationMoves = createAnimations(moves: Algorithm.sort(unsortedArray: sortArray));
        }
    }
    
    internal let kMinimumSortArrayLength = 3;
    
    var animationMoves: [SortAnimation] = [];
    var isAnimating: Bool = false;
    var didFinish: Bool = false;
    var animationStep: Int = 0;
    
    //UI
    internal var sortCollectionView: UICollectionView!
    internal var minusButton = UIButton();
    internal var plusButton = UIButton();
    internal var stepBackButton = UIButton();
    internal var stepForwardButton = UIButton();
    internal var randomiseButton = UIButton();
    internal var resetButton = UIButton();
    internal var sortButton = UIButton();
    internal var clearButton = UIButton();
    internal var logView = SortLogView();
    internal var worstCaseLabel = UILabel();
    internal var worstCaseShowMe = UIButton()
    internal var averageCaseLabel = UILabel();
    internal var bestCaseLabel = UILabel();
    internal var bestCaseShowMe = UIButton();
    
    let kCollectionViewLayoutWidthHeight: CGFloat = 30;
    let kCollectionViewLayoutLeftRightInset: CGFloat = 3;
    let kCollectionViewLayoutTopBottomInset: CGFloat = 6;
    //Constraints
    internal var heightConstraint: NSLayoutConstraint?;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        title = Algorithm.name;
        view.backgroundColor = UIColor.white;
        automaticallyAdjustsScrollViewInsets = false;
        
        setupSortingArray(length: 5);
        setupViews();
        applyAutoLayoutConstraints();
    }
    
    internal func setupSortingArray(length: Int) {
        var tempArray = [Int]();
        
        for _ in 0...length-1 {
            let randomNumber = Int(arc4random_uniform(50));
            tempArray.append(randomNumber);
        }
        sortArray = tempArray;
    }
    
    internal func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCollectionViewLayoutTopBottomInset,
                                           left: kCollectionViewLayoutLeftRightInset,
                                           bottom: kCollectionViewLayoutTopBottomInset,
                                           right: kCollectionViewLayoutLeftRightInset )
        layout.itemSize = CGSize(width: kCollectionViewLayoutWidthHeight, height: kCollectionViewLayoutWidthHeight)
        
        return layout;
    }
    
    internal func setupViews() {
        
        setupCollectionView(layout: createCollectionViewLayout());
        setupComplexityLabels()
        setupLogView();
        setupButtons();
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
        
        let worstCase = NSMutableAttributedString(string: "Worst Case: ");
        worstCase.append(Algorithm.worstComplexity);
        worstCaseLabel.attributedText = worstCase;
        worstCaseLabel.textColor = UIColor.black;
        view.addSubview(worstCaseLabel);
        
        let averageCase = NSMutableAttributedString(string: "Average Case: ");
        averageCase.append(Algorithm.averageComplexity);
        averageCaseLabel.attributedText = averageCase;
        averageCaseLabel.textColor = UIColor.black;
        view.addSubview(averageCaseLabel);
        
        let bestCase = NSMutableAttributedString(string: "Best Case: ");
        bestCase.append(Algorithm.bestComplexity);
        bestCaseLabel.attributedText = bestCase;
        bestCaseLabel.textColor = UIColor.black;
        view.addSubview(bestCaseLabel);
    }
    
    internal func setupButtons() {
        
        clearButton.setTitle("Clear", for: .normal);
        clearButton.setTitleColor(.blue, for: .normal);
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside);
        view.addSubview(clearButton);
        
        minusButton.layer.borderColor = UIColor.white.cgColor
        minusButton.layer.borderWidth = 1;
        minusButton.setTitle("-", for: .normal);
        minusButton.addTarget(self, action: #selector(removeElement), for: .touchUpInside);
        minusButton.backgroundColor = .black;
        minusButton.setTitleColor(.white, for: .normal);
        view.addSubview(minusButton);
        
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.layer.borderWidth = 1;
        plusButton.setTitle("+", for: .normal);
        plusButton.addTarget(self, action: #selector(addElement), for: .touchUpInside);
        plusButton.backgroundColor = .black;
        plusButton.setTitleColor(.white, for: .normal);
        view.addSubview(plusButton);
        
        worstCaseShowMe.setTitle("Show Me!", for: .normal);
        worstCaseShowMe.addTarget(self, action: #selector(showMeWorst), for: .touchUpInside);
        worstCaseShowMe.setTitleColor(.blue, for: .normal);
        view.addSubview(worstCaseShowMe);
        
        bestCaseShowMe.setTitle("Show Me!", for: .normal);
        bestCaseShowMe.addTarget(self, action: #selector(showMeBest), for: .touchUpInside);
        bestCaseShowMe.setTitleColor(.blue, for: .normal);
        view.addSubview(bestCaseShowMe);
        
        /* Hide back feature for now */
        stepBackButton.isHidden = true;
        /* Hide back feature for now */
        stepBackButton.layer.borderColor = UIColor.white.cgColor
        stepBackButton.layer.borderWidth = 1;
        stepBackButton.setTitle("BACK", for: .normal);
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
        
        randomiseButton.layer.borderColor = UIColor.white.cgColor
        randomiseButton.layer.borderWidth = 1;
        randomiseButton.setTitle("RANDOMISE", for: .normal);
        randomiseButton.addTarget(self, action: #selector(randomise), for: .touchUpInside);
        randomiseButton.backgroundColor = .black;
        randomiseButton.setTitleColor(.white, for: .normal);
        view.addSubview(randomiseButton);
        
        resetButton.layer.borderColor = UIColor.white.cgColor
        resetButton.layer.borderWidth = 1;
        resetButton.setTitle("RESET", for: .normal);
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside);
        resetButton.backgroundColor = .black;
        resetButton.setTitleColor(.white, for: .normal);
        view.addSubview(resetButton);
        
        sortButton.setTitle("START", for: .normal);
        sortButton.addTarget(self, action: #selector(sort), for: .touchUpInside);
        sortButton.backgroundColor = .blue;
        sortButton.setTitleColor(.white, for: .normal);
        view.addSubview(sortButton);
    }
    
    //MARK: Autolayout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        //Do not let the collection view to take up too much screen space...
        if(sortCollectionView.contentSize.height < view.frame.size.height / 2) {
            heightConstraint?.constant = sortCollectionView.contentSize.height;
        } else {
            sortCollectionView.scrollToItem(at: IndexPath(row: sortCollectionView.numberOfItems(inSection: 0) - 1, section: 0), at: .bottom, animated: true);
        }
    }
    
    internal func applyAutoLayoutConstraints() {
        
        sortCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        sortCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true;
        sortCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        
        heightConstraint = sortCollectionView.heightAnchor.constraint(equalToConstant: 0);
        heightConstraint?.isActive = true;
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false;
        minusButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 6).isActive = true;
        minusButton.leftAnchor.constraint(equalTo: sortCollectionView.rightAnchor, constant: 10).isActive = true;
        minusButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true;
        minusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        minusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false;
        plusButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor).isActive = true;
        plusButton.leftAnchor.constraint(equalTo: minusButton.leftAnchor).isActive = true;
        plusButton.rightAnchor.constraint(equalTo: minusButton.rightAnchor).isActive = true;
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        
        worstCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        worstCaseLabel.topAnchor.constraint(equalTo: sortCollectionView.bottomAnchor, constant: 10).isActive = true
        worstCaseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        
        worstCaseShowMe.translatesAutoresizingMaskIntoConstraints = false;
        worstCaseShowMe.centerYAnchor.constraint(equalTo: worstCaseLabel.centerYAnchor).isActive = true;
        worstCaseShowMe.leftAnchor.constraint(equalTo: worstCaseLabel.rightAnchor, constant: 10).isActive = true;
        worstCaseShowMe.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10).isActive = true;
        
        bestCaseShowMe.translatesAutoresizingMaskIntoConstraints = false;
        bestCaseShowMe.centerYAnchor.constraint(equalTo: bestCaseLabel.centerYAnchor).isActive = true;
        bestCaseShowMe.leftAnchor.constraint(equalTo: bestCaseLabel.rightAnchor, constant: 10).isActive = true;
        bestCaseShowMe.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10).isActive = true;
        
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
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false;
        clearButton.topAnchor.constraint(equalTo: logView.topAnchor).isActive = true;
        clearButton.rightAnchor.constraint(equalTo: logView.rightAnchor, constant: -10).isActive = true;
        
        stepBackButton.translatesAutoresizingMaskIntoConstraints = false;
        stepBackButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        stepBackButton.rightAnchor.constraint(equalTo: stepForwardButton.leftAnchor, constant: -20).isActive = true;
        stepBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        stepBackButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 6).isActive = true;
        
        stepForwardButton.translatesAutoresizingMaskIntoConstraints = false;
        stepForwardButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        stepForwardButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        stepForwardButton.widthAnchor.constraint(equalTo: stepBackButton.widthAnchor, multiplier: 1).isActive = true;
        stepForwardButton.heightAnchor.constraint(equalTo: stepBackButton.heightAnchor, multiplier: 1).isActive = true;
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false;
        resetButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        resetButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        resetButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 3).isActive = true;
        
        randomiseButton.translatesAutoresizingMaskIntoConstraints = false;
        randomiseButton.leftAnchor.constraint(equalTo: resetButton.rightAnchor).isActive = true;
        randomiseButton.bottomAnchor.constraint(equalTo: sortButton.topAnchor).isActive = true;
        randomiseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        randomiseButton.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.size.width / 3).isActive = true;
        
        
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
    
    internal func removeElement() {
        
        sortArray.removeLast();
        animateRemoveLastElement();
        didAddOrRemoveElement();
    }
    
    internal func addElement() {
        
        let randomNumber = Int(arc4random_uniform(50));
        sortArray.append(randomNumber);
        animateAppendElement();
        didAddOrRemoveElement();
    }
    
    internal func didAddOrRemoveElement() {
        
        if(sortArray.count <= kMinimumSortArrayLength) {
            minusButton.isHidden = true;
        } else {
            minusButton.isHidden = false;
        }
        
        //Check if another cell can be added to the collection view. If it cannot, then disable plus.
        let lastCell = sortCollectionView.cellForItem(at: IndexPath(row: sortCollectionView.numberOfItems(inSection: 0) - 1, section: 0));
        let rightPointOfNextCell = lastCell!.frame.origin.x + kCollectionViewLayoutWidthHeight + kCollectionViewLayoutWidthHeight + kCollectionViewLayoutLeftRightInset + kCollectionViewLayoutLeftRightInset;
        
        if(rightPointOfNextCell > (sortCollectionView.frame.origin.x + sortCollectionView.frame.size.width)) {
            plusButton.isHidden = true;
        } else {
            plusButton.isHidden = false;
        }
    }
    
    internal func showMeBest() {
        
        resetWith(newArray: Algorithm.bestCase);
        logView.pressedBest(array: Algorithm.bestCase);
    }
    
    internal func showMeWorst() {
        
        resetWith(newArray: Algorithm.worstCase);
        logView.pressedWorst(array: Algorithm.bestCase);
    }
    
    internal func createAnimations(moves: [Algorithm.MoveType]) -> [SortAnimation] {
        preconditionFailure("This method must be overridden!");
    }
    
    internal func sort() {
        
        if(didFinish) {
            reset()
            didFinish = false;
            return;
        }
        
        if(!isAnimating) {
            
            didStartSort();
            performForwardAnimation(step: animationStep, completion: nil);
        } else {
            
            didPauseSort();
        }
    }
    
    internal func randomise() {
        
        setupSortingArray(length: sortCollectionView.numberOfItems(inSection: 0));
        logView.pressedRandomise(array: sortArray);
        sortCollectionView.reloadData();
    }
    
    internal func reset() {
        
        logView.pressedReset();
        sortButton.setTitle("START", for: .normal);
        resetWith(newArray:  sortArray.map { $0 });
    }
    
    internal func resetWith(newArray: [Int]) {
        
        animationStep = 0;
        sortArray = newArray;
        sortCollectionView.reloadData();
    }
    
    internal func stepBack() {
        
        if(!isAnimating) {
            
            willStartAnimating(true);
            performBackwardAnimation(step: animationStep-1, completion: {
                self.willStartAnimating(false);
            });
        }
    }
    
    internal func stepForward() {
        
        if(!isAnimating) {
            willStartAnimating(true);
            performForwardAnimation(step: animationStep, completion: {
                self.willStartAnimating(false);
            })
        }
    }
    
    private func performForwardAnimation(step: Int, completion: (()->Void)?) {
        
        if(step < animationMoves.count && isAnimating) {
            
            let sortAnimation = animationMoves[step];
            
            switch(sortAnimation.type) {
            case .collectionView:
                self.sortCollectionView.performBatchUpdates(sortAnimation.animation, completion: { (didFinish) in
                    self.animationStep = self.animationStep + 1;
                    if(completion != nil) {
                        completion!();
                    } else {
                        
                        self.performForwardAnimation(step: self.animationStep, completion: nil);
                    }
                })
                break;
            case .defaultView:
                UIView.animate(withDuration: kAnimationDuration, delay: 0, options: .allowUserInteraction, animations: sortAnimation.animation, completion: { (didFinish) in
                    self.animationStep = self.animationStep + 1;
                    if(completion != nil) {
                        completion!();
                    } else {
                        self.performForwardAnimation(step: self.animationStep, completion: nil);
                    }
                })
                break;
            }
        } else if (step >= animationMoves.count) {
            didFinishSort();
        } else {
            didPauseSort();
        }
    }
    
    private func performBackwardAnimation(step: Int, completion: (()->Void)?) {
        
        if(step >= 0 && step < animationMoves.count && isAnimating) {
            
            let animationMove = animationMoves[step];
            var animation: SortAnimation.Animation;
            
            if animationMove.backAnimation != nil {
                animation = animationMoves[step].backAnimation!;
            } else {
                animation = animationMoves[step].animation;
            }
            
            switch(animationMove.type) {
            case .collectionView:
                self.sortCollectionView.performBatchUpdates(animation, completion: { (didFinish) in
                    self.animationStep = self.animationStep - 1;
                    if(completion != nil) {
                        completion!();
                    } else {
                        self.performBackwardAnimation(step: self.animationStep, completion: nil);
                    }
                })
                break;
            case .defaultView:
                UIView.animate(withDuration: kAnimationDuration, delay: 0, options: .allowUserInteraction, animations: animation, completion: { (didFinish) in
                    self.animationStep = self.animationStep - 1;
                    if(completion != nil) {
                        completion!();
                    } else {
                        self.performBackwardAnimation(step: self.animationStep, completion: nil);
                    }
                })
                break;
            }
        } else {
            willStartAnimating(false);
        }
    }
    
    private func didStartSort() {
     
        sortButton.setTitle("STOP", for: .normal);
        willStartAnimating(true);
    }
    
    private func didPauseSort() {
     
        willStartAnimating(false);
        sortButton.setTitle("CONTINUE", for: .normal);
    }
    
    private func didFinishSort() {
        
        didFinish = true;
        sortButton.setTitle("RESET", for: .normal);
        willStartAnimating(false);
    }
    
    private func willStartAnimating(_ willStart: Bool) {
        
        isAnimating = willStart;
        stepBackButton.isEnabled = !willStart;
        stepForwardButton.isEnabled = !willStart;
        plusButton.isEnabled = !willStart;
        minusButton.isEnabled = !willStart;
        resetButton.isEnabled = !willStart;
        randomiseButton.isEnabled = !willStart;
    }
    
    private func animateRemoveLastElement() {
        sortCollectionView.performBatchUpdates({
            self.sortCollectionView.deleteItems(at: [IndexPath(row: self.sortArray.count, section: 0)])
        }, completion: { (didComplete) in
            UIView.animate(withDuration: 0.5, animations: {
                self.view.setNeedsLayout();
                self.view.layoutIfNeeded();
            })
        })
    }
    
    private func animateAppendElement() {
        sortCollectionView.performBatchUpdates({
            self.sortCollectionView.insertItems(at: [IndexPath(row: self.sortArray.count-1, section: 0)]);
        }, completion: { (didComplete) in
            UIView.animate(withDuration: 0.5, animations: {
                self.view.setNeedsLayout();
                self.view.layoutIfNeeded();
            })
        })
    }
    
    internal func clear() {
        logView.clear();
    }
    
    internal func pressedMenu() {
        print("yup");
    }
}
