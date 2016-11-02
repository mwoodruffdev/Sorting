//
//  BubbleSortView.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSortView: UIView {
    
    var valueArray: [Int];
    var sortMoveArray: [BubbleSortMove];
    var elementSubviews: [BubbleSortIndexView] = [];
    var animationArray:[AnimationBlock]?;
    
    
    typealias AnimationBlock = () -> Void;
    
    init(valueArray: [Int], sortMoveArray: [BubbleSortMove]) {
        
        self.valueArray = valueArray;
        self.sortMoveArray = sortMoveArray;
        super.init(frame: CGRect.zero);
        setupView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupView() {
        
        backgroundColor = UIColor.green;
        setupSubViews();
    }
    
    internal func setupSubViews() {
        for integer in valueArray {
            
            let elementView: BubbleSortIndexView = BubbleSortIndexView(value: integer);
            addSubview(elementView);
            
            elementSubviews.append(elementView);
        }
    }
    
    override func didMoveToSuperview() {
        
        super.didMoveToSuperview();
        
        if(superview != nil) {
            
            setupSelfConstraints();
            setupSubviewConstraints();
            animationArray = setupAnimations();
            startAnimation();
        }
    }
    
    internal func setupSelfConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false;
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: 50).isActive = true;
        leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true;
        rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true;
        heightAnchor.constraint(equalToConstant: superview!.frame.size.width / CGFloat(valueArray.count)).isActive = true;
    }
    
    internal func setupSubviewConstraints() {
        
        for (i, elementView) in elementSubviews.enumerated() {
            
            let width = superview!.frame.size.width / CGFloat(valueArray.count);
            
            let elementValue = elementView.viewWithTag(1);
            elementValue?.translatesAutoresizingMaskIntoConstraints = false;
            elementValue?.centerXAnchor.constraint(equalTo: elementView.centerXAnchor).isActive = true;
            elementValue?.centerYAnchor.constraint(equalTo: elementView.centerYAnchor).isActive = true;
            
            elementView.translatesAutoresizingMaskIntoConstraints = false;
            elementView.topAnchor.constraint(equalTo: topAnchor).isActive = true;
            elementView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
            elementView.widthAnchor.constraint(equalToConstant: width).isActive = true;
            
            let leftAnchorConstant = width * CGFloat(i);
            elementView.updateLeft(constant: leftAnchorConstant);
        }
    }
    
    func setupAnimations() -> [AnimationBlock]{
        
        var animationArray: [AnimationBlock] = [];
        for sortMove in sortMoveArray {
            
            var animationAction: AnimationBlock?;
            
            switch(sortMove.moveType) {
                case .checking:
                    animationAction = {
                        
                        for view in self.elementSubviews {
                            
                            view.backgroundColor = UIColor.clear;
                        }
                        
                        let viewOne = self.elementSubviews[sortMove.positionOne.index]
                        viewOne.backgroundColor = UIColor.red;
                        let viewTwo = self.elementSubviews[sortMove.positionTwo!.index];
                        viewTwo.backgroundColor = UIColor.red;
                    }
                    animationArray.append(animationAction!);
                    break;
                case .sortedFrom:
                    break;
                case .swap:
                    
                    animationAction = {
                        
                        let viewOne = self.elementSubviews[sortMove.positionOne.index];
                        let viewTwo = self.elementSubviews[sortMove.positionTwo!.index];

                        swap(&self.elementSubviews[sortMove.positionOne.index], &self.elementSubviews[sortMove.positionTwo!.index])
                        
                        let width = self.superview!.frame.size.width / CGFloat(self.valueArray.count);

                        let viewTwoLA = CGFloat(sortMove.positionOne.index) * width;
                        viewTwo.updateLeft(constant: viewTwoLA);
                        //viewTwo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: viewTwoLA).isActive = true;
                        
                        
                        let viewOneLA = CGFloat(sortMove.positionTwo!.index) * width;
                        viewOne.updateLeft(constant: viewOneLA);
                        //viewOne.leftAnchor.constraint(equalTo: self.leftAnchor, constant: viewOneLA).isActive = true;
                        
                        self.setNeedsLayout();
                        self.layoutIfNeeded();
                    }
                    
                    animationArray.append(animationAction!);
                    break;
            }
        }
        
        return animationArray;
    }
    
    func startAnimation() {
        
        UIView.animate(withDuration: 2, animations: (self.animationArray![0]), completion: { (isComplete) in
            if(isComplete) {
                self.animateAtIndex(index: 1);
            }
        })
    }
    
    internal func animateAtIndex(index: Int) {
    
        UIView.animate(withDuration: 2, animations: self.animationArray![index], completion: {(isComplete) in
            if(isComplete) {
                if(index - 1 < self.animationArray!.count) {
                    self.animateAtIndex(index: index+1);
                }
            }
        });
    }
    
    class BubbleSortIndexView: UIView {
        
        var valueLabel: UILabel;
        var leftConstraint: NSLayoutConstraint?;
        
        init(value: Int) {
            
            valueLabel = UILabel();
            valueLabel.text = "\(value)";
            valueLabel.tag = 1;
            super.init(frame: CGRect.zero);
            self.layer.borderColor = UIColor.black.cgColor;
            self.layer.borderWidth = 1;
            addSubview(valueLabel);
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview();
            if(superview != nil) {
                
            }
        }
        
        func updateLeft(constant: CGFloat) {
     
            if(leftConstraint == nil) {
                leftConstraint = leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: constant);
                leftConstraint?.isActive = true;
            } else {
                
                leftConstraint?.constant = constant;
            }
        }
    }
}
