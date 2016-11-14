//
//  QuickSortViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

class QuickSortViewController: UIViewController, SortingViewController {
    
    internal var sortArray: [Int] = [3, 1, 0, 4, 2,1,6,8,12,6,3,1,7,3];
    internal var sortCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.green;
        
        let qs: QuickSort = QuickSort(unsortedArray: sortArray);
        qs.sort();
    }
    
    func sort() {
        
    }
}
