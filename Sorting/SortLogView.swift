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
        font = .standardFont;
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
        insertNewLine(text: String(format: NSLocalizedString("logger_action_comparison", comment: ""), first, sign, second),
                      color: .comparisonLogTextColor);
    }
    
    func insertSorted(text: String) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_sorted", comment: ""), text),
                      color: .sortedLogTextColor);
    }
    
    func insertSorted(arr: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_sorted", comment: ""), StringHelpers.stringifyArray(array: arr)),
                      color: .sortedLogTextColor);
    }
    
    func insertSplit(count: Int) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_split", comment: ""), count),
                      color: .standardLogTextColor);
    }
    
    func insertSwap(first: Int, second: Int) {
        insertSwap(text: String(format: NSLocalizedString("logger_action_swap_default", comment: ""), first, second));
    }
    
    func insertSwap(text: String) {
        insertNewLine(text: "\(String(format: NSLocalizedString("logger_action_swap", comment: "")))\(text)",
            color: .standardLogTextColor);
    }
    
    func insertLSwap() {
        insertNewLine(text: "\(NSLocalizedString("logger_action_swap_L_P", comment: "")) \(NSLocalizedString("logger_action_swap_left_and_pivot", comment: ""))", color: .standardLogTextColor);
    }
    
    func insertLRSwap() {
        insertNewLine(text: "\(NSLocalizedString("logger_action_swap_L_R", comment: "")) \(NSLocalizedString("logger_action_swap_left_and_right", comment: ""))", color: .standardLogTextColor);
    }
    
    func insertPointer(text: String) {
        insertNewLine(text: text,
                      color: .leftRightPointerTextColor);
    }
    
    func insertLPointer(text: String) {
        insertPointer(text: String(format: NSLocalizedString("logger_action_left_pointer", comment: ""), text));
    }
    
    func insertRPointer(text: String) {
        insertPointer(text: String(format: NSLocalizedString("logger_action_right_pointer", comment: ""), text));
    }
    
    func insertLRPointer(text: String) {
        insertPointer(text: String(format: NSLocalizedString("logger_action_left_and_right_pointer", comment: ""), text));
    }
    
    func insertMerge(left: [Int], right: [Int]) {
        
        insertNewLine(text: String(format: NSLocalizedString("logger_action_merge", comment: ""), StringHelpers.stringifyArray(array: left), StringHelpers.stringifyArray(array: right)), color: .standardLogTextColor);
    }
    
    func insertPivot(text: String) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_pivot", comment: ""), text),
                      color: .pivotLogTextColor);
    }
    
    func pressedReset() {
        insertNewLine(text: NSLocalizedString("logger_action_reset", comment: ""),
                      color: .standardLogTextColor);
    }
    
    func pressedRandomise(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_randomise", comment: ""), StringHelpers.stringifyArray(array: array)), color: .standardLogTextColor);
    }
    
    func pressedBest(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_best_case", comment: ""), StringHelpers.stringifyArray(array: array)), color: .standardLogTextColor);
    }
    
    func pressedWorst(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_worst_case", comment: ""), StringHelpers.stringifyArray(array: array)), color: .standardLogTextColor);
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
