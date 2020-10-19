//
//  ReportFormsView.m
//  Project
//
//  Created by fy on 2019/1/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportFormsView.h"
#import "ReportCell.h"
#import "ReportHeaderView.h"
#import "SelectTimeView.h"
#import "CDAlertViewController.h"

@implementation ReportFormsItem
@end

@interface ReportFormsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ReportHeaderView *headerView;

@end

@implementation ReportFormsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {
    // Do any additional setup after loading the view.
    self.beginTime = dateString_date([NSDate date], CDDateDay);
    self.endTime = dateString_date([NSDate date], CDDateDay);
    self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
    self.tempEndTime = dateString_date([NSDate date], CDDateDay);
    
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
    SVP_SHOW;
    if([AppModel shareInstance].userInfo.agentFlag == NO)
        return;
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [self getData];
}
-(void)getData{
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestReportFormsWithUserId:self.userId beginTime:self.tempBeginTime endTime:self.tempEndTime success:^(id object) {
        SVP_DISMISS;
        weakSelf.beginTime = weakSelf.tempBeginTime;
        weakSelf.endTime = weakSelf.tempEndTime;
        [self requestDataBack:object[@"data"]];
        [weakSelf reloadData];
    } fail:^(id object) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)requestDataBack:(NSDictionary *)dict{
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:NSLocalizedString(@"玩家活跃度", nil) forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.icon = @"Newregistration";
    item.title = NUMBER_TO_STR(dict[@"registerUserCount"]);
    item.desc = NSLocalizedString(@"新注册人数", nil);
    [arr addObject:item];
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Totalregistration";
    item.title = NUMBER_TO_STR(dict[@"registerUserTotal"]);
    item.desc = NSLocalizedString(@"总注册人数", nil);
    [arr addObject:item];
    [self.collectionView reloadData];
    
    NSString *s1 = NUMBER_TO_STR(dict[@"firstRechargeMoneySum"]);
    NSString *s2 =  NUMBER_TO_STR(dict[@"firstRechargeCount"]);
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Firstrecharge";
    item.title = [NSString stringWithFormat:@"￥%@/%@",s1,s2];
    item.desc = NSLocalizedString(@"首充金额/笔数", nil);
    [arr addObject:item];
    
    s1 = NUMBER_TO_STR(dict[@"secondRechargeMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"secondRechargeCount"]);
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Recharge";
    item.title = [NSString stringWithFormat:@"￥%@/%@",s1,s2];
    item.desc = NSLocalizedString(@"二充金额/笔数", nil);
    [arr addObject:item];
    
    if([self isSelf]){
        categoryDic = [[NSMutableDictionary alloc] init];
        [self.dataArray addObject:categoryDic];
        
        [categoryDic setObject:NSLocalizedString(@"充值与提现", nil) forKey:@"categoryName"];
        arr = [[NSMutableArray alloc] init];
        [categoryDic setObject:arr forKey:@"list"];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"fdefdsv";
        item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"rechargeMoneySum"])];
        item.desc = NSLocalizedString(@"充值总额", nil);
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Totalrecharge";
        item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"cashDrawsMoneySum"])];
        item.desc = NSLocalizedString(@"提现总额", nil);
        [arr addObject:item];
        [self.collectionView reloadData];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Startingamount";
        item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"beginMoney"])];
        item.desc = NSLocalizedString(@"昨日盈亏", nil);
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.icon = @"Asofbalance";
        item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"endMoney"])];
        item.desc = NSLocalizedString(@"当天盈亏", nil);
        [arr addObject:item];
        
