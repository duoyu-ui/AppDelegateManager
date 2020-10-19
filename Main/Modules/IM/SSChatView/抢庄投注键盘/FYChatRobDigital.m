//
//  FYChatRobDigital.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import "FYChatRobDigital.h"
#import "FYChatRobKeyboardCell.h"

@interface FYChatRobDigital ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** 宽*/
@property (nonatomic, assign) CGFloat cellw;
/** 高*/
@property (nonatomic, assign) CGFloat cellh;

/** 数据源*/
@property (nonatomic, strong) NSMutableArray<FYChatRobKeyboardModel*> *dataSource;
@end
@implementation FYChatRobDigital
- (void)setType:(NSInteger)type{
    _type = type;
}
- (void)setInput:(NSString *)input{
    _input = input;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KeyboardH) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[FYChatRobKeyboardCell class] forCellWithReuseIdentifier:FYChatRobKeyboardCellID];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYChatRobKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYChatRobKeyboardCellID forIndexPath:indexPath];
    cell.titleLab.font = [UIFont systemFontOfSize:22];
    
    FYChatRobKeyboardModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 12) {
        cell.bgView.image = [UIImage imageNamed:@"RobtouKeyboardIcon_icon"];
    }else{
        cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_icon"];
    }
    if ( indexPath.row == 11){
        cell.deleteImge.image = [UIImage imageNamed:@"deleteRobIcon"];
    }else{
        cell.titleLab.text = model.text;
        if (indexPath.row == 12) {
            cell.titleLab.textColor = UIColor.whiteColor;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {//手动输入
        return CGSizeMake(self.cellw * 1.5, self.cellh);
    }else if (indexPath.row == 11){//删除
        return CGSizeMake(self.cellw * 0.5, self.cellh);
    }else if (indexPath.row == 12){//投注.抢庄
        return CGSizeMake(SCREEN_WIDTH, self.cellh);
    }else{
        return CGSizeMake(self.cellw,self.cellh);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AudioServicesPlaySystemSound(1105);
    FYChatRobKeyboardModel *model = self.dataSource[indexPath.row];

    switch (indexPath.row) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardNum:row:keyType:)]) {
                [self.delegate chatRobKeyboardNum:model.text row:indexPath.row keyType:1];
            }
            break;
        case 10://手动输入
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardInput:)]) {
                [self.delegate chatRobKeyboardInput:1];
            }
            break;
        case 11://删除
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardDelete:)]) {
                [self.delegate chatRobKeyboardDelete:1];
            }
            break;
        case 12://抢庄 投注
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardType:keyType:)]) {
                [self.delegate chatRobKeyboardType:self.type keyType:1];
            }
            break;
        default:
           
            break;
    }
}
////取消选定
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    FYChatRobKeyboardCell *cell = (FYChatRobKeyboardCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//    if (indexPath.row < 11 ) {
//        cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_icon"];
//    }
//
//}
- (CGFloat)cellh{
    return KeyboardH / 5;
}
- (CGFloat)cellw{
    return SCREEN_WIDTH / 3 - 2;
}
- (NSMutableArray<FYChatRobKeyboardModel *> *)dataSource{
    if (!_dataSource) {
        NSMutableArray <NSString *>*lists = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",NSLocalizedString(@"快捷输入", nil),@"deleteRobIcon",_input, nil];
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
        [lists enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FYChatRobKeyboardModel *model = [[FYChatRobKeyboardModel alloc]init];
            model.text = obj;
            [datas addObject:model];
        }];
        _dataSource = [NSMutableArray arrayWithArray:datas];
    }
    return _dataSource;
}

@end
