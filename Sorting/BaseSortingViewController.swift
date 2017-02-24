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
    
    let kMaxCellsPerRow: CGFloat = 9;
    
    var animationMoves: [SortAnimation] = [];
    var isAnimating: Bool = false;
    var didFinish: Bool = false;
    var animationStep: Int = 0;
    
    //UI

    internal var sortCollectionView: UICollectionView!
    internal var minusButton = ButtonFactory.roundButton(text: "-", target: self, action: #selector(removeElement), width:25);
    internal var plusButton = ButtonFactory.roundButton(text: "+", target: self, action: #selector(addElement), width: 25);
    internal var stepBackButton = ButtonFactory.standardButtonWith(text: NSLocalizedString("back", comment: ""),
                                                                   target: self,
                                                                   action: #selector(pressedStepBack));
    internal var stepForwardButton = ButtonFactory.actionButton(text: ">",
                                                                      target: self,
                                                                      action: #selector(pressedStepForward));
    internal var randomiseButton = ButtonFactory.standardButtonWith(text: NSLocalizedString("randomise", comment: ""),
                                                                   target: self,
                                                                   action: #selector(pressedRandomise));
    internal var resetButton = ButtonFactory.standardButtonWith(text: NSLocalizedString("reset", comment: ""),
                                                               target: self,
                                                               action: #selector(pressedReset));
    internal var sortButton = ButtonFactory.standardButtonWith(text: NSLocalizedString("start", comment: ""),
                                                              target: self,
                                                              action: #selector(pressedSort));
    internal var clearButton = UIButton();
                                                                
    internal var logView = SortLogView();
    internal var worstCaseLabel = UILabel();
    internal var worstCaseShowMe = ButtonFactory.actionButton(text: NSLocalizedString("show_me", comment: ""),
                                                                    target: self,
                                                                    action: #selector(pressedShowMeWorst));
    internal var bestCaseLabel = UILabel();
    internal var bestCaseShowMe = ButtonFactory.actionButton(text: NSLocalizedString("show_me", comment: ""),
                                                                   target: self,
                                                                   action: #selector(pressedShowMeBest));
    
    let kCollectionViewLayoutTopBottomInset: CGFloat = 6;
    //Constraints
    internal var heightConstraint: NSLayoutConstraint?;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        title = Algorithm.name;
        view.backgroundColor = .mainBGColor;
        automaticallyAdjustsScrollViewInsets = false;
        
        setupSortingArray(length: 5);
        setupViews();
        applyAutoLayoutConstraints();
    }
    
    internal func setupSortingArray(length: Int) {

        sortArray = InputArrays.randomInputArray(length: length);
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsPerRow: CGFloat = kMaxCellsPerRow;
        let totalWidth = sortCollectionView.frame.size.width;
        let individualTotalWidth  = (totalWidth / cellsPerRow);
        let inset = individualTotalWidth / 10;
        let widthAfterInset = individualTotalWidth - (2 * inset);
        return CGSize(width: widthAfterInset, height: widthAfterInset);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     
        let cellsPerRow: CGFloat = kMaxCellsPerRow;
        let totalWidth = sortCollectionView.frame.size.width;
        let individualTotalWidth  = (totalWidth / cellsPerRow);
        let inset = individualTotalWidth / 10;
        return UIEdgeInsets(top: kCollectionViewLayoutTopBottomInset,
                            left: inset,
                            bottom: kCollectionViewLayoutTopBottomInset,
                            right: inset)
    }
    
    internal func setupViews() {
        
        setupCollectionView();
        setupComplexityLabels()
        setupLogView();
        setupButtons();
    }
    
    internal func setupCollectionView() {
        
        //Default layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCollectionViewLayoutTopBottomInset,
                                           left: 3,
                                           bottom: kCollectionViewLayoutTopBottomInset,
                                           right: 3)
        layout.itemSize = CGSize(width: 30, height: 30)
        
        sortCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        sortCollectionView.backgroundColor = .clear;
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        registerCells();
        sortCollectionView.backgroundColor = .white
        self.view.addSubview(sortCollectionView)
    }
    
    internal func registerCells() {
        sortCollectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    internal func setupLogView() {
        
        logView.text = NSLocalizedString("logger_intro_text", comment: "");
        view.addSubview(logView);
    }
    
    internal func setupComplexityLabels() {
        
        let worstCase = NSMutableAttributedString(string: NSLocalizedString("worst_case_label", comment: ""));
        worstCase.append(Algorithm.worstComplexity);
        worstCaseLabel.font = .standardFont;
        worstCaseLabel.attributedText = worstCase;
        worstCaseLabel.textColor = .white;
        view.addSubview(worstCaseLabel);
        
        let bestCase = NSMutableAttributedString(string: NSLocalizedString("best_case_label", comment: ""));
        bestCase.append(Algorithm.bestComplexity);
        bestCaseLabel.font = .standardFont;
        bestCaseLabel.attributedText = bestCase;
        bestCaseLabel.textColor = .white;
        view.addSubview(bestCaseLabel);
    }
    
    internal func setupButtons() {
        
        clearButton.titleLabel?.font = .standardFont;
        clearButton.setTitleColor(.blue, for: .normal);
        clearButton.setTitle(NSLocalizedString("clear", comment: ""), for: .normal);
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside);
        clearButton.titleLabel?.font = .standardFont;
        view.addSubview(clearButton);
        
        minusButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 40);
        view.addSubview(minusButton);
        plusButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 25);
        view.addSubview(plusButton);
        view.addSubview(worstCaseShowMe);
        view.addSubview(bestCaseShowMe);
        /* Hide back feature for now */
        stepBackButton.isHidden = true;
        /* Hide back feature for now */
        view.addSubview(stepBackButton);
        stepForwardButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 25);
        view.addSubview(stepForwardButton);
        view.addSubview(randomiseButton);
        view.addSubview(resetButton);
        view.addSubview(sortButton);
        
        resetButtonState();
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
        
        applyCollectionViewConstraints();
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false;
        minusButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true;
        minusButton.leftAnchor.constraint(equalTo: sortCollectionView.rightAnchor, constant: 10).isActive = true;
        minusButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true;
        minusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        minusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false;
        plusButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: 5).isActive = true;
        plusButton.leftAnchor.constraint(equalTo: minusButton.leftAnchor).isActive = true;
        plusButton.rightAnchor.constraint(equalTo: minusButton.rightAnchor).isActive = true;
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        
        worstCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        worstCaseLabel.centerYAnchor.constraint(equalTo: worstCaseShowMe.centerYAnchor).isActive = true;
        worstCaseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true;
        
        worstCaseShowMe.translatesAutoresizingMaskIntoConstraints = false;
        worstCaseShowMe.topAnchor.constraint(equalTo: sortCollectionView.bottomAnchor, constant: 5).isActive = true
        worstCaseShowMe.leftAnchor.constraint(equalTo: worstCaseLabel.rightAnchor, constant: 10).isActive = true;
        worstCaseShowMe.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true;
        worstCaseShowMe.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10).isActive = true;
        
        bestCaseShowMe.translatesAutoresizingMaskIntoConstraints = false;
        bestCaseShowMe.topAnchor.constraint(equalTo: worstCaseShowMe.bottomAnchor, constant: 5).isActive = true;
        bestCaseShowMe.leftAnchor.constraint(equalTo: bestCaseLabel.rightAnchor, constant: 10).isActive = true;
        bestCaseShowMe.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true;
        bestCaseShowMe.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10).isActive = true;
        
        bestCaseLabel.translatesAutoresizingMaskIntoConstraints = false;
        bestCaseLabel.centerYAnchor.constraint(equalTo: bestCaseShowMe.centerYAnchor).isActive = true;
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
    
    internal func applyCollectionViewConstraints() {
        
        sortCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        sortCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true;
        sortCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        heightConstraint = sortCollectionView.heightAnchor.constraint(equalToConstant: 0);
        heightConstraint?.isActive = true;
    }
    
    internal func resetButtonState() {
        
        worstCaseShowMe.isEnabled = true;
        bestCaseShowMe.isEnabled = true;
        minusButton.isEnabled = true;
        plusButton.isEnabled = true;
        resetButton.isEnabled = false;
        randomiseButton.isEnabled = true;
        stepBackButton.isEnabled = false;
        stepForwardButton.isEnabled = true;
        sortButton.isEnabled = true;
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
            cell.backgroundColor = .black;
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
        let widthHeight = sortCollectionView.collectionViewLayout.collectionViewContentSize.height;

        let lastCell = sortCollectionView.cellForItem(at: IndexPath(row: sortCollectionView.numberOfItems(inSection: 0) - 1, section: 0));
        
        let rightPointOfNextCell = lastCell!.frame.origin.x + widthHeight;
        let rightSideOfCollectionView = sortCollectionView.frame.origin.x + sortCollectionView.frame.size.width;
        
        if(rightPointOfNextCell > (rightSideOfCollectionView)) {
            plusButton.isHidden = true;
        } else {
            plusButton.isHidden = false;
        }
    }
    
    internal func pressedShowMeBest() {
        
        resetWith(newArray: Algorithm.bestCase);
        logView.pressedBest(array: Algorithm.bestCase);
    }
    
    internal func pressedShowMeWorst() {
        
        resetWith(newArray: Algorithm.worstCase);
        logView.pressedWorst(array: Algorithm.bestCase);
    }
    
    internal func createAnimations(moves: [Algorithm.MoveType]) -> [SortAnimation] {
        preconditionFailure("This method must be overridden!");
    }
    
    internal func pressedSort() {
        
        if(didFinish) {
            resetWith(newArray:  sortArray.map { $0 });
            return;
        }
        
        if(!isAnimating) {
            
            didStartSort();
            performForwardAnimation(step: animationStep, completion: nil);
        } else {
            
            didPauseSort();
        }
    }
    
    internal func pressedRandomise() {
        
        logView.pressedRandomise(array: sortArray);
        resetWith(newArray: InputArrays.randomInputArray(length: sortArray.count))
    }
    
    internal func pressedReset() {
        
        logView.pressedReset();
        resetWith(newArray:  sortArray.map { $0 });
    }
    
    internal func resetWith(newArray: [Int]) {
        
        sortButton.setTitle(NSLocalizedString("start", comment: ""), for: .normal);
        animationStep = 0;
        sortArray = newArray;
        sortCollectionView.reloadData();
        resetButtonState();
        didFinish = false;
    }
    
    internal func pressedStepBack() {
        
        if(!isAnimating) {
            
            willStartAnimating(true);
            performBackwardAnimation(step: animationStep-1, completion: {
                self.willStartAnimating(false);
            });
        }
    }
    
    internal func pressedStepForward() {
        
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
     
        sortButton.setTitle(NSLocalizedString("stop", comment: ""), for: .normal);
        willStartAnimating(true);
    }
    
    private func didPauseSort() {
     
        willStartAnimating(false);
        sortButton.setTitle(NSLocalizedString("continue", comment: ""), for: .normal);
    }
    
    private func didFinishSort() {
        
        didFinish = true;
        sortButton.setTitle(NSLocalizedString("reset", comment: ""), for: .normal);
        willStartAnimating(false);
    }
    
    private func willStartAnimating(_ willStart: Bool) {
        
        isAnimating = willStart;
        stepBackButton.isEnabled = !willStart;
        stepForwardButton.isEnabled = !willStart;
        plusButton.isEnabled = false;
        minusButton.isEnabled = false;
        resetButton.isEnabled = !willStart;
        randomiseButton.isEnabled = !willStart;
        bestCaseShowMe.isEnabled = !willStart;
        worstCaseShowMe.isEnabled = !willStart;
    }
    
    private func animateRemoveLastElement() {
        sortCollectionView.performBatchUpdates({
            self.sortCollectionView.deleteItems(at: [IndexPath(row: self.sortArray.count, section: 0)])
        }, completion: { (didComplete) in
            UIView.animate(withDuration: self.kAnimationDuration, animations: {
                self.view.setNeedsLayout();
                self.view.layoutIfNeeded();
            })
        })
    }
    
    private func animateAppendElement() {
        sortCollectionView.performBatchUpdates({
            self.sortCollectionView.insertItems(at: [IndexPath(row: self.sortArray.count-1, section: 0)]);
        }, completion: { (didComplete) in
            UIView.animate(withDuration: self.kAnimationDuration, animations: {
                self.view.setNeedsLayout();
                self.view.layoutIfNeeded();
            })
        })
    }
    
    internal func clear() {
        logView.clear();
    }
}
