
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerView.h"
#import "ContainerMacros.h"

@interface ContainerView () <UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UISearchBar *titleSearchBar;
@property (strong, nonatomic) UIView *titleGraber;
@property (strong, nonatomic) UIView *titleSeparatorLine;

@property (strong, nonatomic) UIVisualEffectView *visualEffectViewOrigin;
@property (strong, nonatomic) UIView *visualEffectView;

@property NSInteger savePositionContainer;

@property NSInteger containerTop;
@property NSInteger containerBottom;

@end


@implementation ContainerView

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self) [self initContainer];
    return self;
}

- (void)changeCornerRadius:(CGFloat)newValue
{
    self.layer.cornerRadius = newValue;
    if(self.visualEffectView) self.visualEffectView.layer.cornerRadius = newValue;
}

- (void)addSubview:(UIView *)subview
{
    [super addSubview:subview];
    
    if([subview isKindOfClass:[UITableView class]]) {
        self.tableView = (UITableView *)subview;
    } else if([subview isKindOfClass:[UICollectionView class]]) {
        self.collectionView = (UICollectionView *)subview;
    }
}


- (void)initContainer
{
    {
        self.backgroundColor     = [UIColor clearColor];
        self.layer.cornerRadius  = 15;
        self.layer.shadowOffset  = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius  = 5;
        self.layer.shadowColor   = RGB(44, 62, 80).CGColor;
        
        UIPanGestureRecognizer * containerPan;
        {
            containerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
            containerPan.delegate = self;
        }
        [self addGestureRecognizer: containerPan];
        
        NSInteger containerBottom_ = selfFrame.size.height -92;
        
        if (NAV_ADDED) {
            UINavigationController * nav = (UINavigationController *)ROOT_VC;
            if(!nav.navigationBarHidden) {
                if(!nav.navigationBar.translucent) {
                    containerBottom_ = (containerBottom_ -64);
                }
            }
        }
        
        self.transform = CGAffineTransformMakeTranslation(0, (selfFrame.size.height == iphoneX) ? (containerBottom_ -34) : containerBottom_ );
        
        {
            if(!self.visualEffectView)
            {
                self.visualEffectView = [[UIView alloc] initWithFrame: (CGRect){ {0, 0}, self.frame.size } ];
                self.visualEffectView.layer.cornerRadius = 15;
                self.visualEffectView.clipsToBounds = YES;
                self.visualEffectView.backgroundColor = [UIColor clearColor];
                [self addSubview: self.visualEffectView];
                
                if(!self.visualEffectViewOrigin)
                {
                    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                    self.visualEffectViewOrigin = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    self.visualEffectViewOrigin.frame = (CGRect){ {0, 0}, self.frame.size };
                    [self.visualEffectView addSubview: self.visualEffectViewOrigin];
                }
            }
        }
        
        if(!self.titleGraber)
        {
            self.titleGraber = [[UIView alloc] initWithFrame: (CGRect) {
                { ((self.frame.size.width / 2) -18), 8 },
                { 36, 4 }
            }];
            self.titleGraber.layer.cornerRadius = self.titleGraber.frame.size.height / 2;
            self.titleGraber.backgroundColor = RGB(180, 180, 180);
            self.titleGraber.alpha = 0.5 ;
            [self addSubview:self.titleGraber];
        }
        
        if(!self.titleSeparatorLine)
        {
            self.titleSeparatorLine = [[UIView alloc]initWithFrame: (CGRect) { {0, 63.5}, { self.frame.size.width, 0.5} }];
            self.titleSeparatorLine.backgroundColor = RGB(212, 212, 212);
            [self addSubview:self.titleSeparatorLine];
        }
        
        {
            if(!self.titleLabel)
            {
                self.titleLabel = [[UILabel alloc]initWithFrame: (CGRect) { {18, 16}, {161, 30} }];
                self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:24];
                self.titleLabel.textColor = [UIColor blackColor];
                self.titleLabel.text = @"Heading";
                [self addSubview:self.titleLabel];
            }
            
            if(!self.titleSearchBar)
            {
                self.titleSearchBar = [[UISearchBar alloc] initWithFrame:(CGRect) { {0, 4}, { self.frame.size.width, 56} }];
                self.titleSearchBar.barStyle = UIBarStyleDefault;
                self.titleSearchBar.searchBarStyle = UISearchBarStyleMinimal;
                self.titleSearchBar.placeholder = @"Search";
                self.titleSearchBar.alpha = 0;
                self.titleSearchBar.delegate = self;
                [self addSubview:self.titleSearchBar];
            }
        }
    }
}


- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    [self endEditing:YES];
    
    
    NSInteger containerPositionTop_ =
    (self.containerTop == 0) ? defaultFrameY : self.containerTop;
    
    
        if(recognizer.state == UIGestureRecognizerStateChanged)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.frame.origin.y < containerPositionTop_)
            {
                CGRect scrollFrame = (CGRect)
                {
                    defaultHeaderOrigin,
                    {
                        selfFrame.size.width,
                        
                        (selfFrame.size.height -containerPositionTop_ -defaultHeaderHeight)
                        +(containerPositionTop_ -self.frame.origin.y)
                    }
                };
     
                self.tableView.frame = scrollFrame;
                self.collectionView.frame = scrollFrame;
            }
                });
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            
            CGRect scrollFrame = (CGRect)
            {
                defaultHeaderOrigin,
                {
                    selfFrame.size.width,
                    
                    ((selfFrame.size.height +containerPositionTop_ -defaultHeaderHeight)
                     -((self.containerTop == 0) ? defaultFrameY : self.containerTop) )
                }
            };
            
            self.tableView.frame = scrollFrame;
            self.collectionView.frame = scrollFrame;
                
            });
        }
    

    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.savePositionContainer = (NSInteger)self.transform.ty;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform
        _transform = self.transform;
        _transform.ty = (self.savePositionContainer + [recognizer translationInView: self].y );
        if (_transform.ty < 0) _transform.ty = 0;
        self.transform = _transform ;
        
        if(self.blockScalingBackBackgroundView) self.blockScalingBackBackgroundView(ContainerMoveTypeTop, _transform.ty, NO);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.containerMove3position)
        {
            
            if( self.transform.ty < ((selfFrame.size.height * 64) /100) ) {
                if([recognizer velocityInView:self].y < 0)
                    [self containerMove:ContainerMoveTypeTop];
                else {
                    if( 2500 < [recognizer velocityInView:self].y)
                        [self containerMove:ContainerMoveTypeBottom];
                    else [self containerMove:ContainerMoveTypeMiddle];
                }
            } else {
                if([recognizer velocityInView:self].y < 0) {
                    if(  [recognizer velocityInView:self].y < -2000 )
                        [self containerMove:ContainerMoveTypeTop];
                    else [self containerMove:ContainerMoveTypeMiddle];
                }
                else [self containerMove:ContainerMoveTypeBottom];
            }
        }
        else
        {
            if([recognizer velocityInView:self].y < 0) {
                [self containerMove:ContainerMoveTypeTop];
            } else {
                [self containerMove:ContainerMoveTypeBottom];
            }
            
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self containerMove:ContainerMoveTypeTop];
}

- (void)changeTitleType:(ContainerTitleType)titleType {
    
    animations(.25,^(void) {
        switch (titleType) {
            case ContainerTitleTypeSearchBar:   [self changeTitleAlphaLabel:0 search:1 graber:0]; break;
            case ContainerTitleTypeLabel:       [self changeTitleAlphaLabel:1 search:0 graber:1]; break;
            case ContainerTitleTypeDefault:     [self changeTitleAlphaLabel:0 search:0 graber:1]; break;
        }
    });
}

- (void)changeTitleAlphaLabel:(CGFloat)label search:(CGFloat)search graber:(CGFloat)graber {
    self.titleLabel    .alpha = label;
    self.titleSearchBar.alpha = search;
    self.titleGraber   .alpha = graber;
}

