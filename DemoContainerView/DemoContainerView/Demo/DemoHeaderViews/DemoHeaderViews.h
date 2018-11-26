//
//  DemoHeaders.h
//  DemoContainerView
//
//  Created by Rustam Motygullin on 17/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContainerTypes.h"

@interface HeaderLabel : UIView
 @property (nonatomic, strong) UILabel *label;
 @property (nonatomic, strong) UIView *separatorLine;
 @property (nonatomic, strong) UIView *grip;
@end


@interface HeaderSearch : UIView
 @property (nonatomic, strong) UISearchBar *searchBar;
 @property (nonatomic, strong) UIView *separatorLine;
@end


@interface HeaderGrib : UIView
 @property (nonatomic, strong) UIView *separatorLine;
 @property (nonatomic, strong) UIImageView *separatorShadow;
 @property (nonatomic, strong) UIView *grip;
@end


@interface DemoHeaderViews : NSObject

+ (HeaderLabel  *)createHeaderLabel;
+ (HeaderSearch *)createHeaderSearch;
+ (HeaderGrib   *)createHeaderGrip;

+ (void)changeColorsHeaderView:(UIView *)headerView forStyle:(ContainerStyle)style;

@end

