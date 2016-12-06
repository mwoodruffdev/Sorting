//
//  SortLogView.swift
//  Sorting
//
//  Created by Michael Woodruff on 05/12/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class SortLogView: UITextView, UITextViewDelegate {

    var didDrag: Bool = false;
    
    init() {
        
        super.init(frame: CGRect.zero, textContainer: nil);
        delegate = self;
        layoutManager.allowsNonContiguousLayout = false;
        isEditable = false;
        layer.borderWidth = 1;
        layer.borderColor = UIColor.black.cgColor;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func insertNewLine(text: String, color: UIColor) {
        
        let attributedText =  NSMutableAttributedString(string:text);
        attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedText.length));
        
        let currentText = NSMutableAttributedString(attributedString: self.attributedText);
        currentText.append(NSAttributedString(string: "\n"));
        currentText.append(attributedText);

        self.attributedText = currentText;
        
        if(!didDrag) {
            scrollRangeToVisible(NSMakeRange(currentText.length - 1, 1));
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        didDrag = true;
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scrollViewHeight = frame.size.height;
        let contentSizeHeight = contentSize.height;
        let offset = contentOffset.y;
        
        if(offset + scrollViewHeight >= contentSizeHeight) {
            didDrag = false;
        }
    }
}
