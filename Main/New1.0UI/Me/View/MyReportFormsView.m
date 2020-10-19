//
//  MyReportFormsView.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "MyReportFormsView.h"
#import "ReportCell.h"

@interface MyReportFormsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MyReportFormsView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    NSInteger width = (SCREEN_WIDTH-20)/2;
    layout.itemSize = CGSizeMake(width, width * 0.55);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:NSClassFromString(@"ReportCell") forCellWithReuseIdentifier:@"ReportCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    WEAK_OBJ(weakSelf, self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.dataArray = [[NSMutableArray alloc] init];    
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [self getData];
}

-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestUserReportInfoWithId:self.userId success:^(id object) {
        SVP_DISMISS;
        [self getDataBack:object[@"data"]];
        [weakSelf reloadData];
    } fail:^(id object) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


-(void)getDataBack:(NSDictionary *)dict{
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:NSLocalizedString(@"充值奖励", nil) forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"first"]));
    item.desc = NSLocalizedString(@"首充奖励赠送", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"two"]));
    item.desc = NSLocalizedString(@"二充奖励赠送", nil);
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:NSLocalizedString(@"邀请会员完成充值", nil) forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"friendFirst"]));
    item.desc = NSLocalizedString(@"首充奖励赠送", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"friendTwo"]));
    item.desc = NSLocalizedString(@"二充奖励赠送", nil);
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:NSLocalizedString(@"发包与抢包满额奖励", nil) forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Hairbag";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"send"]));
    item.desc = NSLocalizedString(@"发包奖励", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"snatch";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"rob"]));
    item.desc = NSLocalizedString(@"抢包奖励", nil);
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    [categoryDic setObject:NSLocalizedString(@"豹子顺子与直推奖励", nil) forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"yjfc";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"bzsz"]));
    item.desc = NSLocalizedString(@"豹子顺子奖励", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"esjj";
    item.title = STR_TO_AmountFloatSTR(NUMBER_TO_STR(dict[@"commission"]));
    item.desc = NSLocalizedString(@"直推佣金奖励", nil);
    [arr addObject:item];
}


-(void)reloadData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
        return CGSizeMake(self.frame.size.width, 38);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        reusableview.backgroundColor = BaseColor;
        
        UIView *view = [reusableview viewWithTag:95];
        if(view == nil){
            UIView *view = [[UIView alloc] init];
            view.tag = 95;
            view.backgroundColor = [UIColor whiteColor];
            [reusableview addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableview).offset(10);
                make.right.equalTo(reusableview).offset(-10);
                make.height.equalTo(reusableview);
                make.bottom.equalTo(reusableview);
            }];
        }
        
        
        UILabel *label = [reusableview viewWithTag:99];
        if(label == nil){
            label = [[UILabel alloc] init];
            label.textColor = HexColor(@"#48414f");
            label.font = [UIFont systemFontOfSize2:15];
            [reusableview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableview).offset(25);
                make.bottom.equalTo(reusableview);
                make.height.equalTo(@30);
            }];
            label.tag = 99;
        }
        
        UIImageView *iv = [reusableview viewWithTag:96];
        if(iv == nil){
            UIImageView *iv = [[UIImageView alloc] init];
            iv.tag = 96;
            iv.backgroundColor = MBTNColor;
            [reusableview addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.width.height.equalTo(@8);
                make.left.equalTo(reusableview).offset(10);
                make.height.equalTo(@0.5);
                make.right.equalTo(label.mas_right).offset(10);
                make.bottom.equalTo(reusableview).offset(-1);
            }];
        }
        
        UIView *lineView = [reusableview viewWithTag:100];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = TBSeparaColor;
            [reusableview addSubview:lineView];
            lineView.tag = 100;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(reusableview);
            }];
        }
        lineView = [reusableview viewWithTag:98];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = BaseColor;
            [reusableview addSubview:lineView];
            lineView.tag = 98;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@8);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(label.mas_top);
            }];
        }
        NSDictionary *dic = self.dataArray[indexPath.section];
        label.text = dic[@"categoryName"];
    }
    return reusableview;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    NSArray *list = dic[@"list"];
    return list.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *list = dic[@"list"];
    ReportFormsItem *item = list[indexPath.row];
    ReportCell * cell = [ReportCell cellWith:self.collectionView indexPath:indexPath];
    [cell richElementsInCellWithModel:item indexPath:indexPath];
    return cell;
}

@end
