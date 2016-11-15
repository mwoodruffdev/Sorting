//
//  QuickSortCollectionViewCell.swift
//  Sorting
//
//  Created by Michael Woodruff on 15/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class QuickSortCollectionViewCell: SortCollectionViewCell {

    var leftWall: UIView;
    var rightWall: UIView;
    var isPivot: Bool = false;
    
    override init(frame: CGRect) {
        

        leftWall = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: frame.size.height));
        leftWall.backgroundColor = UIColor.orange;
        leftWall.isHidden = true;
        
        rightWall = UIView(frame: CGRect(x: frame.size.width-2, y: 0, width: 2, height: frame.size.height));
        rightWall.backgroundColor = UIColor.orange;
        rightWall.isHidden = true;
        
        super.init(frame: frame);
        
        contentView.addSubview(leftWall);
        contentView.addSubview(rightWall);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideWalls() {
        
        leftWall.isHidden = true;
        rightWall.isHidden = true;
    }
}
