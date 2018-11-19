
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerTypes.h"
#import "ContainerView.h"

@interface ContainerScrollDelegate : NSObject <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) ContainerView *containerView;
@property (strong, nonatomic) void(^blockTransform)(CGFloat);
@property (strong, nonatomic) void(^blockSelectIndex)(NSInteger) ;

@end
