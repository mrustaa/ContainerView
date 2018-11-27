
//  Created by Rustam Motygullin on 03.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.


#import "DemoViewController.h"
#import "ContainerDefines.h"

#import "DemoHeaderViews.h"

#import "DemoScrollViews.h"
#import "DemoTableCell.h"
#import "DemoCollectionCell.h"




@interface DemoViewController () <ContainerViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>


@property (strong, nonatomic) NSMutableArray <NSDictionary *> *photoItems;

@property (strong, nonatomic)          UITableView          *tableView;
@property (strong, nonatomic)          UICollectionView     *collectionView;
@property (strong, nonatomic)          UITextView           *textView;


@property (strong, nonatomic)          UIImageView          *imageView;
@property (strong, nonatomic) IBOutlet UIView               *settingsView;
@property (strong, nonatomic) IBOutlet MKMapView            *mapView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView   *mapViewStatusBarBlur;

@property (strong, nonatomic) IBOutlet UISegmentedControl   *segmentedContainerMove;
@property (strong, nonatomic) IBOutlet UISwitch             *switchEnableMiddle;

@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueTop;
@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueBottom;
@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueCornerRadius;

@end




@implementation DemoViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:FRAME];
        _imageView.contentMode = (SCREEN_WIDTH < SCREEN_HEIGHT) ?UIViewContentModeScaleAspectFill :UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = GRAYLEVEL(210);
        _imageView.autoresizingMask =
        (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin);
        _imageView.alpha = 0;
    }
    [self.bottomView addSubview:_imageView];
    
    
    [self.mapView setRegion:[self.mapView regionThatFits:COORDINATE_SAN_FRANCISCO]];
    self.mapView.alpha = 0;
    
    self.mapViewStatusBarBlur.alpha = 1;
    
    self.mapViewStatusBarBlur.frame = CGRectMake(
        self.mapViewStatusBarBlur.frame.origin.x, self.mapViewStatusBarBlur.frame.origin.y ,
        self.mapViewStatusBarBlur.frame.size.width, SCREEN_STATUS_HEIGHT
    );
    
    _tableView = [DemoScrollViews createTableViewWithProtocols:self];
    [self changeTableViewSeparatorStyle];
    [self.containerView addSubview:_tableView];
    
    self.containerCornerRadius = 15;
    
    // [self containerMove:ContainerMoveTypeTop animated:NO];
    
    self.delegate = self;
    

    
    [self initScrollViewsPhotoItems];

}

#pragma mark - Init Photos Items For TableView & CollecionView

- (void)initScrollViewsPhotoItems  {
    
    for (int count =0; count < 46; count++) {
        UIImage *img = IMG( SFMT(@"IMG_%d",count) );
        UIImage *imgSmall = [self imageWithImage:img size:200];
        
        [self.photoItems addObject:@{ @"big"   : img,
                                      @"small" : imgSmall }];
    }
    if(self.tableView)      [self.tableView      reloadData];
    if(self.collectionView) [self.collectionView reloadData];
}


- (NSMutableArray *)photoItems {
    if(!_photoItems) _photoItems = [NSMutableArray new];
    return _photoItems;
}


- (UIImage *)imageWithImage:(UIImage *)image size:(NSInteger)size {
    
    CGSize cgSize = CGSizeMake(       size, (image.size.height / (image.size.width / size) ));
    CGRect cgRect = CGRectMake( 0, 0, size, (image.size.height / (image.size.width / size) ));
    UIGraphicsBeginImageContextWithOptions( cgSize, NO, 0.0);
    [image drawInRect: cgRect ];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - UIContentContainer Protocol

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if(_imageView) {
        _imageView.contentMode = (size.width < size.height) ?UIViewContentModeScaleAspectFill :UIViewContentModeScaleAspectFit;
    }
    if(_tableView) {
        [_tableView reloadData];
    }
    if(_collectionView) {
        [_collectionView reloadData];
    }
}

