//
//  SortAnimation.swift
//  Sorting
//
//  Created by Michael Woodruff on 07/12/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

import UIKit

protocol SortAnimation {

    typealias Animation = () -> Void
    var animation: Animation { get set };
    var type: AnimationType { get set };
}

struct CollectionViewSortAnimation: SortAnimation {
    
    internal var animation: SortAnimation.Animation
    internal var type: AnimationType

    init(_ animation: @escaping SortAnimation.Animation) {
        self.animation = animation;
        self.type = .collectionView;
    }
}

struct ViewSortAnimation: SortAnimation {
    
    internal var animation: SortAnimation.Animation
    internal var type: AnimationType
    
    init(_ animation: @escaping SortAnimation.Animation) {
        self.animation = animation;
        self.type = .defaultView;
    }
}

enum AnimationType {
    case collectionView, defaultView;
}