- (void)changeBlurStyle:(ContainerStyle)styleType {
    
    animations(.25,^(void) {
        
        CGFloat alpha = 0.5;
        UIColor *graberColor = RGB(180, 180, 180);
        UIColor *separatorColor = graberColor;
        
        if((styleType == ContainerStyleDark) || (styleType == ContainerStyleDefault)) {
            graberColor     = RGB(235, 239, 245);
            separatorColor  = RGB(222, 222, 222);
        }
        
        if      (styleType == ContainerStyleDark)    alpha = 0.2;
        else if (styleType == ContainerStyleDefault) alpha = 1.0;
        
        self.titleSearchBar.keyboardAppearance = (styleType == ContainerStyleDark) ? UIKeyboardAppearanceDark : UIKeyboardAppearanceDefault;
        if(self.titleSearchBar.alpha == 0)
        {
            self.titleGraber.backgroundColor = graberColor;
            self.titleGraber.alpha = alpha;
        }
        self.titleLabel.textColor = (styleType == ContainerStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
        
        self.titleSeparatorLine.backgroundColor = separatorColor;
        self.titleSeparatorLine.alpha = alpha;
        
        if(styleType != ContainerStyleDefault) {
            self.visualEffectView.backgroundColor = [UIColor clearColor];
            self.visualEffectViewOrigin.alpha = 1;
            
            UIBlurEffectStyle effect;
            if      (styleType == ContainerStyleLight)      effect = UIBlurEffectStyleLight;
            else if (styleType == ContainerStyleExtraLight) effect = UIBlurEffectStyleExtraLight;
            else effect = UIBlurEffectStyleDark;
            
            self.visualEffectViewOrigin.effect = [UIBlurEffect effectWithStyle:effect];
        } else {
            self.visualEffectView.backgroundColor = [UIColor whiteColor];
            self.visualEffectViewOrigin.alpha = 0;
        }
    });
}


- (void)containerMove:(ContainerMoveType)containerMove
{
    
    NSInteger position = 0;
    NSInteger containerTop_ = self.containerTop;
    NSInteger containerBottom_ = (selfFrame.size.height -(self.containerBottom));
    
    if (self.containerTop == 0) {
        containerTop_ = 60;
    }
    
    if (self.containerBottom == 0) {
        containerBottom_ = (selfFrame.size.height -92);
    }
    
    if (NAV_ADDED) {
        UINavigationController * nav = (UINavigationController *)ROOT_VC;
        if(!nav.navigationBarHidden) {
            if(nav.navigationBar.translucent) {
                containerTop_ = (containerTop_ +64);
            } else {
                containerBottom_ = (containerBottom_ -64);
            }
        }
    }
    
    switch (containerMove) {
        case ContainerMoveTypeTop:      position = ((selfFrame.size.height == iphoneX) ? (containerTop_ +24) : containerTop_); break;
        case ContainerMoveTypeMiddle:   position = ((selfFrame.size.height * 64) / 100); break;
        case ContainerMoveTypeBottom:   position = ((selfFrame.size.height == iphoneX) ? (containerBottom_ -34) : containerBottom_ ); break;
        case ContainerMoveTypeHide:     position =   selfFrame.size.height; break;
    }
    
    CGAffineTransform _transform = CGAffineTransformMakeTranslation( 0, position);
    
    if(self.blockScalingBackBackgroundView) self.blockScalingBackBackgroundView(containerMove, _transform.ty, YES);


    animationsSpring(.45, ^(void){
        self.transform = _transform;
    });

    
}

- (void)changePositionMoveType:(ContainerMoveType)moveType newValue:(NSInteger)newValue {
    
    switch (moveType) {
        case ContainerMoveTypeTop:    self.containerTop    = newValue; break;
        case ContainerMoveTypeBottom: self.containerBottom = newValue; break;
        default: break;
    }
    
}


@end
