//
//  GroupSettingRedPaperVC.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "GroupSettingRedPaperVC.h"
#import "GroupSettingRedPaperCell.h"

#import "FYSettingRedPaperHeader1.h"
#import "FYSettingRedPaperHeader2.h"
#import "FYSettingRedPaperHeader3.h"
#import "FYSettingRedPaperHeader4.h"
#import "FYSettingRedPaperFooterView.h"

#import "FYCreateGroupModel.h"

#define kSpace  7

static NSString *const kRedPaperHeader1Identifier = @"kRedPaperHeader1Identifier";
static NSString *const kRedPaperHeader2Identifier = @"kRedPaperHeader2Identifier";
static NSString *const kRedPaperHeader3Identifier = @"kRedPaperHeader3Identifier";
static NSString *const kRedPaperHeader4Identifier = @"kRedPaperHeader4Identifier";

static NSString *const kRedPaperCellIdentifier   = @"kRedPaperCellIdentifier";
static NSString *const kRedPaperFooterIdentifier = @"kRedPaperFooterIdentifier";

@interface GroupSettingRedPaperVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) FYCreateRequest *request;

/// 发包数量
@property (nonatomic, strong) NSArray *packetList;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation GroupSettingRedPaperVC

#pragma mark - Getter

- (FYCreateRequest *)request {
    
    if (!_request) {
        _request = [[FYCreateRequest alloc] init];
        _request.groupId = self.packetModel.groupId;
    }
    return _request;
}

- (NSArray *)titles {
    
    if (!_titles) {
        _titles = @[[FYCreateGroupModel initWithTitle:NSLocalizedString(@"抢庄加注金额", nil) subtitle:NSLocalizedString(@"本次投注在上一次抢庄金额基础上增多少金额", nil)],
                    [FYCreateGroupModel initWithTitle:NSLocalizedString(@"连续上庄支付比例", nil) subtitle:NSLocalizedString(@"上一期上庄金额的百分之多少", nil)]];
    }
    return _titles;
}

- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = kSpace;
        _layout.minimumInteritemSpacing = kSpace;
        _layout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        // 支持多选
        if (self.groupType == GroupTemplate_N04_RobNiuNiu || self.groupType == GroupTemplate_N05_ErBaGang) {
            _collectionView.allowsSelection = YES;
            _collectionView.allowsMultipleSelection = YES;
        }
        // cell
        [_collectionView registerClass:[GroupSettingRedPaperCell class] forCellWithReuseIdentifier:kRedPaperCellIdentifier];
        // header
        [_collectionView registerClass:[FYSettingRedPaperHeader1 class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kRedPaperHeader1Identifier];
        [_collectionView registerClass:[FYSettingRedPaperHeader2 class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kRedPaperHeader2Identifier];
        [_collectionView registerClass:[FYSettingRedPaperHeader3 class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kRedPaperHeader3Identifier];
        [_collectionView registerClass:[FYSettingRedPaperHeader4 class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kRedPaperHeader4Identifier];
        // footer
        [_collectionView registerClass:[FYSettingRedPaperFooterView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
               withReuseIdentifier:kRedPaperFooterIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = NSLocalizedString(@"红包设置", nil);
    if (self.packetModel == nil) {
        self.packetModel = [[FYCreateRequest alloc] init];
    }
    
    [self setupSubview];
    [self loadTemplateList];
}

- (void)setupSubview {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Request

/// 获取红包设置模板
- (void)loadTemplateList {
    [SVProgressHUD show];
    [[NetRequestManager sharedInstance] requestSelfGroupTemplateWithGroupType:self.groupType Success:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [object[@"code"] integerValue];
            if (code == 0) {
                [SVProgressHUD dismiss];
                NSDictionary *JSONData = [object[@"data"] mj_JSONObject];
                NSArray *templateList = JSONData[@"templateMoneyList"];
                // Configuration
                if (self.groupType == GroupTemplate_N01_Bomb) {
                    self.packetList = JSONData[@"packetsList"];
                    NSString *minCount = [NSString stringWithFormat:@"%@", [self.packetList firstObject]];
                    //NSString *maxCount = [NSString stringWithFormat:@"%@", [self.packetList lastObject]];
                    self.request.minCount = minCount; //最小包数
                    if (self.packetModel.maxCount) {
                        self.request.maxCount = self.packetModel.maxCount; //最大包数
                    }else {
                        self.request.maxCount = minCount; //(默认)最小包数
                    }
                    NSMutableArray *modelList = [FYCreateRequest mj_objectArrayWithKeyValuesArray:templateList];
                    if (modelList.count) {
                        [self.dataSource addObjectsFromArray:modelList];
                    }
                    
                }else if(self.groupType == GroupTemplate_N02_NiuNiu) {
                    NSString *minCount = [NSString stringWithFormat:@"%ld", [JSONData[@"minCount"] integerValue]];
                    NSString *maxCount = [NSString stringWithFormat:@"%ld", [JSONData[@"maxCount"] integerValue]];
                    self.request.minCount = minCount; //最小包数
                    self.request.maxCount = maxCount; //最大包数
                    NSMutableArray *modelList = [FYCreateRequest mj_objectArrayWithKeyValuesArray:templateList];
                    if (modelList.count) {
                        [self.dataSource addObjectsFromArray:modelList];
                    }
                    
                }else if (self.groupType == GroupTemplate_N08_ErRenNiuNiu) {
                    //NSString *minCount = [NSString stringWithFormat:@"%ld", [JSONData[@"minCount"] integerValue]];
                    //NSString *maxCount = [NSString stringWithFormat:@"%ld", [JSONData[@"maxCount"] integerValue]];
                    self.request.minCount = @"2"; //最小包数
                    self.request.maxCount = @"2"; //最大包数
                    NSMutableArray *modelList = [FYCreateRequest mj_objectArrayWithKeyValuesArray:templateList];
                    if (modelList.count) {
                        [self.dataSource addObjectsFromArray:modelList];
                    }
                    
                }else if (self.groupType == GroupTemplate_N04_RobNiuNiu ||
                          self.groupType == GroupTemplate_N05_ErBaGang) {
                    //抢庄牛牛和二八杠
                    NSArray *continuousAmountList = JSONData[@"continuousAmountList"];
                    NSArray *continuousPaymentList = JSONData[@"continuousPaymentList"];
                    NSMutableArray *list1 = [FYCreateRequest mj_objectArrayWithKeyValuesArray:continuousAmountList];
                    NSMutableArray *list2 = [FYCreateRequest mj_objectArrayWithKeyValuesArray:continuousPaymentList];
                    if (list1.count) {
                        [self.dataSource addObject:list1];
                    }
                    if (list2.count) {
                        [self.dataSource addObject:list2];
                    }
                }
                
                [self.collectionView reloadData];
                [self reloadSetDataEmpty:self.collectionView];
            }
        }
    } fail:^(id object) {
        [self reloadSetDataEmpty:self.collectionView];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


- (void)changeRedSetting {
    if (self.request.minCount) {
        self.packetModel.minCount = self.request.minCount;
    }
    if (self.request.maxCount) {
        self.packetModel.maxCount = self.request.maxCount;
    }
    
    if (self.request.groupId) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.request.groupId forKey:@"id"];
        if (self.groupType == GroupTemplate_N01_Bomb ||
            self.groupType == GroupTemplate_N02_NiuNiu ||
            self.groupType == GroupTemplate_N08_ErRenNiuNiu) {
            [params setObject:self.packetModel.minCount forKey:@"minCount"];
            [params setObject:self.packetModel.maxCount forKey:@"maxCount"];
            [params setObject:self.packetModel.minMoney forKey:@"minMoney"];
            [params setObject:self.packetModel.maxMoney forKey:@"maxMoney"];
        }else if (self.groupType == GroupTemplate_N04_RobNiuNiu ||
                  self.groupType == GroupTemplate_N05_ErBaGang) {
            [params setObject:@(self.packetModel.amount) forKey:@"rabBankerMoney"]; //连续上庄金额
            [params setObject:@(self.packetModel.payRatio) forKey:@"continueBankerPercent"]; //连续上庄比例
        }
        
        [SVProgressHUD show];
        [[NetRequestManager sharedInstance] updateGroupRedPacketWithGroupType:self.groupType
                                                                       params:params
                                                                      Success:^(id object) {
            [SVProgressHUD dismiss];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSInteger code = [object[@"code"] integerValue];
                if (code == 0) {
                    [self changedSuccess];
                }
            }
            
        } fail:^(id object) {
            [SVProgressHUD dismiss];
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
    
}

/// 修改成功
- (void)changedSuccess {
    [self didResultBack];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"   修改成功   ", nil)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)reloadSetDataEmpty:(UICollectionView *)tab {
    if (tab.emptyDataSetSource == nil) {
        tab.emptyDataSetSource = self;
        tab.emptyDataSetDelegate = self;
        [tab reloadEmptyDataSet];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.groupType == GroupTemplate_N04_RobNiuNiu ||
        self.groupType == GroupTemplate_N05_ErBaGang) {
        return self.dataSource.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.groupType == GroupTemplate_N04_RobNiuNiu ||
        self.groupType == GroupTemplate_N05_ErBaGang) {
        return [self.dataSource[section] count];
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupSettingRedPaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRedPaperCellIdentifier forIndexPath:indexPath];
    if (self.groupType == GroupTemplate_N01_Bomb ||
        self.groupType == GroupTemplate_N02_NiuNiu ||
        self.groupType == GroupTemplate_N08_ErRenNiuNiu) {
        if (self.dataSource.count > indexPath.row) {
            FYCreateRequest *dataModel = self.dataSource[indexPath.row];
            if (dataModel.max && dataModel.min) {
                if ((self.packetModel.maxMoney) && (self.packetModel.minMoney)) {
                    if (([self.packetModel.maxMoney integerValue] == dataModel.max) &&
                        ([self.packetModel.minMoney integerValue] == dataModel.min)) {
                        cell.selected = YES; //保存上次选中
                    }
                }else {
                    if (indexPath.row == 0) {
                        cell.selected = YES; //默认选中第一个
                        self.packetModel.maxMoney = [NSString stringWithFormat:@"%ld", dataModel.max];
                        self.packetModel.minMoney = [NSString stringWithFormat:@"%ld", dataModel.min];
                    }
                }
            }
            cell.model = dataModel;
        }
    }else if (self.groupType == GroupTemplate_N04_RobNiuNiu || self.groupType == GroupTemplate_N05_ErBaGang) {
        if (self.dataSource.count > indexPath.section) {
            NSArray <FYCreateRequest *> *modelArr = self.dataSource[indexPath.section];
            if (modelArr.count > indexPath.row) {
                FYCreateRequest *dataModel = modelArr[indexPath.row];
                if (indexPath.section == 0) {
                    if (self.packetModel.amount) {
                        if (self.packetModel.amount == dataModel.amount) {
                            cell.selected = YES;
                        }
                    }else {
                        if (indexPath.row == 0) {
                            cell.selected = YES;
                            self.packetModel.amount = dataModel.amount;
                        }
                    }
                }else {
                    if (self.packetModel.payRatio) {
                        if (self.packetModel.payRatio == dataModel.payRatio) {
                            cell.selected = YES;
                        }
                    }else {
                        if (indexPath.row == 0) {
                            cell.selected = YES;
                            self.packetModel.payRatio = dataModel.payRatio;
                        }
                    }
                }
                
                cell.model = dataModel;
            }
        }
    }
    return cell;
}

//支持创建的type（0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (self.groupType == GroupTemplate_N01_Bomb) {
            FYSettingRedPaperHeader3 *headerView3 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRedPaperHeader3Identifier forIndexPath:indexPath];
            headerView3.packetList = self.packetList;
            headerView3.didPacketBlock = ^(NSString * _Nullable amount) {
                weakSelf.request.maxCount = amount;
                weakSelf.packetModel.maxCount = amount;
            };
            if (self.packetModel.maxCount && self.request.maxCount) {
                headerView3.selectedNum = self.request.maxCount;
            }else if (self.request.maxCount) {
                headerView3.selectedNum = self.request.maxCount;
            }else {
                headerView3.selectedNum = self.request.minCount;
            }
            reusableView = headerView3;
        }else if (self.groupType == GroupTemplate_N02_NiuNiu) {
            FYSettingRedPaperHeader2 *headerView2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRedPaperHeader2Identifier forIndexPath:indexPath];
            headerView2.packetNum = [NSString stringWithFormat:NSLocalizedString(@"%@-%@  包", nil), self.request.minCount, self.request.maxCount];
            reusableView = headerView2;
        }else if (self.groupType == GroupTemplate_N04_RobNiuNiu ||
                  self.groupType == GroupTemplate_N05_ErBaGang) {
            FYSettingRedPaperHeader1 *headerView1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRedPaperHeader1Identifier forIndexPath:indexPath];
            if (self.titles.count > indexPath.section) {
                headerView1.model = self.titles[indexPath.section];
            }
            reusableView = headerView1;
        }else if (self.groupType == GroupTemplate_N08_ErRenNiuNiu) {
            FYSettingRedPaperHeader4 *headerView4 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRedPaperHeader4Identifier forIndexPath:indexPath];
            reusableView = headerView4;
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        if (self.groupType == GroupTemplate_N04_RobNiuNiu || self.groupType == GroupTemplate_N05_ErBaGang) {
            if (indexPath.section == self.dataSource.count - 1) {
                FYSettingRedPaperFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kRedPaperFooterIdentifier forIndexPath:indexPath];
                footerView.didSaveBlock = ^{
                    [weakSelf didSaveAction];
                };
                reusableView = footerView;
            }
        }else {
            FYSettingRedPaperFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kRedPaperFooterIdentifier forIndexPath:indexPath];
            footerView.didSaveBlock = ^{
                [weakSelf didSaveAction];
            };
            reusableView = footerView;
        }
    }
    
    reusableView.hidden = self.dataSource.count ? NO : YES;
    return reusableView;
}

