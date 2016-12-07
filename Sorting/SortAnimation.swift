//
//  SortAnimation.swift
//  Sorting
//
//  Created by Michael Woodruff on 07/12/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

struct SortAnimation {

    typealias Animation = () -> Void
    var animation: Animation;
    var type: AnimationType;
    
    enum AnimationType {
        case collectionView, defaultView;
    }
}
