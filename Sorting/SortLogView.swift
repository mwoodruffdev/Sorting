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
    
    func insertComparison(first: Int, second: Int, sign: String) {
        insertNewLine(text: "COMPARISON: \(first) \(sign) \(second)?", color: .red);
    }
    
    func insertSorted(text: String) {
        insertNewLine(text: "SORTED: \(text)", color: .green);
    }
    
    func insertSwap(first: Int, second: Int) {
        insertNewLine(text: "SWAP: \(first) and index \(second)", color: .black)
    }
    
    func insertSwap(text: String) {
        insertNewLine(text: "SWAP: \(text)", color: .black);
    }
    
    func insertPointer(text: String) {
        insertNewLine(text: text, color: .orange);
    }
    
    func insertLPointer(text: String) {
        insertPointer(text: "L POINTER: \(text)");
    }
    
    func insertRPointer(text: String) {
        insertPointer(text: "R POINTER: \(text)");
    }
    
    func insertLRPointer(text: String) {
        insertPointer(text: "L&R POINTER: \(text)");
    }
    
    func insertPivot(text: String) {
        insertNewLine(text: "PIVOT: \(text)", color: .blue);
    }
    
    func clear() {
        text = "";
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
