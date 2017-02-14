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
    var chosen: Bool = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        contentView.layer.borderColor = UIColor.black.cgColor;
        contentView.layer.borderWidth = 1;
        
        valueLabel = UILabel()
        valueLabel.textAlignment = .center;
        valueLabel.textColor = UIColor.white;
        valueLabel.adjustsFontSizeToFitWidth = true;
        contentView.addSubview(valueLabel);
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false;
        valueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true;
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true;
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true;
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSortedCell() -> Bool {
        return backgroundColor == .green;
    }
}
