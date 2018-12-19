//
//  DemoTableCell.h
//  DemoContainerView
//
//  Created by Рустам Мотыгуллин on 21/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UILabel *labelSubTitle;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) UIImageView *imageAvatar;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

