//
//  FYChatRobMoney.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import "FYChatRobMoney.h"
#import "FYChatRobKeyboardCell.h"
@interface FYChatRobMoney ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** 宽*/
@property (nonatomic, assign) CGFloat cellw;
/** 高*/
@property (nonatomic, assign) CGFloat cellh;
/** 加注*/
@property (nonatomic, copy) NSString *filling;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<FYChatRobKeyboardModel*> *dataSource;
@end
@implementation FYChatRobMoney
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
}
- (void)setType:(NSInteger)type{
    _type = type;
    switch (_type) {
        case 2://抢庄
            [self setRobNN];
            break;
        case 3://投注
            [self setBetting];
            break;
        default:
            break;
    }
}

//投注
- (void)setBetting{
    [self.dataSource removeAllObjects];
    NSString *bettMoneyList = [NSString stringWithFormat:@"%@",_dict[@"bettMoneyList"]];
    NSArray <NSString *>*bettLists = [bettMoneyList componentsSeparatedByString:@","];
    
    for (int i = 0; i < 13; i++) {
        FYChatRobKeyboardModel *model = [[FYChatRobKeyboardModel alloc]init];
        if (i < 10) {
            model.text = bettLists[i];
            
        }else if (i == 10){
            model.text = NSLocalizedString(@"手动输入", nil);
        }else if (i == 11){
            model.text = @"deleteRobIcon";
        }else if (i == 12){
            model.text = NSLocalizedString(@"投注", nil);
            
        }
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
}
//抢庄
- (void)setRobNN{
    [self.dataSource removeAllObjects];
    NSString *robLists = [NSString stringWithFormat:@"%@",_dict[@"rabBankerMoneyList"]];
    NSArray <NSString *>*lists = [robLists componentsSeparatedByString:@","];
    self.filling = [NSString stringWithFormat:@"%@",_dict[@"rabBankerMoney"]];
    if (lists.count == 0 || lists == nil) {
        return;
    }
    for (int i = 0; i < 13; i++) {
        FYChatRobKeyboardModel *model = [[FYChatRobKeyboardModel alloc]init];
        if (i < 9) {
            model.text = lists[i];
            
        }else if (i == 9){
            model.text = [NSString stringWithFormat:@"%@",self.filling];
        }else if (i == 10){
            model.text = NSLocalizedString(@"手动输入", nil);
        }else if (i == 11){
            model.text = @"deleteRobIcon";
        }else if (i == 12){
            model.text = NSLocalizedString(@"抢庄", nil);

        }
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
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
- (CGFloat)cellh{
    return KeyboardH / 5;
}
- (CGFloat)cellw{
    return SCREEN_WIDTH / 3 - 2;
}
- (NSMutableArray<FYChatRobKeyboardModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYChatRobKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYChatRobKeyboardCellID forIndexPath:indexPath];
    FYChatRobKeyboardModel *model = self.dataSource[indexPath.row];
 
    if (self.type == 2 && indexPath.row == 9) {
        cell.titleLab.text = [NSString stringWithFormat:NSLocalizedString(@"加注%@", nil),self.filling];
        cell.titleLab.font = [UIFont systemFontOfSize:18];
    }else{
        if (self.type == 2 && indexPath.row < 9){
            cell.titleLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil),model.text];
        }else if (self.type == 3 && indexPath.row < 10){
            cell.titleLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil),model.text];
        }else{
            cell.titleLab.text = model.text;
        }
        cell.titleLab.font = [UIFont systemFontOfSize:22];
        
    }
    if (indexPath.row != 10) {
        cell.titleLab.highlightedTextColor = UIColor.whiteColor;
    }
    if (indexPath.row == 12) {
        cell.bgView.image = [UIImage imageNamed:@"RobtouKeyboardIcon_icon"];
    }else{
        if (self.type == 2 && indexPath.row == 9) {
              cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_jiazhu"];
        }else{
            
            cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_icon"];
        }
    }
    if ( indexPath.row == 11){
        cell.titleLab.hidden = YES;
        cell.deleteImge.image = [UIImage imageNamed:@"deleteRobIcon"];
    }else{
        
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
    FYChatRobKeyboardCell *cell = (FYChatRobKeyboardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row < 10 ) {
        cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_icon_s"];
    }
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
                [self.delegate chatRobKeyboardNum:model.text row:indexPath.row keyType:2];
            }
            break;
        case 10://手动输入
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardInput:)]) {
                [self.delegate chatRobKeyboardInput:2];
            }
            break;
        case 11://删除
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardDelete:)]) {
                [self.delegate chatRobKeyboardDelete:2];
            }
            break;
        case 12://抢庄 投注
            if ([self.delegate respondsToSelector:@selector(chatRobKeyboardType:keyType:)]) {
                [self.delegate chatRobKeyboardType:self.type keyType:2];
            }
            break;
        default:
            
            break;
    }
}
//取消选定
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    FYChatRobKeyboardCell *cell = (FYChatRobKeyboardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row < 10 ) {
        if (self.type == 2 && indexPath.row == 9) {
            cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_jiazhu"];
            
        }else{
            cell.bgView.image = [UIImage imageNamed:@"RobKeyboardIcon_icon"];
        }
    }
    
}
@end
