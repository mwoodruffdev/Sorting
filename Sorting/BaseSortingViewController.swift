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
    
    var animationMoves: [SortAnimation] = [];
    var isAnimating: Bool = false;
    var animationStep: Int = 0;
    
    //UI
    internal var sortCollectionView: UICollectionView!
    internal var minusButton: UIButton;
    internal var plusButton: UIButton;
    internal var stepBackButton: UIButton;
    internal var stepForwardButton: UIButton;
    internal var sortButton: UIButton;
    internal var logView: SortLogView;
    internal var worstCaseLabel: UILabel;
    internal var averageCaseLabel: UILabel;
    internal var bestCaseLabel: UILabel;
    internal var heightConstraint: NSLayoutConstraint?;

    
    init() {
    
        minusButton = UIButton();
        plusButton = UIButton();
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
        
        minusButton = UIButton();
        plusButton = UIButton();
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
        
        setupInitialSortingArray();
        setupViews();
        applyAutoLayoutConstraints();
    }
    
    internal func setupInitialSortingArray() {
        var tempArray = [Int]();
        
        for _ in 0...4 {
            let randomNumber = Int(arc4random_uniform(50));
            tempArray.append(randomNumber);
        }
        sortArray = tempArray;
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
        stepBackButton.rightAnchor.constraint(equalTo: stepForwardButton.leftAnchor, constant: -20).isActive = true;
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

    internal func removeElement() {
        
        if(sortArray.count > 3) {
            sortArray.removeLast();
            animateRemoveLastElement();
        }
    }
    
    internal func addElement() {
        let randomNumber = Int(arc4random_uniform(50));
        sortArray.append(randomNumber);
        animateAppendElement();
    }

    internal func createAnimations(moves: [Algorithm.MoveType]) -> [SortAnimation] {
        preconditionFailure("This method must be overridden!");
    }
    
    internal func sort() {
        
        if(!isAnimating) {
            sortButton.setTitle("Stop Sorting", for: .normal);
            isAnimating = true;
            performForwardAnimation(step: animationStep, completion: nil);
        } else {
            stopAnimating();
            sortButton.setTitle("Continue", for: .normal);
        }
    }
    
    internal func stepBack() {
     
        if(!isAnimating) {
            isAnimating = true;
            performBackwardAnimation(step: animationStep-1, completion: {
                self.stopAnimating();
            });
        }
    }
    
    internal func stepForward() {
        
        if(!isAnimating) {
            isAnimating = true;
            performForwardAnimation(step: animationStep, completion: {
                self.stopAnimating();
            })
        }
    }
    
    private func performForwardAnimation(step: Int, completion: (()->Void)?) {
        
        if(step < animationMoves.count && isAnimating) {
            
            stepBackButton.isEnabled = false;
            stepForwardButton.isEnabled = false;
            
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
        } else {
            stopAnimating()
        }
    }
    
    private func performBackwardAnimation(step: Int, completion: (()->Void)?) {
        
        if(step >= 0 && step < animationMoves.count && isAnimating) {
            
            stepBackButton.isEnabled = false;
            stepForwardButton.isEnabled = false;
            
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
            stopAnimating();
        }
    }
    
    private func stopAnimating() {
        
        isAnimating = false;
        stepBackButton.isEnabled = true;
        stepForwardButton.isEnabled = true;
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
}
