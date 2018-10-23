
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ContainerStyle) {
    ContainerStyleLight = 0,
    ContainerStyleDark,
    ContainerStyleExtraLight,
    ContainerStyleDefault,
};

typedef NS_ENUM(NSUInteger, ContainerTitleType) {
    ContainerTitleTypeLabel = 0,
    ContainerTitleTypeSearchBar,
    ContainerTitleTypeDefault,
};

typedef NS_ENUM(NSUInteger, ContainerMoveType) {
    ContainerMoveTypeTop = 0,
    ContainerMoveTypeMiddle,
    ContainerMoveTypeBottom,
    ContainerMoveTypeHide,
};

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeSettings = 0,
    SelectTypeMap,
    SelectTypePhotos,
};


