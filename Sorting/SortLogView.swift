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
        insertNewLine(text: String(format: NSLocalizedString("logger_action_comparison", comment: ""), first, sign, second), color: .red);
    }
    
    func insertSorted(text: String) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_sorted", comment: ""), text),  color: .green);
    }
    
    func insertSorted(arr: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_sorted", comment: ""), stringifyArray(array: arr)),  color: .green);
    }
    
    func insertSplit(count: Int) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_split", comment: ""), count), color: UIColor.black);
    }
    
    func insertSwap(first: Int, second: Int) {
        insertSwap(text: String(format: NSLocalizedString("logger_action_swap_default", comment: ""), first, second));
    }
    
    func insertSwap(text: String) {
        insertNewLine(text: "\(String(format: NSLocalizedString("logger_action_swap", comment: "")))\(text)", color: .black);
    }
    
    func insertPointer(text: String) {
        insertNewLine(text: text, color: .orange);
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
        
        insertNewLine(text: String(format: NSLocalizedString("logger_action_merge", comment: ""), stringifyArray(array: left), stringifyArray(array: right)), color: UIColor.black);
    }
    
    func insertPivot(text: String) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_pivot", comment: ""), text), color: .blue);
    }
    
    func pressedReset() {
        insertNewLine(text: NSLocalizedString("logger_action_reset", comment: ""), color: .black);
    }
    
    func pressedRandomise(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_randomise", comment: ""), stringifyArray(array: array)), color: .black);
    }
    
    func pressedBest(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_best_case", comment: ""), stringifyArray(array: array)), color: .black);
    }
    
    func pressedWorst(array: [Int]) {
        insertNewLine(text: String(format: NSLocalizedString("logger_action_worst_case", comment: ""), stringifyArray(array: array)), color: .black);
    }
    
    func stringifyArray(array: [Int]) -> String {
        var outputString = "[";
        array.forEach({
            outputString = outputString + "\($0), ";
        });
        
        let start = outputString.index(outputString.endIndex, offsetBy: -2)
        let end = outputString.index(outputString.endIndex, offsetBy: 0)
        
        return outputString.replacingCharacters(in: start..<end, with: "]");
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
