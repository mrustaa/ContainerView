
//  Created by Rustam Motygullin on 03.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.


#import "DemoViewController.h"

#import "DemoHeaderViews.h"
#import "DemoTableCell.h"
#import "DemoCollectionCell.h"

#import "UIView+Frame.h"
#import "Defines.h"


@interface DemoViewController () <ContainerViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>


@property (strong, nonatomic) NSMutableArray <NSDictionary *> *photos;

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
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.alpha = 0;
    }
    [self.bottomView addSubview:_imageView];
    
    
    [self.mapView setRegion:[self.mapView regionThatFits:COORDINATE_SAN_FRANCISCO]];
    self.mapView.alpha = 0;
    
    self.mapViewStatusBarBlur.alpha = 1;
    self.mapViewStatusBarBlur.height = SCREEN_STATUS_HEIGHT;
    
    
    [self.containerView addSubview:[self createTableView]];
    
    self.changeCornerRadius = 15;
    
    /// [self containerMove:ContainerMoveTypeTop animated:NO];
    /// self.containerBottomButtonToMoveTop = YES;
    
    self.delegate = self;
    

    [self.view addSubview: self.containerView];
    
    [self initPhotos];

}

#pragma mark - ContainerView Delegate

- (void)changeContainerMove:(ContainerMoveType)containerMove containerY:(CGFloat)containerY animated:(BOOL)animated {
    [super changeContainerMove:containerMove containerY:containerY animated:animated];
    if(animated) {
        self.segmentedContainerMove.selectedSegmentIndex = containerMove;
    }
}


#pragma mark - Init Photos Items For TableView & CollecionView

- (void)initPhotos {
    
    for (int count =0; count < 46; count++) {
        UIImage *img = IMG( SFMT(@"IMG_%d",count) );
        UIImage *imgSmall = [self imageWithImage:img size:200];
        
        [self.photos addObject:@{ @"big"   : img,
                                  @"small" : imgSmall }];
    }
    if(self.tableView)      [self.tableView      reloadData];
    if(self.collectionView) [self.collectionView reloadData];
}


- (NSMutableArray *)photos {
    if(!_photos) _photos = [NSMutableArray new];
    return _photos;
}


