//
//  FYBagLotteryLayout.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryLayout.h"
#import "FYBagLotteryBackgroundReusableView.h"
//#import "FYBagLotteryLayoutAttributes.h"
static NSString *const FYBagLotteryBackgroundReusableViewID = @"FYBagLotteryBackgroundReusableViewID";
@interface FYBagLotteryLayout()


@end
@implementation FYBagLotteryLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layoutAttributes = [NSMutableArray array];
        [self setUp];
    }
    return self;
}
- (void)setUp{
    [self registerClass:[FYBagLotteryBackgroundReusableView class] forDecorationViewOfKind:FYBagLotteryBackgroundReusableViewID];
}
- (void)prepareLayout{
    [super prepareLayout];
    [self.layoutAttributes removeAllObjects];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    id delegate = self.collectionView.delegate;
    if (!numberOfSections || ![delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)]) {
        return;
    }
    for (NSInteger section = 0; section < numberOfSections; section++) {
           NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
           if (numberOfItems <= 0) {
               continue;
           }
           UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
           UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];
           if (!firstItem || !lastItem) {
               continue;
           }
           
           UIEdgeInsets sectionInset = [self sectionInset];

           if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
               UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
               sectionInset = inset;
           }

           
           CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
           sectionFrame.origin.x -= sectionInset.left;
           sectionFrame.origin.y -= sectionInset.top + 35;//+组头的高度
           
           if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
               sectionFrame.size.width += sectionInset.left + sectionInset.right;
               sectionFrame.size.height = self.collectionView.frame.size.height;
           } else {
               sectionFrame.size.width = self.collectionView.frame.size.width;
               sectionFrame.size.height += sectionInset.top + sectionInset.bottom + 35;
           }
           
           // 2、定义
           UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:FYBagLotteryBackgroundReusableViewID withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
           attr.frame = sectionFrame;
           attr.zIndex = -1;
           
//           attr.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:section];
           [self.layoutAttributes addObject:attr];
       }
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
     NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributes) {
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return attrs;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([elementKind isEqualToString:FYBagLotteryBackgroundReusableViewID]) {
        return [self.layoutAttributes objectAtIndex:indexPath.section];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}
@end
