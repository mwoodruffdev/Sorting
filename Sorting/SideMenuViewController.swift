//
//  SideMenuViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import UIKit

protocol SideMenuViewControllerDelegate: class {
    
    func didSelectViewController(viewController: UIViewController);
}

class SideMenuViewController: UITableViewController {
    
    weak var delegate: SideMenuViewControllerDelegate?;
    var selectedIndex: Int = 0 {
        didSet {
            didUpdateIndex();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        selectedIndex = 0;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row != self.selectedIndex) {
            
            selectedIndex = indexPath.row;
        }
    }
    
    internal func didUpdateIndex() {
        
        var selectedViewController: UIViewController;
        
        switch(selectedIndex) {
            case 0:

                selectedViewController = BubbleSortViewController();
                break;
            case 1:
                selectedViewController = QuickSortViewController();
                break;
            case 2:
                selectedViewController = MergeSortViewController();
                break;
            case 3:
                selectedViewController = InsertionSortViewController();
                break;
            default:
                selectedViewController = BubbleSortViewController();
                break;
        }
        
        delegate?.didSelectViewController(viewController: selectedViewController);
    }
}
