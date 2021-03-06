//
//  MainViewController.swift
//  Sorting
//
//  Created by Michael Woodruff on 02/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import Foundation
import MFSideMenu
import UIKit

class MainViewController: UIViewController, SideMenuViewControllerDelegate {
    
    var containerController: MFSideMenuContainerViewController?;
    var selectedViewController: UIViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        if let sideMenuViewController: SideMenuViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController {
            
            sideMenuViewController.delegate = self;
            containerController = MFSideMenuContainerViewController.container(withCenter: selectedViewController, leftMenuViewController: sideMenuViewController, rightMenuViewController: nil);
            
            addChildViewController(containerController!);
            containerController!.view.frame = view.frame;
            view.addSubview(containerController!.view);
            containerController!.didMove(toParentViewController: self);
        }
    }
    
    func didSelectViewController(viewController: UIViewController) {
        
        let navController = UINavigationController(rootViewController: viewController);
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(pressedMenu));
        
        selectedViewController = navController;
        containerController?.centerViewController = selectedViewController;
    }
    
    internal func pressedMenu() {
        
        if(containerController?.menuState == MFSideMenuStateClosed) {
            containerController?.menuState = MFSideMenuStateLeftMenuOpen;
        } else {
            containerController?.menuState = MFSideMenuStateClosed;
        }
    }
}
