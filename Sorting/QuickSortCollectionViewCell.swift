//
//  QuickSortCollectionViewCell.swift
//  Sorting
//
//  Created by Michael Woodruff on 15/11/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

class QuickSortCollectionViewCell: UICollectionViewCell {

    
    var valueLabel: UILabel!;
    var lrLabel: UILabel!;
    
    var isPivot: Bool = false;
    var isSorted: Bool = false;
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        contentView.layer.borderColor = UIColor.black.cgColor;
        contentView.layer.borderWidth = 1;
        
        valueLabel = UILabel();
        valueLabel.textAlignment = .center;
        valueLabel.textColor = UIColor.white;
        valueLabel.adjustsFontSizeToFitWidth = true;
        
        lrLabel = UILabel();
        lrLabel.textAlignment = .center;
        lrLabel.textColor = UIColor.white;
        lrLabel.adjustsFontSizeToFitWidth = true;
        
        contentView.addSubview(lrLabel);
        contentView.addSubview(valueLabel);
        
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false;
        valueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true;
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true;
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true;
        valueLabel.heightAnchor.constraint(equalToConstant: frame.size.height / 2).isActive = true;
        
        lrLabel.translatesAutoresizingMaskIntoConstraints = false;
        lrLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true;
        lrLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true;
        lrLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true;
        lrLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAsL() {
        lrLabel.fadeTransition(duration: 1);
        lrLabel.text = "L";
    }
    
    func setAsR() {
        lrLabel.fadeTransition(duration: 1);
        lrLabel.text = "R";
    }
    
    func setAsLAndR() {
        lrLabel.fadeTransition(duration: 1);
        lrLabel.text = "LR";
    }
    
    func resetLR() {
        lrLabel.fadeTransition(duration: 1);
        lrLabel.text = "";
    }
}
