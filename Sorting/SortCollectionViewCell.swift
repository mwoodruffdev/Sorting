//
//  SortCollectionViewCell.swift
//  Sorting
//
//  Created by Michael Woodruff on 08/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class SortCollectionViewCell: UICollectionViewCell {
    
    var valueLabel: UILabel!;
    var sorted: Bool = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        contentView.layer.borderColor = UIColor.black.cgColor;
        contentView.layer.borderWidth = 1;
        
        valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        valueLabel.textAlignment = .center;
        valueLabel.textColor = UIColor.white;
        valueLabel.adjustsFontSizeToFitWidth = true;
        contentView.addSubview(valueLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
