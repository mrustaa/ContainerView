
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerTypes.h"



@interface DemoCollectionDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *photos;
@property ContainerStyle containerStyle;

@end



