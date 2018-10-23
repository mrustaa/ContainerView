
//  Created by Rustam Motygullin on 29.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "DemoCollectionDelegate.h"

@implementation DemoCollectionDelegate

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.blockSelectIndex) self.blockSelectIndex(indexPath.row);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat indent =  (((selfFrame.size.width - ((selfFrame.size.width * .437333) * 2)) / 3) / 2);
    CGFloat imageSize = (selfFrame.size.width * .437333);
    
    CGSize size = (CGSize) {
        ((imageSize + (indent * 2)) -1),
        (imageSize +  indent + 36)
    };
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    CGFloat indent = (((selfFrame.size.width - ((selfFrame.size.width * .437333) * 2)) / 3) / 2);
    return UIEdgeInsetsMake(indent,indent,0,indent);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return .0;
}


@end
