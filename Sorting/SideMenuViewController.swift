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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        cell.textLabel?.font = .standardFont;
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row != self.selectedIndex) {
            
            selectedIndex = indexPath.row;
        }
    }
    
    internal func didUpdateIndex() {
        
        switch(selectedIndex) {
        case 0:
            
            delegate?.didSelectViewController(viewController: BubbleSortViewController());
            break;
        case 1:
            delegate?.didSelectViewController(viewController: QuickSortViewController());
            break;
        case 2:
            delegate?.didSelectViewController(viewController: MergeSortViewController());
            break;
        case 3:
            delegate?.didSelectViewController(viewController: InsertionSortViewController());
            break;
        default:
            delegate?.didSelectViewController(viewController: BubbleSortViewController());
            break;
        }
    }
}