- (UIImage *)imageWithImage:(UIImage *)image size:(NSInteger)size {
    
    CGSize cgSize = (CGSize) {          size, (image.size.height / (image.size.width / size) )};
    CGRect cgRect = (CGRect) { {0, 0}, {size, (image.size.height / (image.size.width / size) )}};
    UIGraphicsBeginImageContextWithOptions( cgSize, NO, 0.0);
    [image drawInRect: cgRect ];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Create ScrollViews

- (UITableView *)createTableView {
    
    if(!_tableView)
    {
        UITableView *
        table = [[UITableView alloc] initWithFrame:FRAME_SCROLLVIEW style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        table.backgroundColor = CLR_COLOR;
        table.delegate   = self;
        table.dataSource = self;

        _tableView = table;
    }
    
    return _tableView;
}


- (UICollectionView *)createCollectionView {
    
    if(!_collectionView)
    {
        UICollectionView *
        collection = [[UICollectionView alloc]initWithFrame:FRAME_SCROLLVIEW collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        [collection registerClass:[DemoCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
        collection.backgroundColor = CLR_COLOR;
        collection.delegate   = self;
        collection.dataSource = self;
        _collectionView = collection;
    }
    
    return _collectionView;
}

- (UITextView *)createTextView {
    
    if(!_textView) {
        UITextView * textView = [[UITextView alloc]initWithFrame:FRAME_SCROLLVIEW];
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyDone;
        textView.backgroundColor = CLR_COLOR;
        textView.textColor = (self.containerStyle == ContainerStyleDark) ?WHITE_COLOR :BLACK_COLOR;
        textView.font = FONT_S(15);
        textView.text = @"This example demonstrates a block quote. Because some introductory phrases will lead\
        naturally into the block quote,\
        you might choose to begin the block quote with a lowercase letter. In this and the later\
        examples we use “Lorem ipsum” text to ensure that each block quotation contains 40 words or\
        more. Lorem ipsum dolor sit amet, consectetur adipiscing elit. (Organa, 2013, p. 234)\
        Example 2\
        This example also demonstrates a block quote. Some introductory sentences end abruptly in a\
        colon or a period:\
        In those cases, you are more likely to capitalize the beginning word of the block quotation.\
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae,\
        commodo accumsan dui. Donec non scelerisque quam. Pellentesque ut est sed neque.\
        (Calrissian, 2013, para. 3)\
        Example 3\
        This is another example of a block quotation. Sometimes, the author(s) being cited will be\
        included in the introduction. In that case, according to Skywalker and Solo,\
        because the author names are in the introduction of this quote, the parentheses that follow it\
        will include only the year and the page number. Lorem ipsum dolor sit amet, consectetur\
        adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae, commodo accumsan dui. Donec non\
        scelerisque quam. Pellentesque ut est sed neque. (2013, p. 103)\
        Copyright © 2013 by the American Psychological Association. This content may be reproduced for classroom or teaching purposes\
            provided that credit is given to the American Psychological Association. For any other use, please contact the APA Permissions Office.\
            Example 4\
            In this example, we have added our own emphasis. This needs to be indicated parenthetically,\
            so the reader knows that the italics were not in the original text. Amidala (2009) dabbled in hyperbole,\
            saying,\
            Random Explosions 2: Revenge of the Dialogue is the worst movie in the history of time\
        [emphasis added]. . . . it’s [sic] promise of dialogue is a misnomer of explosive proportions. Lorem ipsum\
            dolor sit amet, consectetur adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae. (p. 13)\
            This paragraph appears flush left because it is a continuation of the paragraph we began above the block\
            quote. Note that we also added “[sic]” within the block quotation to indicate that a misspelling was in\
            the original text, and we’ve included ellipses (with four periods) because we have omitted a sentence\
            from the quotation (see pp. 172–173 of the Publication Manual of the American Psychological\
                                Association).\
            Example 5\
            This example is similar to the previous one, except that we have continued the quotation to\
            include text from a second paragraph. Amidala (2009) dabbled in hyperbole, saying,\
            Random Explosions 2: Revenge of the Dialogue is the worst movie in the history of time\
            [emphasis added]. . . . it’s [sic] promise of dialogue is a misnomer of explosive proportions.\
            On the other hand, Delightful Banter on Windswept Mountainside is a film to be\
            cherished for all time. Filmmakers hoping to top this film should abandon hope. (p. 13)\
                This paragraph begins with an indent because we do not intend it to continue the paragraph\
                    that we started above the block quote. Note that we also added “[sic]” within the block quotation to\
                    indicate that a misspelling was in the original text, and we’ve included ellipses (with four periods)\
                    because we have omitted a sentence from this quotation (see pp. 172–173 of the Manual).";
        

        _textView = textView;
    }
    return _textView;
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
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if(!cell) {
        cell = [[DemoTableCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"TableCell" ];
        cell.backgroundColor = CLR_COLOR;
    }
    
    if(!cell.separatorLine) {
        cell.separatorLine = [[UIView alloc]initWithFrame:(CGRect){ {16 , 87.5}, {SCREEN_WIDTH -32 , 0.5} }];
        cell.separatorLine.backgroundColor = RGB(222, 222, 222);
        [cell addSubview: cell.separatorLine];
    }
    
    if(!cell.labelTitle) {
        cell.labelTitle  = [[UILabel alloc]initWithFrame:(CGRect){ {18 , 20}, {SCREEN_WIDTH -67 , 30} }];
        cell.labelTitle.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:22];
        cell.labelTitle.textColor = BLACK_COLOR;
        [cell addSubview:cell.labelTitle];
    }
    
    if(!cell.labelSubTitle) {
        cell.labelSubTitle  = [[UILabel alloc]initWithFrame:(CGRect){ {18 , 50}, {SCREEN_WIDTH -67, 16} }];
        cell.labelSubTitle.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
        cell.labelSubTitle.textColor = RGB(124,132,148);
        [cell addSubview:cell.labelSubTitle];
    }
    
    cell.labelTitle   .text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d", (int)indexPath.row) : @"settings" ;
    cell.labelSubTitle.text = @"Subtitle";
    cell.labelTitle.textColor = (self.containerStyle == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;
    
    switch (self.containerStyle) {
        case ContainerStyleDefault: {
            cell.separatorLine.backgroundColor = GRAYLEVEL(222);
            cell.separatorLine.alpha = 1;
        }    break;
        case ContainerStyleLight:{
            cell.separatorLine.backgroundColor = GRAYLEVEL(180);
            cell.separatorLine.alpha = 0.5;
        }    break;
        case ContainerStyleDark:{
            cell.separatorLine.backgroundColor = GRAYLEVEL(222);
            cell.separatorLine.alpha = 0.2;
        }    break;
        case ContainerStyleExtraLight:{
            cell.separatorLine.backgroundColor = GRAYLEVEL(180);
            cell.separatorLine.alpha = 0.5;
        }    break;
        default:
            break;
    }
    
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
    return self.photos.count ;
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
    
    if(!cell.label)
    {
        cell.label  = [[UILabel alloc]initWithFrame:(CGRect) {{8, cellSize.height -26}, {cellSize.width -16, 18}}];
        cell.label.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:14];
        cell.label.textColor = BLACK_COLOR;
        [cell addSubview:cell.label];
    }
    
    cell.imageView.frame = (CGRect) {{indent, indent}, {imageSize, imageSize}};
    cell.imageView.image = self.photos[indexPath.row][@"small"];
    
    cell.label.text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d",(int)indexPath.row) : @"settings" ;
    cell.label.textColor = (self.containerStyle == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;
    
    return cell;
}

#pragma mark - Select Actions

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


#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(self.containerPosition != ContainerMoveTypeTop) [self containerMove:ContainerMoveTypeTop];
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
    
    if(self.tableView)      [self.tableView      reloadData];
    if(self.collectionView) [self.collectionView reloadData];
}

- (IBAction)changeContainerSizeTop:(UISlider *)sender {
    CGFloat top = sender.value;
    
    [self containerMoveCustomPosition:top moveType:ContainerMoveTypeTop animated:YES];
    
    self.containerTop = IS_IPHONE_X ? top -24 : top;
    self.containerLabelValueTop.text = SFMT(@"%.0f y", top);
}

- (IBAction)changeContainerSizeBottom:(UISlider *)sender {
    CGFloat bottom = (SCREEN_HEIGHT -((sender.maximumValue +50) -sender.value));
    
    [self containerMoveCustomPosition:bottom moveType:ContainerMoveTypeBottom animated:NO];
    
    self.containerBottom = IS_IPHONE_X ? bottom +34 : bottom;
    self.containerLabelValueBottom.text = SFMT(@"%.0f y", bottom);
}


- (IBAction)changeContainerCornerRadius:(UISlider *)sender {
    self.changeCornerRadius = sender.value;
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
        case 0: [self.containerView addSubview:[self createTableView]];      break;
        case 1: [self.containerView addSubview:[self createCollectionView]]; break;
        case 2: [self.containerView addSubview:[self createTextView]];       break;
        default: break;
    }
    
}






@end
