
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "DemoCollectionDataSource.h"
#import "ContainerMacros.h"

@implementation DemoCollectionCell
@end

@implementation DemoCollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionCell" forIndexPath: indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.clipsToBounds = YES;
    
    CGFloat indent =  (((selfFrame.size.width - ((selfFrame.size.width * .437333) * 2)) / 3) / 2);
    CGFloat imageSize = (selfFrame.size.width * .437333);
    
    CGSize cellSize = (CGSize)
    {
        ((imageSize + (indent * 2)) -1) ,
        (imageSize +  indent + 36)
    };

    if(!cell.imageView )
    {
        cell.imageView = [UIImageView new];
        cell.imageView.clipsToBounds = 1;
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
        cell.imageView.layer.cornerRadius = 6;
        [cell addSubview: cell.imageView];
    }
    
    if(!cell.label)
    {
        cell.label  = [[UILabel alloc]initWithFrame:(CGRect) {{8, cellSize.height -26}, {cellSize.width -16, 18}}];
        cell.label.font = [UIFont fontWithName:@"ProximaNova-Extrabld" size:14];
        cell.label.textColor = [UIColor blackColor];
        [cell addSubview:cell.label];
    }
    
    cell.imageView.frame = (CGRect) {{indent, indent}, {imageSize, imageSize}};
    cell.imageView.image = self.photos[indexPath.row];
    
    cell.label.text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d",(int)indexPath.row) : @"settings" ; 
    cell.label.textColor = (self.containerStyle == ContainerStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
    
    return cell;
}

@end
