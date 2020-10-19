//
//  FYJJSLRecordHudView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJJSLRecordHudView.h"
#import "FYJJSLRecordHudCell.h"
@interface FYJJSLRecordHudView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) NSMutableArray<FYJSSLRecordData*> *lists;
@end
@implementation FYJJSLRecordHudView
+ (void)showJSSLRecordWithData:(NSArray<FYJSSLRecordData*>*)datas{
    FYJJSLRecordHudView *hview = [[FYJJSLRecordHudView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hview];
    [hview showJSSLRecordWithData:datas];
}
- (void)showJSSLRecordWithData:(NSArray<FYJSSLRecordData*>*)lists{
    [self.lists removeAllObjects];
    CGFloat tabH = 0;
    if (lists.count < 10) {
        [self.lists addObjectsFromArray:lists];
        tabH = lists.count * 40;
    }else{
        [lists enumerateObjectsUsingBlock:^(FYJSSLRecordData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)dismissHistoryView{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}
- (void)dismissNoneView{

}
-(UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[FYJJSLRecordHudCell class] forCellReuseIdentifier:[FYJJSLRecordHudCell reuseIdentifier]];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorColor = UIColor.clearColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYJJSLRecordHudCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYJJSLRecordHudCell reuseIdentifier]];
    if (indexPath.row == 0) {
        cell.hubBtn.hidden = NO;
        [cell.hubBtn addTarget:self action:@selector(dismissHistoryView) forControlEvents:UIControlEventTouchUpInside];
        //
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHistoryView)];
        [cell.contentView addGestureRecognizer:tapGesture];
    }else{
        cell.hubBtn.hidden = YES;
        //
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNoneView)];
        [cell.contentView addGestureRecognizer:tapGesture];
    }
    if (self.lists.count > indexPath.row) {
        cell.list = self.lists[indexPath.row];
    }
    return cell;
}
/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}
/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSMutableArray<FYJSSLRecordData *> *)lists{
    if (!_lists) {
        _lists = [NSMutableArray arrayWithCapacity:0];
    }
    return _lists;
}
@end
