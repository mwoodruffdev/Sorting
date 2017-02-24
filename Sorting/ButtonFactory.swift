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
        standardButton.titleLabel?.font = Fonts.standardFont();
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
    
    static func highlightedButton(text: String, target: Any?, action: Selector) -> UIButton {
        
        let highlightedButton = UIButton();
        highlightedButton.setTitle(text, for: .normal);
        highlightedButton.setTitleColor(.blue, for: .normal);
        highlightedButton.addTarget(target, action: action, for: .touchUpInside);
        return highlightedButton
    }
}
