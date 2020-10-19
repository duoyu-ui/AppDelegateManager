//
//  FYBagLotteryHistoryView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryHistoryView.h"
#import "FYBagLotteryHistoryCell.h"
static NSString *const FYBagLotteryHistoryCellID = @"FYBagLotteryHistoryCellID";
@interface FYBagLotteryHistoryView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) NSMutableArray<FYBegLotteryHistoryData*> *lists;

@property (nonatomic , strong) NSMutableArray<FYBagBagCowRecordData*> *cowLists;
@property (nonatomic , assign) NSInteger type;
@end
@implementation FYBagLotteryHistoryView
+ (void)showHistoryViewWithList:(NSArray<FYBegLotteryHistoryData*>*)lists{
    FYBagLotteryHistoryView *hview = [[FYBagLotteryHistoryView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hview];
    [hview showHistoryViewWithList:lists];
}
- (void)showHistoryViewWithList:(NSArray<FYBegLotteryHistoryData*>*)lists{
    [self.lists removeAllObjects];
    CGFloat tabH = 0;
    if (lists.count < 10) {
        [self.lists addObjectsFromArray:lists];
        tabH = lists.count * 40;
    }else{
        [lists enumerateObjectsUsingBlock:^(FYBegLotteryHistoryData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 10) {
                [self.lists addObj:obj];
            }
        }];
        tabH = 400;
    }
    CGFloat tabX = [UIApplication sharedApplication].statusBarFrame.size.height + 40 + kNavBarHeight;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(tabH);
        make.top.mas_equalTo(tabX);
    }];
    [self.tableView reloadData];
}
+ (void)showBagBagCowHistoryViewWith:(NSArray<FYBagBagCowRecordData*>*)lists type:(NSInteger)type{
    FYBagLotteryHistoryView *hview = [[FYBagLotteryHistoryView alloc]initWithFrame:[UIScreen mainScreen].bounds];
      [[UIApplication sharedApplication].keyWindow addSubview:hview];
      [hview showBagBagCowHistoryViewWith:lists type:type];
}
-(void)showBagBagCowHistoryViewWith:(NSArray<FYBagBagCowRecordData*>*)lists type:(NSInteger)type{
    [self.cowLists removeAllObjects];
    self.type = type;
    CGFloat tabH = 0;
    if (lists.count < 10) {
        [self.cowLists addObjectsFromArray:lists];
        tabH = lists.count * 40;
    }else{
        [lists enumerateObjectsUsingBlock:^(FYBagBagCowRecordData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 10) {
                [self.cowLists addObj:obj];
            }
        }];
        tabH = 400;
    }
    CGFloat tabX = [UIApplication sharedApplication].statusBarFrame.size.height + 40 + kNavBarHeight;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(tabH);
        make.top.mas_equalTo(tabX);
    }];
    [self.tableView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.bgView];
    self.bgView.frame = self.bounds;
    [self addSubview:self.tableView];
}
- (void)dismissNoneView{

}
- (void)dismissHistoryView{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}
-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[FYBagLotteryHistoryCell class] forCellReuseIdentifier:FYBagLotteryHistoryCellID];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissHistoryView)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYBagLotteryHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:FYBagLotteryHistoryCellID];
    if (self.type == GroupTemplate_N11_BagBagCow) {
        if (self.cowLists.count > indexPath.row) {
            cell.cowList = self.cowLists[indexPath.row];
        }
    }else{
        if (self.lists.count > indexPath.row) {
            cell.list = self.lists[indexPath.row];
        }
    }
    if (indexPath.row != 0) {
        cell.hubBtn.hidden = YES;
        //
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNoneView)];
        [cell.contentView addGestureRecognizer:tapGesture];
    }else{
        cell.hubBtn.hidden = NO;
        [cell.hubBtn addTarget:self action:@selector(dismissHistoryView) forControlEvents:UIControlEventTouchUpInside];
        //
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHistoryView)];
        [cell.contentView addGestureRecognizer:tapGesture];
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == GroupTemplate_N11_BagBagCow) {
        return self.cowLists.count;
    }else{
        return self.lists.count;
    }
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSMutableArray<FYBegLotteryHistoryData *> *)lists{
    if (!_lists) {
        _lists = [NSMutableArray arrayWithCapacity:0];
    }
    return _lists;
}
- (NSMutableArray<FYBagBagCowRecordData *> *)cowLists{
    if (!_cowLists) {
        _cowLists = [NSMutableArray array];
    }
    return _cowLists;
}
@end
