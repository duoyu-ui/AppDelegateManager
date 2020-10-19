//
//  GroupHeadView.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupHeadView.h"
#import "UserCollectionViewCell.h"
#import "GroupNet.h"
#import "MessageItem.h"
#import "GroupInfoUserModel.h"


@interface GroupHeadView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) MessageItem *item;

@property (nonatomic, strong) UIButton *totalBtn;

@property (nonatomic, strong) NSMutableArray <GroupInfoUserModel *>*dataList;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GroupHeadView


+ (GroupHeadView *)headViewWithModel:(GroupNet *)model item:(MessageItem *)item isGroupLord:(BOOL)isGroupLord {
    GroupHeadView *view = [[GroupHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    view.item = item;
    NSMutableArray <GroupInfoUserModel*>*models = [GroupInfoUserModel mj_objectArrayWithKeyValuesArray:model.dataList];
    [models enumerateObjectsUsingBlock:^(GroupInfoUserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.avatar hasPrefix:@"http"]) {
            obj.avatar = @"http://user-default";
        }
        if (isGroupLord) {//群主
            if (idx < 13) {
                [view.dataList addObject:obj];
            }
        }else{//自建群
            if (item.officeFlag){
                [view.dataList addObject:obj];
            }else{
                if (idx < 14) {
                    [view.dataList addObject:obj];
                }
            }
        }
    }];
    
    if (isGroupLord) {
        GroupInfoUserModel *model = [[GroupInfoUserModel alloc] init];
        model.avatar = @"group_+";
        [view.dataList addObject:model];
        GroupInfoUserModel *model1 = [[GroupInfoUserModel alloc] init];
        model1.avatar = @"group_-";
        [view.dataList addObject:model1];
    }else {
        if (!item.officeFlag) {
            GroupInfoUserModel *model1 = [[GroupInfoUserModel alloc] init];
            model1.avatar = @"group_+";
            [view.dataList addObject:model1];
        }
    }

    NSInteger lorow = (view.dataList.count == 0) ? 0 : (view.dataList.count)/5 + ((view.dataList.count) % 5 > 0 ? 1: 0);
    CGFloat height = (lorow > 3 ? 3 : lorow) * CD_Scal(82, 667) + 50;
    view.height = height;
    view.isGroupLord = isGroupLord;
    [view updateList:model];
    return view;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
        [self makeLayout];
    }
    return self;
}

- (void)updateList:(GroupNet *)model {
    [self.collectionView reloadData];
    
    NSString *count = [NSString stringWithFormat:NSLocalizedString(@"全部群成员(%ld)>", nil), model.total];
    UIColor *textColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:count];
    NSRange rang = NSMakeRange(0, count.length);
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize2:14] range:rang];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(rang.location, rang.length)];
    [self.totalBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
}

- (void)setupSubview {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/5, CD_Scal(82, 667));
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:NSClassFromString(@"UserCollectionViewCell") forCellWithReuseIdentifier:@"UserCollectionViewCell"];
    [self addSubview:_collectionView];
    
    _totalBtn = [UIButton new];
    _totalBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_totalBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_totalBtn addTarget:self action:@selector(checkAllClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_totalBtn];
}

- (void)makeLayout {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    
    [self.totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.collectionView.mas_bottom).offset(0);
        make.width.equalTo(self.mas_width).offset(-60);
        make.height.equalTo(@(50));
    }];
}


#pragma mark - <UICollectionViewDataSource && UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
    if (self.dataList.count > indexPath.row) {
        cell.model = self.dataList[indexPath.row];
        __weak __typeof(self)weakSelf = self;
        cell.block = ^(NSInteger tag) {
            if (weakSelf.didHeaderBlock) {
                if (tag == 100000 || tag == 100001) {
                    weakSelf.didHeaderBlock(@(tag));
                }else {
                    weakSelf.didHeaderBlock(self.dataList[indexPath.row]);
                }
            }
        };
    }

    return cell;
}

#pragma mark - Action

- (void)checkAllClick {
    if (self.didHeaderBlock) {
        self.didHeaderBlock(0);
    }
}

#pragma mark - Getter

- (NSMutableArray<GroupInfoUserModel *> *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
}
@end
