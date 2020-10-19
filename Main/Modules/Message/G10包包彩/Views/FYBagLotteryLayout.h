//
//  FYBagLotteryLayout.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol FYCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
//
//- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;
//
//@end

@interface FYBagLotteryLayout : UICollectionViewFlowLayout
/// 存储添加的属性
@property (nonatomic , strong) NSMutableArray<UICollectionViewLayoutAttributes*> *layoutAttributes;
@end

