
//  Created by Rustam Motygullin on 10.08.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DemoDownloadImages : NSObject

@property (strong, nonatomic) void(^blockAddImage)(UIImage *img, UIImage *imgSmall, BOOL animated);
- (void)startLoadImages;

@end

