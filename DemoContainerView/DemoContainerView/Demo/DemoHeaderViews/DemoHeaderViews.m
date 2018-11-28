//
//  DemoHeaders.m
//  DemoContainerView
//
//  Created by Rustam Motygullin on 17/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import "DemoHeaderViews.h"
#import "ContainerDefines.h"

@implementation HeaderLabel
@end

@implementation HeaderSearch
@end

@implementation HeaderGrib
@end


@implementation DemoHeaderViews


+ (void)changeColorsHeaderView:(UIView *)headerView forStyle:(ContainerStyle)style {
    
    if(!headerView) return;
    
    CGFloat alpha = 0.5;
    UIColor *separatorColor = GRAYLEVEL(180);
    UIColor *graberColor = [separatorColor copy];
    if((style == ContainerStyleDark) ||
       (style == ContainerStyleDefault)) {
        if      (style == ContainerStyleDark)    alpha = 0.2;
        else if (style == ContainerStyleDefault) alpha = 1.0;
        separatorColor = GRAYLEVEL(222);
        graberColor = RGB(235, 239, 245);
    }
    
    if     ([headerView isKindOfClass:[HeaderLabel  class]]) {
        HeaderLabel *headerLabel = (HeaderLabel *)headerView;
        headerLabel.label.textColor = (style == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;
        headerLabel.separatorLine.backgroundColor = separatorColor;
        headerLabel.separatorLine.alpha = alpha;
        headerLabel.grip.backgroundColor = graberColor;
        headerLabel.grip.alpha = alpha;
    }
    else if([headerView isKindOfClass:[HeaderSearch class]]) {
        HeaderSearch *headerSearch = (HeaderSearch *)headerView;
        headerSearch.searchBar.keyboardAppearance = (style == ContainerStyleDark) ? UIKeyboardAppearanceDark : UIKeyboardAppearanceDefault;
        headerSearch.separatorLine.backgroundColor = separatorColor;
        headerSearch.separatorLine.alpha = alpha;
    }
    else if([headerView isKindOfClass:[HeaderGrib   class]]) {
        HeaderGrib *headerGrip = (HeaderGrib *)headerView;
        headerGrip.separatorLine.backgroundColor = separatorColor;
        headerGrip.separatorLine.alpha = alpha;
        headerGrip.grip.backgroundColor = graberColor;
        headerGrip.grip.alpha = alpha;
    }
    
}

+ (CGFloat)headerSize {
    CGFloat paddingWidht = SCREEN_PORTRAIT ?0. :20.;
    CGFloat widht = (SCREEN_PORTRAIT ?SCREEN_WIDTH :SCREEN_HEIGHT - paddingWidht);
    return widht;
}

+ (HeaderLabel *)createHeaderLabel {
    
    HeaderLabel *view = [[HeaderLabel alloc] initWithFrame:CGRectMake(0, 0, [self headerSize], CUSTOM_HEADER_HEIGHT)];
    view.clipsToBounds = YES;
    
    UILabel *
    label = [[UILabel alloc]initWithFrame:CGRectMake( 18, 16, 161, 30)];
    label.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:24];
    
    label.text = @"Heading";
    view.label = label;
    [view addSubview:label];
    
    view.grip = [self createGrip];
    [view addSubview:view.grip];
    
    view.separatorLine = [self createSeparatorLine];
    [view addSubview:view.separatorLine];
    
    
    return view;
}

+ (HeaderSearch *)createHeaderSearch {
    
    HeaderSearch *view = [[HeaderSearch alloc] initWithFrame:CGRectMake(0, 0, [self headerSize], CUSTOM_HEADER_HEIGHT)];
    view.clipsToBounds = YES;
    
    UISearchBar *
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 4, [self headerSize], CUSTOM_HEADER_HEIGHT -4)];
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"Search";
    searchBar.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth );
    view.searchBar = searchBar;
    [view addSubview:searchBar];
    
    view.separatorLine = [self createSeparatorLine];
    [view addSubview:view.separatorLine];
    return view;
}

+ (HeaderGrib *)createHeaderGrip {
    HeaderGrib *view = [[HeaderGrib alloc] initWithFrame:CGRectMake(0, 0, [self headerSize], 20)];
    
    view.grip = [self createGrip];
    [view addSubview:view.grip];
    
    view.separatorLine = [self createSeparatorLine];
    view.separatorLine.frame = CGRectMake(
        view.separatorLine.frame.origin.x, 19.5 ,
        view.separatorLine.frame.size.width, view.separatorLine.frame.size.height
    );
    
    view.separatorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19.5, [self headerSize], 20)];
    view.separatorShadow.image = IMG(@"header_shadow.png");
    view.separatorShadow.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
//    view.separatorShadow.alpha = 0.4;
    [view addSubview:view.separatorShadow];
    
    [view addSubview:view.separatorLine];
    return view;
}

+ (UIView *)createSeparatorLine {
    CGFloat height = 0.5;
    UIView *
    line = [[UIView alloc]initWithFrame: CGRectMake( 0, CUSTOM_HEADER_HEIGHT -height, [self headerSize], height )];
    line.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth );
    return line;
}

+ (UIView *)createGrip {
    UIView *
    grip = [[UIView alloc] initWithFrame: CGRectMake( (([self headerSize] / 2) -18) , 8 , 36, 4 )];
    grip.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  );
    grip.layer.cornerRadius = grip.frame.size.height / 2;
    return grip;
}


@end
