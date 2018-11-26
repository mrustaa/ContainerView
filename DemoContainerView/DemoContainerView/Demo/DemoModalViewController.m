//
//  DemoModalViewController.m
//  DemoContainerView
//
//  Created by Рустам Мотыгуллин on 26/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import "DemoModalViewController.h"
#import "DemoScrollViews.h"

@interface DemoModalViewController () <UITextViewDelegate>

@end

@implementation DemoModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView * textView = [DemoScrollViews createTextViewWithProtocols:self];
    [self.containerView addSubview:textView];
    
}
- (IBAction)closeController:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
