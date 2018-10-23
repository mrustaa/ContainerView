
//  Created by Rustam Motygullin on 03.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerView.h"
#import "ContainerMacros.h"

#import "DemoViewController.h"

#import "DemoTableDelegate.h"
#import "DemoTableDataSource.h"
#import "DemoCollectionDelegate.h"
#import "DemoCollectionDataSource.h"

#import "DemoDownloadImages.h"

@interface DemoViewController ()

@property (strong, nonatomic) ContainerView *containerView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DemoTableDelegate *tableDelegate;
@property (strong, nonatomic) DemoTableDataSource *tableDataSource;
@property (strong, nonatomic) NSMutableArray <UIImage *> *tablePhotos;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DemoCollectionDelegate *collectionDelegate;
@property (strong, nonatomic) DemoCollectionDataSource *collectionDataSource;
@property (strong, nonatomic) NSMutableArray <UIImage *> *collectionPhotos;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *settingsView;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *mapViewStatusBarBlur;

@property (strong, nonatomic) IBOutlet UILabel *containerLabelValueTop;
@property (strong, nonatomic) IBOutlet UILabel *containerLabelValueBottom;
@property (strong, nonatomic) IBOutlet UILabel *containerLabelValueCornerRadius;

@property NSInteger containerCornerRadius;

@end

__weak DemoViewController * weakSelf;


@implementation DemoViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weakSelf = self;
    
    
    if(!self.imageView)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:selfFrame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.alpha = 0;
        [self.view addSubview:self.imageView];
    }
    
    if(!self.shadowView)
    {
        self.shadowView = [[UIView alloc]initWithFrame:selfFrame];
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0;
        [self.view addSubview:self.shadowView];
    }
    
    {
        [self.mapView setRegion:[self.mapView regionThatFits:coordinateMoscow]];
        self.mapView.alpha = 0;
        self.mapViewStatusBarBlur.alpha = 0;
    }
    
    if (NAV_ADDED) {
        UINavigationController * nav = (UINavigationController *)ROOT_VC;
        if(!nav.navigationBarHidden) {
            if(nav.navigationBar.translucent) {
                self.settingsView.frame = (CGRect) {
                    {self.settingsView.frame.origin.x,self.settingsView.frame.origin.y +((selfFrame.size.height == iphoneX) ? (64 +24) : 64)},
                    self.settingsView.frame.size
                };
                self.mapView.frame = self.settingsView.frame;
                self.imageView.frame = self.settingsView.frame;
            }
        }
    }
    
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.collectionView];
    
    self.collectionView.alpha = 0;
    
    [self.view addSubview: self.containerView];
    
    
    
    {
        DemoDownloadImages *downloadImages = [[DemoDownloadImages alloc]init];
        downloadImages.blockAddImage = ^(UIImage *img, UIImage *imgSmall, BOOL animated) {
            
            if(animated)
            {
                [self.tablePhotos addObject:img];
                NSArray *tableIndex = @[[NSIndexPath indexPathForRow:(self.tablePhotos.count-1) inSection:0]];
                [self.tableView insertRowsAtIndexPaths:tableIndex withRowAnimation:UITableViewRowAnimationFade];
                
                [self.collectionPhotos addObject:imgSmall];
                NSArray *collectionIndex = @[[NSIndexPath indexPathForRow:(self.collectionPhotos.count-1) inSection:0]];
                [self.collectionView performBatchUpdates:^ {
                    [self.collectionView insertItemsAtIndexPaths:collectionIndex];
                } completion:nil];
            }
            else
            {
                [self.tablePhotos addObject:img];
                [self.tableView reloadData];
                
                [self.collectionPhotos addObject:imgSmall];
                [self.collectionView reloadData];
                
                if( (!self.imageView.image) && (self.tablePhotos.count >= 6)) {
                    self.imageView.image = self.tablePhotos[5];
                    self.settingsView.alpha = 0;
                    self.imageView.alpha = 1;
                }
            }
            
        };
        
        [downloadImages startLoadImages];
    }
}


#pragma mark - Create ContainerView elements

