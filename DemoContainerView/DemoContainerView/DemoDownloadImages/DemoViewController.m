
//  Created by Rustam Motygullin on 03.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerView.h"

#import "DemoViewController.h"

#import "DemoTableDelegate.h"
#import "DemoTableDataSource.h"
#import "DemoCollectionDelegate.h"
#import "DemoCollectionDataSource.h"

#import "DemoDownloadImages.h"
#import "DemoHeaderViews.h"

@interface UIScrollView (bawabd)
@end
@implementation UIScrollView (bawabd)

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

@end



@interface DemoViewController () <UISearchBarDelegate> {
    BOOL isHidden;
    BOOL isZoom;
    BOOL isShadow;
}

@property (strong, nonatomic) ContainerView                 *containerView;

@property (strong, nonatomic) NSMutableArray <NSDictionary *> *photos;

@property (strong, nonatomic) UITableView                   *tableView;
@property (strong, nonatomic) DemoTableDelegate             *tableDelegate;
@property (strong, nonatomic) DemoTableDataSource           *tableDataSource;

@property (strong, nonatomic) UICollectionView              *collectionView;
@property (strong, nonatomic) DemoCollectionDelegate        *collectionDelegate;
@property (strong, nonatomic) DemoCollectionDataSource      *collectionDataSource;

@property (strong, nonatomic) UIImageView                   *imageView;
@property (strong, nonatomic) UIView                        *shadowView;

@property (strong, nonatomic) IBOutlet UISegmentedControl   *segmentedContainerMove;
@property (strong, nonatomic) IBOutlet UISwitch             *switchEnableMiddle;

@property (strong, nonatomic) IBOutlet UIView               *settingsView;

@property (strong, nonatomic) IBOutlet MKMapView            *mapView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView   *mapViewStatusBarBlur;

@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueTop;
@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueBottom;
@property (strong, nonatomic) IBOutlet UILabel              *containerLabelValueCornerRadius;

@end




@implementation DemoViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHidden = NO;
    isZoom   = YES;
    isShadow = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if(!self.imageView)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:FRAME];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.alpha = 0;
        [self.view addSubview:self.imageView];
    }
    
    if(!self.shadowView)
    {
        self.shadowView = [[UIView alloc]initWithFrame:FRAME];
        self.shadowView.backgroundColor = BLACK_COLOR;
        self.shadowView.alpha = 0;
        [self.view addSubview:self.shadowView];
    }
    
    {
        [self.mapView setRegion:[self.mapView regionThatFits:COORDINATE_SAN_FRANCISCO]];
        self.mapView.alpha = 0;
        self.mapViewStatusBarBlur.alpha = 0;
        
        self.mapViewStatusBarBlur.height = SCREEN_STATUS_HEIGHT;
    }
    
    
//    if (NAV_ADDED) {
//        UINavigationController * nav = (UINavigationController *)ROOT_VC;
//        if(!nav.navigationBarHidden) {
//            if(nav.navigationBar.translucent) {
//                self.settingsView.frame = (CGRect) {
//                    {self.settingsView.x,self.settingsView.y +(IS_IPHONE_X ? (64 +24) : 64)},
//                    self.settingsView.frame.size
//                };
//                self.  mapView.frame = self.settingsView.frame;
//                self.imageView.frame = self.settingsView.frame;
//            }
//        }
//    }
    
    
    [self.containerView addSubview:self.tableView];
    [self.containerView changeCornerRadius:15];
    
    // [self.containerView containerMove:ContainerMoveTypeTop animated:NO];
    // self.containerView.containerBottomButtonToMoveTop = YES;
    
    [self.view addSubview: self.containerView];
    
    
    
    DemoDownloadImages *
    downloadImages = [[DemoDownloadImages alloc]init];
    
    NSMutableArray * photos = [downloadImages loadLocalImages];
    if(photos) {
        for(NSDictionary *dic in photos) [self.photos addObject:dic];
        
        if(_tableView) [self.tableView reloadData];
        if(_collectionView) [self.collectionView reloadData];
    } else {
        __weak typeof(self) weakSelf = self;
        [downloadImages downloadOneImageAtATimeCallback:^(UIImage *img, UIImage *imgSmall) {
            
            GCD_ASYNC_MAIN_BEGIN {
                
                [weakSelf.photos addObject:@{ @"big":img, @"small":imgSmall }];
                
                if(self->_tableView) {
                    NSArray *tableIndex = @[[NSIndexPath indexPathForRow:(weakSelf.photos.count-1) inSection:0]];
                    [weakSelf.tableView insertRowsAtIndexPaths:tableIndex withRowAnimation:UITableViewRowAnimationFade];
                }
                
                if(self->_collectionView) {
                    NSArray *collectionIndex = @[[NSIndexPath indexPathForRow:(weakSelf.photos.count-1) inSection:0]];
                    [weakSelf.collectionView performBatchUpdates:^ {
                        [weakSelf.collectionView insertItemsAtIndexPaths:collectionIndex];
                    } completion:nil];
                }
                
            });
        }];
    }
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Create ContainerView elements