#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(self.containerPosition != ContainerMoveTypeTop) [self containerMove:ContainerMoveTypeTop];
    GCD_ASYNC_GLOBAL_BEGIN(0) {
        GCD_ASYNC_MAIN_BEGIN {
            [searchBar becomeFirstResponder];
        });
    });
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectCellIndex:(SelectType)indexPath.row animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.photoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if(!cell) {
        cell = [[DemoTableCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"TableCell" ];
        cell.backgroundColor = CLR_COLOR;
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);

    if(!cell.labelTitle) {
        cell.labelTitle  = [[UILabel alloc]initWithFrame:CGRectMake( 18 , 20, SCREEN_WIDTH -67 , 30 )];
        cell.labelTitle.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:22];
        cell.labelTitle.textColor = BLACK_COLOR;
        [cell addSubview:cell.labelTitle];
    }
    
    if(!cell.labelSubTitle) {
        cell.labelSubTitle  = [[UILabel alloc]initWithFrame:CGRectMake( 18 , 50, SCREEN_WIDTH -67, 16 )];
        cell.labelSubTitle.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
        cell.labelSubTitle.textColor = RGB(124,132,148);
        [cell addSubview:cell.labelSubTitle];
    }
    
    cell.labelTitle   .text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d", (int)indexPath.row) : @"settings" ;
    cell.labelSubTitle.text = @"Subtitle";
    cell.labelTitle.textColor = (self.containerStyle == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;
    
    return cell;
}



#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCellIndex:(SelectType)indexPath.row animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat indent =  (((SCREEN_WIDTH - ((SCREEN_WIDTH * .437333) * 2)) / 3) / 2);
    CGFloat imageSize = (SCREEN_WIDTH * .437333);
    
    CGSize size = (CGSize) {
        ((imageSize + (indent * 2)) -1),
        (imageSize +  indent + 36)
    };
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    CGFloat indent = (((SCREEN_WIDTH - ((SCREEN_WIDTH * .437333) * 2)) / 3) / 2);
    return UIEdgeInsetsMake(indent,indent,0,indent);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return .0;
}


#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionCell" forIndexPath: indexPath];
    cell.backgroundColor = CLR_COLOR;
    cell.clipsToBounds = YES;
    
    CGFloat indent =  (((SCREEN_WIDTH - ((SCREEN_WIDTH * .437333) * 2)) / 3) / 2);
    CGFloat imageSize = (SCREEN_WIDTH * .437333);
    
    CGSize cellSize = (CGSize)
    {
        ((imageSize + (indent * 2)) -1) ,
        (imageSize +  indent + 36)
    };
    
    if(!cell.imageView )
    {
        cell.imageView = [UIImageView new];
        cell.imageView.clipsToBounds = 1;
        cell.imageView.backgroundColor = CLR_COLOR;
        cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
        cell.imageView.layer.cornerRadius = 6;
        [cell addSubview: cell.imageView];
    }
    
    if(!cell.label) {
        cell.label  = [[UILabel alloc]initWithFrame:CGRectMake( 8, cellSize.height -26, cellSize.width -16, 18)];
        cell.label.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:14];
        cell.label.textColor = BLACK_COLOR;
        [cell addSubview:cell.label];
    }
    
    cell.imageView.frame = CGRectMake( indent, indent, imageSize, imageSize);
    cell.imageView.image = self.photoItems[indexPath.row][@"small"];
    
    cell.label.frame = CGRectMake( 8, cellSize.height -26, cellSize.width -16, 18);
    cell.label.text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d",(int)indexPath.row) : @"settings" ;
    cell.label.textColor = (self.containerStyle == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;
    
    return cell;
}

#pragma mark - TableView & Collection Select Cell

