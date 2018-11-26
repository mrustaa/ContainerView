//
//  DemoScrollViews.h
//  DemoContainerView
//
//  Created by Рустам Мотыгуллин on 26/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContainerTypes.h"

@interface DemoScrollViews : NSObject

+ (UITableView *)createTableViewWithProtocols:(id)protocols;
+ (UICollectionView *)createCollectionViewWithProtocols:(id)protocols;
+ (UITextView *)createTextViewWithProtocols:(id)protocols;

@end


