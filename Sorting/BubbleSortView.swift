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
    var elementSubviews: [UIView] = [];
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
            
            let elementView: UIView = UIView();
            elementView.layer.borderColor = UIColor.black.cgColor;
            elementView.layer.borderWidth = 1;
            addSubview(elementView);
            
            let elementValue: UILabel = UILabel();
            elementValue.text = "\(integer)";
            elementValue.tag = 1;
            elementView.addSubview(elementValue);
            
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
        
        var prevView: UIView? = nil;
        for elementView in elementSubviews {
            
            let elementValue = elementView.viewWithTag(1);
            elementValue?.translatesAutoresizingMaskIntoConstraints = false;
            elementValue?.centerXAnchor.constraint(equalTo: elementView.centerXAnchor).isActive = true;
            elementValue?.centerYAnchor.constraint(equalTo: elementView.centerYAnchor).isActive = true;
            
            elementView.translatesAutoresizingMaskIntoConstraints = false;
            elementView.topAnchor.constraint(equalTo: topAnchor).isActive = true;
            elementView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
            elementView.widthAnchor.constraint(equalToConstant: superview!.frame.size.width / CGFloat(valueArray.count)).isActive = true;
            
            if(prevView == nil) {
                
                elementView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true;
            } else {
                elementView.leftAnchor.constraint(equalTo: prevView!.rightAnchor).isActive = true;
            }
            
            if (elementView == elementSubviews.last) {
                
                elementView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true;
            }
            
            prevView = elementView;
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
                        
                        let viewOneOldConstraints = viewOne.constraints;
                        viewOne.removeConstraints(viewOne.constraints);
                        viewOne.addConstraints(viewTwo.constraints);
                    
                        viewTwo.removeConstraints(viewTwo.constraints);
                        viewTwo.addConstraints(viewOneOldConstraints);
                        
                        
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
}