- (void)selectCellIndex:(SelectType)index animated:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    ANIMATIONCOMP( (animated) ? 0.25 : 0. , ^(void) {
        
        weakSelf.imageView.alpha = 0;
        
    }, ^(BOOL fin) {
        
        if((index != SelectTypeSettings) &&
           (index != SelectTypeMap)) {
            weakSelf.imageView.image = self.photoItems[index][@"big"];
        }
        
        ANIMATION( (animated) ? 0.25 : 0. , ^(void){
            
            weakSelf.mapViewStatusBarBlur.hidden = YES;
            weakSelf.mapView.alpha = 0;
            weakSelf.settingsView.alpha = 0;
            
            switch (index) {
                case SelectTypeSettings:
                    weakSelf.settingsView.alpha = 1;
                    break;
                case SelectTypeMap:
                    weakSelf.mapView.alpha = 1;
                    weakSelf.mapViewStatusBarBlur.hidden = APP.statusBarHidden;
                    break;
                default:
                    weakSelf.imageView.alpha = 1;
                    break;
            }
        });
    });
}

#pragma mark - ContainerView Delegate

- (void)changeContainerMove:(ContainerMoveType)containerMove containerY:(CGFloat)containerY animated:(BOOL)animated {
    [super changeContainerMove:containerMove containerY:containerY animated:animated];
    if(animated) {
        self.segmentedContainerMove.selectedSegmentIndex = containerMove;
    }
}

#pragma mark - ContainerView Changes Parameters

- (IBAction)changeStatusbar:(UISwitch *)sender {
    BOOL hidden = (!sender.on);
    self.mapViewStatusBarBlur.hidden = hidden;
    APP.statusBarHidden = hidden;
}

- (IBAction)changeContainerEnabledMiddle:(UISwitch *)sender {
    self.containerAllowMiddlePosition = sender.on;
}

- (IBAction)changeContainerZoom:(UISwitch *)sender {
    self.containerZoom = sender.on;
}

- (IBAction)changeShadow:(UISwitch *)sender {
    self.containerShadowView = sender.on;
}

- (IBAction)changeContainerShadow:(UISwitch *)sender {
    self.containerShadow = sender.on;
}

- (IBAction)changeContainerShowBottomButtonToMoveTop:(UISwitch *)sender {
    self.containerBottomButtonToMoveTop = sender.on;
}


- (IBAction)changeContainerAlpha:(UISlider *)sender {
    self.containerView.alpha = sender.value;
}

- (IBAction)changeContainerMove:(UISegmentedControl *)sender {
    if((ContainerMoveType)sender.selectedSegmentIndex == ContainerMoveTypeMiddle) {
        self.containerAllowMiddlePosition = YES;
        [self.switchEnableMiddle setOn:YES animated: YES];
    }
    [self containerMove:(ContainerMoveType)sender.selectedSegmentIndex];
}


- (IBAction)changeContainerTitleType:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0: self.headerView = nil; break;
        case 1: {
            HeaderGrib *grib = [DemoHeaderViews createHeaderGrip];
            [DemoHeaderViews changeColorsHeaderView:grib forStyle:self.containerStyle];
            self.headerView = grib;
        } break;
        case 2: {
            HeaderLabel *label = [DemoHeaderViews createHeaderLabel];
            [DemoHeaderViews changeColorsHeaderView:label forStyle:self.containerStyle];
            self.headerView = label;
        } break;
        case 3: {
            HeaderSearch *search = [DemoHeaderViews createHeaderSearch];
            search.searchBar.delegate = self;
            [DemoHeaderViews changeColorsHeaderView:search forStyle:self.containerStyle];
            self.headerView = search;
        } break;
        default: break;
    }
}