- (ContainerView *)containerView {
    
    if(!_containerView)
    {
        ContainerView *
        container = [[ContainerView alloc] initWithFrame: (CGRect){
            CGPointZero,
            {
                selfFrame.size.width,
                selfFrame.size.height +50
            }
        }];
        
        container.blockScalingBackBackgroundView = ^(ContainerMoveType containerMove, CGFloat containerFrameY, BOOL animated) {
            
            BOOL scrollEnabled = (containerMove == ContainerMoveTypeTop) ? YES : NO;
            weakSelf.tableView.scrollEnabled = scrollEnabled;
            weakSelf.collectionView.scrollEnabled = scrollEnabled;
            
            if(animated) {
                animationsSpring(.45,^(void){
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


- (UITableView *)tableView {
    
    if(!_tableView)
    {
        UITableView *
        table = [[UITableView alloc] initWithFrame:frameTableCollection style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        table.scrollEnabled = NO;
        table.backgroundColor = [UIColor clearColor];
        
        if(!_tablePhotos)
            _tablePhotos = [NSMutableArray new];
        
        if(!_tableDataSource)
        {
            DemoTableDataSource *
            dataSource = [[DemoTableDataSource alloc] init];
            dataSource.photos = _tablePhotos;
            
            _tableDataSource = dataSource;
        }
        
        if(!_tableDelegate)
        {
            
            DemoTableDelegate *
            delegate = [[DemoTableDelegate alloc] init];
            delegate.containerView = self.containerView;
            
            delegate.blockSelectIndex = ^(NSInteger index) {
                [weakSelf selectCellIndex:(SelectType)index animated:YES];
            };
            delegate.blockTransform = ^(CGFloat containerFrameY) {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            };
            
            _tableDelegate = delegate;
        }

        table.dataSource = _tableDataSource;
        table.delegate = _tableDelegate;
        
        _tableView = table;
    }
    
    return _tableView;
}


- (UICollectionView *)collectionView {
    
    if(!_collectionView)
    {
        UICollectionView *
        collection = [[UICollectionView alloc]initWithFrame:frameTableCollection collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        [collection registerClass:[DemoCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
        collection.backgroundColor = [UIColor clearColor];
        
        if(!_collectionPhotos)
            _collectionPhotos = [NSMutableArray new];
        
        if(!_collectionDataSource)
        { 
            DemoCollectionDataSource *
            dataSource = [[DemoCollectionDataSource alloc] init];
            dataSource.photos = _collectionPhotos;
            
            _collectionDataSource = dataSource;
        }
        
        if(!_collectionDelegate)
        {
            
            DemoCollectionDelegate *
            delegate = [[DemoCollectionDelegate alloc] init];
            delegate.containerView = self.containerView;
            
            delegate.blockSelectIndex = ^(NSInteger index) {
                [weakSelf selectCellIndex:(SelectType)index animated:YES];
            };
            delegate.blockTransform = ^(CGFloat containerFrameY) {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            };
            
            _collectionDelegate = delegate;
        }
        
        collection.delegate = _collectionDelegate;
        collection.dataSource = _collectionDataSource;
        
        _collectionView = collection;
    }
    
    return _collectionView;
}

#pragma mark - Actions Table Collection Delegate

- (void)selectCellIndex:(SelectType)index animated:(BOOL)animated {
    
    animationsCompletion( (animated) ? 0.25 : 0. , ^(void) {
        
        weakSelf.imageView.alpha = 0;
        
    } , ^(BOOL fin) {
        
        if((index != SelectTypeSettings) && (index != SelectTypeMap))
        {
            weakSelf.imageView.image = self.tablePhotos[index];
        }
        
        animations( (animated) ? 0.25 : 0. , ^(void){
            
            switch (index) {
                case SelectTypeSettings:
                    weakSelf.settingsView.alpha = 1;
                    weakSelf.mapView.alpha = 0;
                    weakSelf.mapViewStatusBarBlur.hidden = 1; break;
                case SelectTypeMap:
                    weakSelf.settingsView.alpha = 0;
                    weakSelf.mapView.alpha = 1;
                    weakSelf.mapViewStatusBarBlur.hidden = 0; break;
                default:
                    weakSelf.settingsView.alpha = 0;
                    weakSelf.mapView.alpha = 0;
                    weakSelf.mapViewStatusBarBlur.hidden = 1;
                    weakSelf.imageView.alpha = 1; break;
            }
        });
        
    });
    
}

- (void)changeScalesImageAndShadowLevel:(float)containerFrameY {
    
    CGFloat selfCenter = (selfFrame.size.height * 0.64);
    
    if( containerFrameY < selfCenter) {
        
        CGFloat procent = (((selfCenter -containerFrameY) / selfCenter) / 2);
        
        CGAffineTransform transform = CGAffineTransformMakeScale( 1. -(procent / 5), 1. -(procent / 5));
        
        self.imageView.transform = transform;
        self.imageView.layer.cornerRadius = (procent * 24);
        
        self.settingsView.transform = transform;
        self.settingsView.layer.cornerRadius = (procent * 24);
        
        self.mapView.transform = transform;
        self.mapView.layer.cornerRadius = (procent * 24);
        
        self.mapViewStatusBarBlur.alpha = (1 -procent *2);
        
        self.shadowView.alpha = procent;
        self.shadowView.frame = (CGRect) {
            CGPointZero,
            {
                selfFrame.size.width,
                containerFrameY + ((self.containerCornerRadius == 0) ? 15 : self.containerCornerRadius )
            }
        };
        
    } else {
        
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.layer.cornerRadius = 0;
        
        self.settingsView.transform = CGAffineTransformIdentity;
        self.settingsView.layer.cornerRadius = 0;
        
        self.mapView.transform = CGAffineTransformIdentity;
        self.mapView.layer.cornerRadius = 0;
        
        self.mapViewStatusBarBlur.alpha = 1;
        
        self.shadowView.alpha = 0.;
        self.shadowView.frame = selfFrame;
    }
}

#pragma mark - Change in characteristics ContainerView

- (IBAction)changeStatusbar:(UISwitch *)sender {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    if(!sender.on) {
        statusBarHidden(YES);
        self.mapViewStatusBarBlur.hidden = 1;
    } else {
        statusBarHidden(NO);
        self.mapViewStatusBarBlur.hidden = 0;
    }
    
#pragma clang diagnostic pop
    
}

- (IBAction)changeContainerMoveType:(UISwitch *)sender {
    
    self.containerView.containerMove3position = sender.on;
    self.tableDelegate.containerMove3position = sender.on;
    self.collectionDelegate.containerMove3position = sender.on;
}

- (IBAction)changeContainerAlpha:(UISlider *)sender {
    self.containerView.alpha = sender.value;
}

- (IBAction)changeContainerTitleType:(UISegmentedControl *)sender {
    [self.containerView changeTitleType:sender.selectedSegmentIndex];
}

- (IBAction)changeContainerStyle:(UISegmentedControl *)sender {
    
    self.tableDataSource.containerStyle = sender.selectedSegmentIndex;
    self.collectionDataSource.containerStyle = sender.selectedSegmentIndex;
    
    [self.containerView changeBlurStyle:sender.selectedSegmentIndex];
    
    animations(.25,^(void){
        
        if(sender.selectedSegmentIndex == ContainerStyleDark)
        {
            self.mapView.mapType = MKMapTypeHybrid;
            self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            statusBarStyle(YES);
            self.view        .backgroundColor = RGB(55, 55, 55);
            self.settingsView.backgroundColor = RGB(66, 66, 66);
        }
        else
        {
            self.mapView.mapType = MKMapTypeStandard;
            self.mapViewStatusBarBlur.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            statusBarStyle(NO);
            self.view        .backgroundColor = RGB(235, 235, 241);
            self.settingsView.backgroundColor = RGB(225, 225, 231);
        }
    });
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (IBAction)changeContainerSizeTop:(UISlider *)sender {

    [self.containerView changePositionMoveType:ContainerMoveTypeTop newValue:sender.value];
    self.tableDelegate.containerTop = sender.value;
    self.collectionDelegate.containerTop = sender.value;
    self.containerLabelValueTop.text = SFMT(@"%.0f", sender.value);
}

- (IBAction)changeContainerSizeBottom:(UISlider *)sender {
    [self.containerView changePositionMoveType:ContainerMoveTypeBottom newValue:sender.value];
    self.containerLabelValueBottom.text = SFMT(@"%.0f", sender.value);
}

- (IBAction)changeContainerCornerRadius:(UISlider *)sender {
    self.containerCornerRadius = sender.value;
    [self.containerView changeCornerRadius: self.containerCornerRadius];
    self.containerLabelValueCornerRadius.text = SFMT(@"%d", (int)self.containerCornerRadius);
}

- (IBAction)changeContainerScrollViewType:(UISegmentedControl *)sender {
    
    animations(.25,^(void){
        switch (sender.selectedSegmentIndex) {
            case 0: self.tableView.alpha =1; self.collectionView.alpha =0; break;
            case 1: self.tableView.alpha =0; self.collectionView.alpha =1; break;
            case 2: self.tableView.alpha =0; self.collectionView.alpha =0; break;
            default: break;
        }
    });
}






@end
