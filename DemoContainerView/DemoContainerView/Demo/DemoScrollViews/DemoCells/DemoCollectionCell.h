//
//  DemoCollectionCell.h
//  DemoContainerView
//
//  Created by Рустам Мотыгуллин on 21/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end