#pragma mark - Action

- (void)didSaveAction {
    if (self.isUpdate) {
        [self changeRedSetting];
    }else {
        [self didResultBack];
    }
}

- (void)didResultBack {
    if (self.didSetedBlock) {
        self.packetModel.type = self.groupType; //记录类型
        if (self.packetModel.type == GroupTemplate_N08_ErRenNiuNiu) {
            self.packetModel.minCount = @"2"; //最小包数
            self.packetModel.maxCount = @"2"; //最大包数
        }else {
            self.packetModel.minCount = self.request.minCount; //最小包数
            self.packetModel.maxCount = self.request.maxCount; //最大包数
        }
        
        //self.packetModel.amount = self.request.amount;
        //self.packetModel.payRatio = self.request.payRatio;
        self.didSetedBlock(self.packetModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.groupType == GroupTemplate_N01_Bomb ||
        self.groupType == GroupTemplate_N02_NiuNiu ||
        self.groupType == GroupTemplate_N08_ErRenNiuNiu) {
        if (self.dataSource.count > indexPath.row) {
            self.packetModel = self.dataSource[indexPath.row];
            self.packetModel.maxMoney = [NSString stringWithFormat:@"%ld", self.packetModel.max];
            self.packetModel.minMoney = [NSString stringWithFormat:@"%ld", self.packetModel.min];
        }
    }else {
        if (self.dataSource.count > indexPath.section) {
            NSArray <FYCreateRequest *> *modelArr = self.dataSource[indexPath.section];
            if (modelArr.count > indexPath.row) {
                FYCreateRequest *dataModel = modelArr[indexPath.row];
                if (indexPath.section == 0) {
                    self.packetModel.amount = dataModel.amount;
                }else {
                    self.packetModel.payRatio = dataModel.payRatio;
                }
            }
        }
    }
    
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (SCREEN_WIDTH - 3 * kSpace) / 2;
    return CGSizeMake(itemWidth, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.groupType == GroupTemplate_N01_Bomb || self.groupType == GroupTemplate_N02_NiuNiu) {
        return CGSizeMake(SCREEN_WIDTH, 85);
    }else if (self.groupType == GroupTemplate_N04_RobNiuNiu || self.groupType == GroupTemplate_N05_ErBaGang){
        return CGSizeMake(SCREEN_WIDTH, 60);
    }
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.groupType == GroupTemplate_N04_RobNiuNiu || self.groupType == GroupTemplate_N05_ErBaGang) {
        if (section == self.dataSource.count - 1) {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, 100);
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = NSLocalizedString(@"点击重新获取", nil);
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"cccccc"]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.dataSource.count == 0;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"state_empty"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    [self loadTemplateList];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 5;
}

@end