- (IBAction)changeContainerStyle:(UISegmentedControl *)sender {
    
    ContainerStyle style = sender.selectedSegmentIndex;
    self.containerStyle = style;
    
    UIView *view = self.headerView;
    if(view) [DemoHeaderViews changeColorsHeaderView:view forStyle:style];
    
    if(style == ContainerStyleDark) {
        if(self.textView) {
            self.textView.textColor = WHITE_COLOR;
            self.textView.keyboardAppearance = UIKeyboardAppearanceDark;
        }

        self.mapView.mapType = MKMapTypeHybrid;
        self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        STATUSBAR_STYLE(UIStatusBarStyleLightContent);
        // self.mapViewStatusBarBlur.hidden
        self.view        .backgroundColor = RGB(55, 55, 55);
        self.settingsView.backgroundColor = RGB(66, 66, 66);
    } else {
        if(self.textView) {
            self.textView.textColor = BLACK_COLOR;
            self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
        self.mapView.mapType = MKMapTypeStandard;
        self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        STATUSBAR_STYLE(UIStatusBarStyleDefault);
        self.view        .backgroundColor = RGB(235, 235, 241);
        self.settingsView.backgroundColor = RGB(225, 225, 231);
    }
    
    if(self.tableView) {
        [self changeTableViewSeparatorStyle];
        [self.tableView reloadData];
    }
    if(self.collectionView) {
        [self.collectionView reloadData];
    }
    
}

- (void)changeTableViewSeparatorStyle {
    UIColor * color;
    
    switch (self.containerStyle) {
        case ContainerStyleDefault:
            color = RGBA(222,222,222,1);
            break;
        case ContainerStyleDark:
            color = RGBA(222,222,222,0.2);
            break;
        case ContainerStyleExtraLight:
        case ContainerStyleLight:
            color = RGBA(180,180,180,0.5);
            break;
        
    }
    [self.tableView setSeparatorColor:color];
}

- (IBAction)changeContainerSizeTop:(UISlider *)sender {
    CGFloat top = sender.value;
    
    [self containerMoveCustomPosition:top moveType:ContainerMoveTypeTop animated:YES];
    
    self.containerTop = top - IPHONE_X_PADDING_TOP;
    self.containerLabelValueTop.text = SFMT(@"%.0f y", top);
}

- (IBAction)changeContainerSizeBottom:(UISlider *)sender {
    CGFloat bottom = sender.value; // (SCREEN_HEIGHT -((sender.maximumValue +50) -sender.value));
    
    [self containerMoveCustomPosition: (SCREEN_HEIGHT - bottom) moveType:ContainerMoveTypeBottom animated:NO];
    
    self.containerBottom = bottom - IPHONE_X_PADDING_BOTTOM;
    self.containerLabelValueBottom.text = SFMT(@"%.0f y", bottom);
}


- (IBAction)changeContainerCornerRadius:(UISlider *)sender {
    self.containerCornerRadius = sender.value;
    self.containerLabelValueCornerRadius.text = SFMT(@"%d", (int)sender.value);
}

- (IBAction)changeContainerScrollViewType:(UISegmentedControl *)sender {
    
    if(_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if(_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    if(_textView) {
        [_textView removeFromSuperview];
        _textView = nil;
    }
    
    switch (sender.selectedSegmentIndex) {
        case 0: {
            _tableView = [DemoScrollViews createTableViewWithProtocols:self];
            [self changeTableViewSeparatorStyle];
            [self.containerView addSubview:_tableView];
        } break;
        case 1: {
            _collectionView = [DemoScrollViews createCollectionViewWithProtocols:self];
            [self.containerView addSubview:_collectionView];
        } break;
        case 2: {
            _textView = [DemoScrollViews createTextViewWithProtocols:self];
            _textView.textColor = (self.containerStyle == ContainerStyleDark) ?WHITE_COLOR :BLACK_COLOR;
            [self.containerView addSubview:_textView];
        } break;
        default: break;
    }
    
}


//- (IBAction)addNewContainer {
//    ContainerView *container = [[ContainerView alloc] initWithFrame: CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT +50 )];
//    [container containerMove:ContainerMoveTypeHide animated:NO];
//    [self.view addSubview:container];
//    [container containerMove:ContainerMoveTypeBottom];
//}



@end