- (ContainerView *)containerView {
    
    if(!_containerView)
    {
        ContainerView *
        container = [[ContainerView alloc] initWithFrame: (CGRect){ CGPointZero, { SCREEN_WIDTH, SCREEN_HEIGHT +50 }}];
        
        __weak typeof(self) weakSelf = self;
        container.blockChangeShadowLevel = ^(ContainerMoveType containerMove, CGFloat containerFrameY, BOOL animated) {
            
            if(animated) {
                
                ANIMATION_SPRING(.45,^(void){
                    self.segmentedContainerMove.selectedSegmentIndex = containerMove;
                    [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
                });
            } else {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            }
        };
        _containerView = container;
    }
    return _containerView;
}


- (NSMutableArray *)photos {
    if(!_photos) _photos = [NSMutableArray new];
    return _photos;
}

- (UITableView *)tableView {
    
    if(!_tableView)
    {
        UITableView *
        table = [[UITableView alloc] initWithFrame:FRAME_SCROLLVIEW style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        table.backgroundColor = CLR_COLOR;
        table.dataSource = self.tableDataSource;
        table.delegate   = self.tableDelegate;
        _tableView = table;
    }
    
    return _tableView;
}

- (void)removeTableView {
    if(!_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
}

- (DemoTableDataSource *)tableDataSource {
    if(!_tableDataSource)
    {
        DemoTableDataSource *
        dataSource = [[DemoTableDataSource alloc] init];
        dataSource.photos = self.photos;
        _tableDataSource = dataSource;
    }
    return _tableDataSource;
}

- (DemoTableDelegate *)tableDelegate {
    if(!_tableDelegate)
    {
        DemoTableDelegate *
        delegate = [[DemoTableDelegate alloc] init];
        delegate.containerView = self.containerView;
        
        __weak typeof(self) weakSelf = self;
        delegate.blockSelectIndex = ^(NSInteger index) {
            [weakSelf selectCellIndex:(SelectType)index animated:YES];
        };
        delegate.blockTransform = ^(CGFloat containerFrameY) {
            GCD_ASYNC_MAIN_BEGIN {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            });
        };
        _tableDelegate = delegate;
    }
    return _tableDelegate;
}

- (UICollectionView *)collectionView {
    
    if(!_collectionView)
    {
        UICollectionView *
        collection = [[UICollectionView alloc]initWithFrame:FRAME_SCROLLVIEW collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        [collection registerClass:[DemoCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
        collection.backgroundColor = CLR_COLOR;
        collection.delegate   = self.collectionDelegate;
        collection.dataSource = self.collectionDataSource;
        _collectionView = collection;
    }
    
    return _collectionView;
}

- (void)removeCollectionView {
    if(!_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
}

- (DemoCollectionDataSource *)collectionDataSource {
    if(!_collectionDataSource)
    {
        DemoCollectionDataSource *
        dataSource = [[DemoCollectionDataSource alloc] init];
        dataSource.photos = self.photos;
        
        _collectionDataSource = dataSource;
    }
    return _collectionDataSource;
}
- (DemoCollectionDelegate *)collectionDelegate {
    if(!_collectionDelegate)
    {
        DemoCollectionDelegate *
        delegate = [[DemoCollectionDelegate alloc] init];
        delegate.containerView = self.containerView;
        
        __weak typeof(self) weakSelf = self;
        delegate.blockSelectIndex = ^(NSInteger index) {
            [weakSelf selectCellIndex:(SelectType)index animated:YES];
        };
        delegate.blockTransform = ^(CGFloat containerFrameY) {
            GCD_ASYNC_MAIN_BEGIN {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            });
        };
        _collectionDelegate = delegate;
    }
    return _collectionDelegate;
}

#pragma mark - Actions Table Collection Delegate

- (void)selectCellIndex:(SelectType)index animated:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    ANIMATIONCOMP( (animated) ? 0.25 : 0. , ^(void) {
        
        weakSelf.imageView.alpha = 0;
        
    }, ^(BOOL fin) {
        
        if((index != SelectTypeSettings) &&
           (index != SelectTypeMap)) {
            weakSelf.imageView.image = self.photos[index][@"big"];
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

- (void)changeScalesImageAndShadowLevel:(float)containerFrameY {
    [self.view endEditing:YES];
    
    CGFloat selfCenter = self.containerView.containerMiddle;
    
    
    
    
    if(containerFrameY < selfCenter) {
        
        CGFloat procent = (((selfCenter -containerFrameY) / selfCenter) / 2);
        
        CGAffineTransform transform = CGAffineTransformMakeScale( 1. -(procent / 5), 1. -(procent / 5));
        
        if(isZoom) {
            self.imageView.transform = transform;
            self.imageView.layer.cornerRadius = (procent * 24);
            
            self.settingsView.transform = transform;
            self.settingsView.layer.cornerRadius = (procent * 24);
            
            self.mapView.transform = transform;
            self.mapView.layer.cornerRadius = (procent * 24);
        
            self.mapViewStatusBarBlur.alpha = (1 -procent *2);
        } else {
            self.imageView.transform = CGAffineTransformIdentity;
            self.imageView.layer.cornerRadius = 0;
            
            self.settingsView.transform = CGAffineTransformIdentity;
            self.settingsView.layer.cornerRadius = 0;
            
            self.mapView.transform = CGAffineTransformIdentity;
            self.mapView.layer.cornerRadius = 0;
        }
        
        if(isShadow) {
            self.shadowView.alpha = procent;
            self.shadowView.height = (containerFrameY +self.containerView.containerCornerRadius +5);
        } else {
            self.shadowView.alpha = 0.;
            self.shadowView.height = SCREEN_HEIGHT;
        }
        
    } else {
        
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.layer.cornerRadius = 0;
        
        self.settingsView.transform = CGAffineTransformIdentity;
        self.settingsView.layer.cornerRadius = 0;
        
        self.mapView.transform = CGAffineTransformIdentity;
        self.mapView.layer.cornerRadius = 0;
        
        self.mapViewStatusBarBlur.alpha = 1;
        
        self.shadowView.alpha = 0.;
        self.shadowView.height = SCREEN_HEIGHT;
    }
}


#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(self.containerView.containerPosition != ContainerMoveTypeTop) [self.containerView containerMove:ContainerMoveTypeTop];
    GCD_ASYNC_GLOBAL_BEGIN(0) {
        GCD_ASYNC_MAIN_BEGIN {
            [searchBar becomeFirstResponder];
        });
    });
}

#pragma mark - Changes in ContainerView

- (IBAction)changeStatusbar:(UISwitch *)sender {
    BOOL hidden = (!sender.on);
    self.mapViewStatusBarBlur.hidden = hidden;
    APP.statusBarHidden = hidden;
}

- (IBAction)changeContainerEnabledMiddle:(UISwitch *)sender {
    self.containerView.containerAllowMiddlePosition = sender.on;
}

- (IBAction)changeContainerZoom:(UISwitch *)sender {
    isZoom = sender.on;
}

- (IBAction)changeShadow:(UISwitch *)sender {
    isShadow = sender.on;
}
- (IBAction)changeContainerShadow:(UISwitch *)sender {
    self.containerView.containerShadow = sender.on;
}


- (IBAction)changeContainerAlpha:(UISlider *)sender {
    self.containerView.alpha = sender.value;
}

- (IBAction)changeContainerMove:(UISegmentedControl *)sender {
    if((ContainerMoveType)sender.selectedSegmentIndex == ContainerMoveTypeMiddle) {
        self.containerView.containerAllowMiddlePosition = YES;
        [self.switchEnableMiddle setOn:YES animated: YES];
    }
    [self.containerView containerMove:(ContainerMoveType)sender.selectedSegmentIndex];
}


- (IBAction)changeContainerTitleType:(UISegmentedControl *)sender {
    
    ContainerStyle style = self.containerView.containerStyle;
    
    switch (sender.selectedSegmentIndex) {
        case 0: self.containerView.headerView = nil; break;
        case 1: {
            HeaderGrib *grib = [DemoHeaderViews createHeaderGrip];
            [DemoHeaderViews changeColorsHeaderView:grib forStyle:style];
            self.containerView.headerView = grib;
        } break;
        case 2: {
            HeaderLabel *label = [DemoHeaderViews createHeaderLabel];
            [DemoHeaderViews changeColorsHeaderView:label forStyle:style];
            self.containerView.headerView = label;
        } break;
        case 3: {
            HeaderSearch *search = [DemoHeaderViews createHeaderSearch];
            search.searchBar.delegate = self;
            [DemoHeaderViews changeColorsHeaderView:search forStyle:style];
            self.containerView.headerView = search;
        } break;
        default: break;
    }
}



- (IBAction)changeContainerStyle:(UISegmentedControl *)sender {
    
    ContainerStyle style = sender.selectedSegmentIndex;
    
    self.     tableDataSource.containerStyle = style;
    self.collectionDataSource.containerStyle = style;
    
    [self.containerView changeBlurStyle:style];
    
    UIView *view = self.containerView.headerView;
    if(view) [DemoHeaderViews changeColorsHeaderView:view forStyle:style];
    
    if(style == ContainerStyleDark)
    {
        self.mapView.mapType = MKMapTypeHybrid;
        self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        STATUSBAR_STYLE(UIStatusBarStyleLightContent);
        // self.mapViewStatusBarBlur.hidden
        self.view        .backgroundColor = RGB(55, 55, 55);
        self.settingsView.backgroundColor = RGB(66, 66, 66);
    }
    else
    {
        self.mapView.mapType = MKMapTypeStandard;
        self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        STATUSBAR_STYLE(UIStatusBarStyleDefault);
        self.view        .backgroundColor = RGB(235, 235, 241);
        self.settingsView.backgroundColor = RGB(225, 225, 231);
    }
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}



- (IBAction)changeContainerSizeTop:(UISlider *)sender {
    CGFloat top = sender.value;
    
    [self.containerView containerMoveCustomPosition:top moveType:ContainerMoveTypeTop animated:NO];
    
    self.containerView.containerTop = IS_IPHONE_X ? top -24 : top;
    self.containerLabelValueTop.text = SFMT(@"%.0f y", top);
}

- (IBAction)changeContainerSizeBottom:(UISlider *)sender {
    CGFloat bottom = (SCREEN_HEIGHT -((sender.maximumValue +50) -sender.value));
    
    [self.containerView containerMoveCustomPosition:bottom moveType:ContainerMoveTypeBottom animated:NO];
    
    self.containerView.containerBottom = IS_IPHONE_X ? bottom +34 : bottom;
    self.containerLabelValueBottom.text = SFMT(@"%.0f y", bottom);
}


- (IBAction)changeContainerCornerRadius:(UISlider *)sender {
    [self.containerView changeCornerRadius: sender.value];
    self.containerLabelValueCornerRadius.text = SFMT(@"%d", (int)sender.value);
}

- (IBAction)changeContainerScrollViewType:(UISegmentedControl *)sender {
    [self.containerView removeScrollView];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self removeCollectionView];
            [self.containerView addSubview:self.tableView];
            break;
        case 1:
            [self removeTableView];
            [self.containerView addSubview:self.collectionView];
            break;
        case 2:
            [self removeTableView];
            [self removeCollectionView];
            break;
        default: break;
    }
    
}






@end
