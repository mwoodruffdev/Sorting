//
//  SortLogView.swift
//  Sorting
//
//  Created by Michael Woodruff on 05/12/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class SortLogView: UITextView {

    func insertNewLine(text: String, color: UIColor) {
        
        let attributedText =  NSMutableAttributedString(string:text);
        attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedText.length));
        
        let currentText = NSMutableAttributedString(attributedString: self.attributedText);
        currentText.append(attributedText);
        currentText.append(NSAttributedString(string: "\n"));

        self.attributedText = currentText;
        
        let bottom = NSMakeRange(attributedText.length - 1, 1);
        self.scrollRangeToVisible(bottom);
    }
}
