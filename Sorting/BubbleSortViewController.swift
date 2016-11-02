//
//  BubbleSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class BubbleSortViewController: UIViewController, SortingViewController {

    let sortArray = [3, 1, 0, 4, 2];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.red;
        
        let bubbleSort = BubbleSort(unsortedArray: sortArray);
        let sortingQueue = bubbleSort.sort();
        
        let bubbleSortView = BubbleSortView(valueArray: sortArray, sortMoveArray: sortingQueue);
        view.addSubview(bubbleSortView);
    }
    
    func sort() {
        
    } 
}
