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

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.red;
        let bubbleSort = BubbleSort(unsortedArray: [3, 1, 0, 4, 2]);
        bubbleSort.sort();
    }
    
    func sort() {
        
    } 
}
