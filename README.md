# ContainerView 

ContainerView is designed to add a cool swim from the bottom to the animation with the effect of scale, controlled by the help of a gesture, scrollView also takes control. 

The idea is taken from the application: https://www.apple.com/ios/maps/

## Preview
![image](http://gdurl.com/p3_L)
![image](http://gdurl.com/30Qv)
![image(Landscape)](http://gdurl.com/x5p4)

<!-- TOC -->

- [Installation](#installation)
  - [CocoaPods](#cocoapods)
- [Getting Started](#getting-started)
- [Setting](#setting)
  - [Change position Top Middle Bottom](#change-position-top-middle-bottom)
- [Adding Custom View](#adding-custom)
  - [`View` under ContainerView](#view-under-containerview)
  - [`ScrollView` in ContainerView](#scrollview-in-containerview)
  - [`HeaderView` in ContainerView](#headerview-in-containerview)
- [Protocol](#protocol)
  - [Reports the changes current position of the container, after its use](#reports-the-changes-current-position-of-the-container-after-its-use)
- [License](#license)

<!-- /TOC -->

## Installation

### CocoaPods

FloatingPanel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ContainerView'
```

## Getting Started

```objc
#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@interface ViewController : ContainerViewController
@end
```

## Setting

```objc
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This parameter for changing the rounding corner radius of the Container
    self.containerCornerRadius = 15;

    // This parameter to add a blur to the background of the Container
    self.containerStyle = ContainerStyleLight;
    
    // This parameter adds 3 position (move to the middle). Default there are 2 positions
    self.containerAllowMiddlePosition = YES;
    
    // This parameter allows you to zoom in on the screen under Container
    self.containerZoom = YES;
    
    // This parameter sets the shadow under Container
    self.containerShadowView = YES;

    // This parameter sets the shadow in Container
    self.containerShadow = YES;

    // This parameter indicates whether to add a button when the container is at the bottom to move the container to the top
    self.containerBottomButtonToMoveTop = YES;
}
```

### Change position Top Middle Bottom

```objc
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // These parameters set the new position value.
    self.containerTop     = 50;
    self.containerMiddle  = 200;
    self.containerBottom  = 400;
    
}
```

### Move position with an animation

```objc
- (void)moveTop {
    [self containerMove:ContainerMoveTypeTop];
}

- (void)moveMiddle {
    [self containerMove:ContainerMoveTypeMiddle];
}

- (void)moveBottom {
    [self containerMove:ContainerMoveTypeBottom];
}
```

## Adding Custom

### `View` under ContainerView

#### ☝️ Adding all views under the ContainerView necessarily via the `self.bottomView`

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *
    label = [[UILabel alloc]initWithFrame: CGRectMake(18, 26, 60, 30 )];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.textColor = [UIColor redColor];
    label.text = @"Label";
    
    [self.bottomView addSubview:label];
}
```

### `ScrollView` in ContainerView

#### ☝️ For all `ScrollView`, add the `self` delegate. Otherwise, moving the container through scrolling will not work.

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView * textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:46];
    textView.text = @"This \n example \n more \n text \n\n\n\n\n\n\n\n ....";
    
    [self.containerView addSubview:textView];
}
```

### `HeaderView` in ContainerView

```objc
- (void)addHeader {

    CGFloat height = 60;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    
    UISearchBar *
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 4, self.view.frame.size.width, height -4)];
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"Search";
    [headerView addSubview:searchBar];
    
    self.containerView.headerView = headerView;
}
```

## Protocol

### Reports the changes current position of the container, after its use

```objc
@interface ViewController () <ContainerViewDelegate>
@end

@implementation ViewController

- (void)changeContainerMove:(ContainerMoveType)containerMove containerY:(CGFloat)containerY animated:(BOOL)animated {
    [super changeContainerMove:containerMove containerY:containerY animated:animated];
    ...
}
```

## License

FloatingPanel is available under the MIT license. See the LICENSE file for more info.
