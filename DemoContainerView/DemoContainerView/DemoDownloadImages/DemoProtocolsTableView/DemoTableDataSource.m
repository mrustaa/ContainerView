
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "DemoTableDataSource.h"
#import "DemoTableCell.h"

#import "UIView+Frame.h"
#import "ContainerDefines.h"

@implementation DemoTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.photos.count ;
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

@end
