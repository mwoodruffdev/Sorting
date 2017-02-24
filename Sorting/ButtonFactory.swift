//
//  ButtonFactory.swift
//  Sorting
//
//  Created by Michael Woodruff on 24/02/2017.
//  Copyright © 2017 Mike Woodruff. All rights reserved.
//

import UIKit

class ButtonFactory {

    static func standardButton() -> UIButton {
        
        let standardButton = UIButton();
        standardButton.titleLabel?.font = .standardFont;
        standardButton.layer.borderColor = UIColor.white.cgColor
        standardButton.layer.borderWidth = 1;
        standardButton.backgroundColor = .black;
        standardButton.setTitleColor(.white, for: .normal);
        return standardButton;
    }
    
    static func standardButtonWith(text: String, target: Any?, action: Selector) -> UIButton {
        
        let standardButton = self.standardButton();
        standardButton.setTitle(text, for: .normal);
        standardButton.addTarget(target, action: action, for: .touchUpInside);
        return standardButton;
    }
    
    static func actionButton(text: String, target: Any?, action: Selector) -> UIButton {
        
        let highlightedButton = standardButtonWith(text: text, target: target, action: action);
        highlightedButton.titleLabel?.font = .actionButtonFont;
        highlightedButton.layer.cornerRadius = 10;
        highlightedButton.layer.shadowColor = UIColor.black.cgColor;
        highlightedButton.layer.shadowOffset = CGSize(width: 0, height: 3);
        highlightedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        highlightedButton.clipsToBounds = true;
        highlightedButton.backgroundColor = .white;
        highlightedButton.setTitleColor(.black, for: .normal);
        return highlightedButton
    }
    
    static func roundButton(text: String, target: Any?, action: Selector, width: CGFloat) -> UIButton {
        
        let roundButton = standardButtonWith(text: text, target: target, action: action);
        roundButton.titleLabel?.font = .actionButtonFont;
        roundButton.layer.cornerRadius = width/2;
        roundButton.layer.cornerRadius = 10;
        roundButton.layer.shadowColor = UIColor.black.cgColor;
        roundButton.layer.shadowOffset = CGSize(width: 0, height: 3);
        roundButton.clipsToBounds = true;
        roundButton.backgroundColor = .white;
        roundButton.setTitleColor(.black, for: .normal);
        return roundButton;
    }
}