//        item = [[ReportFormsItem alloc] init];
//        item.icon = @"Profitandloss";
//        item.title = NUMBER_TO_STR(dict[@"profit"]);
//        item.desc = NSLocalizedString(@"盈亏", nil);
//        [arr addObject:item];
//
//        item = [[ReportFormsItem alloc] init];
//        item.icon = @"fc";
//        item.title = NUMBER_TO_STR(dict[@"profitCommission"]);
//        item.desc = NSLocalizedString(@"我的分成", nil);
//        [arr addObject:item];
    }
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:NSLocalizedString(@"发包与抢包", nil) forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    s1 = NUMBER_TO_STR(dict[@"redbonusMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"redbonusCount"]);
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Amountofthepackage";
    item.title = [NSString stringWithFormat:@"￥%@/%@",s1,s2];
    item.desc = NSLocalizedString(@"发包金额/个数", nil);
    [arr addObject:item];
    
    s1 = NUMBER_TO_STR(dict[@"grabMoneySum"]);
    s2 =  NUMBER_TO_STR(dict[@"grabCount"]);
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"qb";
    item.title = [NSString stringWithFormat:@"￥%@/%@",s1,s2];
    item.desc = NSLocalizedString(@"抢包金额/个数", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"Hairbag";
    item.title = NUMBER_TO_STR(dict[@"redbonusUserCount"]);
    item.desc = NSLocalizedString(@"发包人数", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"snatch";
    item.title = NUMBER_TO_STR(dict[@"grabUserCount"]);
    item.desc = NSLocalizedString(@"抢包人数", nil);
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:NSLocalizedString(@"奖金与佣金", nil) forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"scjj";
    item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"firstRechargePrize"])];
    item.desc = NSLocalizedString(@"首充用户奖金", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"esjj";
    item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"secondRechargePrize"])];
    item.desc = NSLocalizedString(@"二充用户奖金", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"yjfc";
    item.title = [NSString stringWithFormat:@"￥%@",NUMBER_TO_STR(dict[@"sendCommission"])];
    item.desc = NSLocalizedString(@"流水佣金分成", nil);
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.icon = @"yqhyyj";
    item.title = @"";
    item.desc = NSLocalizedString(@"敬请期待", nil);
    [arr addObject:item];
}

-(void)reloadData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return CGSizeMake(self.frame.size.width, 38 +8 + 75);
    else
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
        ReportHeaderView *pView = [reusableview viewWithTag:97];
        if(indexPath.section == 0){
            if(pView == nil){
                pView = [ReportHeaderView headView];
                self.headerView = pView;
                WEAK_OBJ(weakSelf, self);
                pView.beginChange = ^(id object) {
                    [weakSelf datePickerByType:0];
                };
                pView.endChange = ^(id object) {
                    [weakSelf datePickerByType:1];
                };
                pView.tag = 97;
                [reusableview addSubview:pView];
//                NSInteger width = SCREEN_WIDTH/2;
                [pView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(reusableview);
                    make.bottom.equalTo(reusableview).offset(-38);
                }];
                
            }
            
            pView.beginTime = self.beginTime;
            pView.endTime = self.endTime;
        }else{
            [pView removeFromSuperview];
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

-(void)showTimeSelectView{
    SelectTimeView *timeView = [SelectTimeView sharedInstance];
    WEAK_OBJ(weakSelf, self);
    timeView.selectBlock = ^(id object) {
        TimeRange range = (TimeRange)[object integerValue];
        [weakSelf selectTime:range];
    };
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)selectTime:(TimeRange)range{
    if(range == TimeRange_today){
        self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"今天", nil) forState:UIControlStateNormal];
    }else if(range == TimeRange_yesterday){
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"昨天", nil) forState:UIControlStateNormal];
    }else if(range == TimeRange_thisWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"本周", nil) forState:UIControlStateNormal];
    }else if(range == TimeRange_lastWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1 + 7) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow: ((7 - weekDay - 7) * 24 * 3600)], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"上周", nil) forState:UIControlStateNormal];
    }else if(range == TimeRange_thisMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStrb], CDDateDay);
        
        //        month += 1;
        //        if(month > 12){
        //            month = 1;
        //            year += 1;
        //        }
        //        NSString *timeStre = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        //        NSDate *dd = [[formatter dateFromString:timeStre] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"本月", nil) forState:UIControlStateNormal];
    }else if(range == TimeRange_lastMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        NSDate *dd = [[formatter dateFromString:timeStrb] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date(dd, CDDateDay);
        
        month -= 1;
        if(month < 1){
            month = 12;
            year -= 1;
        }
        NSString *timeStre = [NSString stringWithFormat:@"%ld-%2ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStre], CDDateDay);
        [self.rightBtn setTitle:NSLocalizedString(@"上月", nil) forState:UIControlStateNormal];
    }
    SVP_SHOW;
    [self getData];
}

- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}

- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        if([self.beginTime isEqualToString:date])
            return;
        self.beginTime = date;
        self.tempBeginTime = self.beginTime;
        self.headerView.beginTime = self.beginTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }else{
        if([self.endTime isEqualToString:date])
            return;
        self.endTime = date;
        self.tempEndTime = self.endTime;
        self.headerView.endTime = self.endTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    if([self.beginTime compare:self.endTime] != NSOrderedDescending){
        SVP_SHOW;
        [self getData];
    }
}

-(BOOL)isSelf{
    if(self.userId == nil)
        return NO;
    if([self.userId integerValue] == [[AppModel shareInstance].userInfo.userId integerValue])
        return YES;
    return NO;
}
@end
