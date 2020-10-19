//
//  FYBaiRenNNRecordDetailHudView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNRecordDetailHudView.h"
#import "FYBaiRenNNRecordDetailHudCell.h"
#import "FYBaiRenNNRecordDetailModel.h"
#import "FYBaiRenNNRecordModel.h"
#import "FYPockerView.h"

@interface FYBaiRenNNRecordDetailHudView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topResAreaView;
@property (nonatomic, strong) UILabel *topIssueLabel;
@property (nonatomic, strong) NSMutableArray<FYPockerView *> *resultPockerViews;
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<FYBaiRenNNRecordDetailInfoModel *> *tableDataSource;

@end

@implementation FYBaiRenNNRecordDetailHudView

+ (void)showRecordDetailHudView:(FYBaiRenNNRecordModel *)recordModel params:(NSDictionary *)params
{
    [[self class] loadRequestRecordData:recordModel params:params then:^(BOOL success, FYBaiRenNNRecordDetailModel *model) {
        dispatch_main_async_safe(^{
            FYBaiRenNNRecordDetailHudView *hubView = [[FYBaiRenNNRecordDetailHudView alloc] initWithFrame:UIScreen.mainScreen.bounds recordDetailModel:model];
            [[UIApplication sharedApplication].keyWindow addSubview:hubView];
            [hubView.tableView reloadData];
        });
    }];
}

+ (void)loadRequestRecordData:(FYBaiRenNNRecordModel *)recordModel  params:(NSDictionary *)params then:(void (^)(BOOL success, FYBaiRenNNRecordDetailModel *model))then
{
    PROGRESS_HUD_SHOW
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [parameters setObj:recordModel.period forKey:@"gameNumber"];
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuGameRecordsDetail parameters:parameters success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"投注记录详情 => %@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(response);
            FYBaiRenNNRecordDetailModel *model = [FYBaiRenNNRecordDetailModel mj_objectWithKeyValues:dicts];
            !then ?: then(YES,model);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame recordDetailModel:(FYBaiRenNNRecordDetailModel *)detailModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableDataSource = [NSMutableArray arrayWithArray:detailModel.details];
        //
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat table_number = 10;
        CGFloat table_count = self.tableDataSource.count;
        CGFloat height_title = CFC_AUTOSIZING_WIDTH(45);
        CGFloat height_cancle = CFC_AUTOSIZING_WIDTH(50);
        CGFloat height_topresarea = CFC_AUTOSIZING_WIDTH(32.0);
        CGFloat height_table_header = CFC_AUTOSIZING_WIDTH(28.0);
        CGFloat height_table_footer = CFC_AUTOSIZING_WIDTH(35.0);
        CGFloat height_table_cell = [FYBaiRenNNRecordDetailHudCell headerViewHeight];
        CGFloat height_table_content = table_count > table_number ? height_table_cell * table_number : height_table_cell * table_count;
        CGFloat container_width = SCREEN_WIDTH * 0.85f;
        CGFloat container_height = height_title + height_cancle + height_topresarea + height_table_header + height_table_content + height_table_footer;
        NSArray<NSNumber *> *percents = [FYBaiRenNNRecordDetailHudCell getColumnPercents];
    
        [self addSubview:self.backgroundView];
        self.backgroundView.frame = self.bounds;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.cancleButton];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.topResAreaView];
        [self.containerView addSubview:self.tableView];
        [self.topResAreaView addSubview:self.topIssueLabel];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(container_width);
            make.height.mas_equalTo(container_height);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.containerView);
            make.height.mas_equalTo(height_title);
        }];
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containerView);
            make.height.mas_equalTo(height_cancle);
        }];
        
        // 期号与开奖结果
        {
            [self.topResAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.containerView);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.height.mas_equalTo(height_topresarea);
            }];
            
            [self.topIssueLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@期开奖结果", nil), detailModel.period]];
            [self.topIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.topResAreaView).offset(margin);
                make.centerY.equalTo(self.topResAreaView);
            }];
            
            {
                NSInteger count = 5;
                CGFloat pocker_gap = 2.0f;
                CGFloat pocker_height = height_topresarea * 0.65f;
                CGFloat pocker_width = (SCREEN_MIN_LENGTH * 0.4f-pocker_gap*(count+1)) / count;
                FYPockerView *lastPockerView = nil;
                _resultPockerViews = [NSMutableArray array];
                for (NSInteger idx = 0; idx < count; idx ++) {
                    FYPockerView *pockerView = [[FYPockerView alloc] init];
                    [self.topResAreaView addSubview:pockerView];
                    [pockerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(pocker_width);
                        make.height.mas_equalTo(pocker_height);
                        make.centerY.equalTo(self.topResAreaView);
                        if (!lastPockerView) {
                            make.right.mas_equalTo(self.topResAreaView).offset(-margin);
                        } else {
                            make.right.mas_equalTo(lastPockerView.mas_left).offset(-pocker_gap);
                        }
                    }];
                    lastPockerView = pockerView;
                    [self.resultPockerViews insertObject:pockerView atIndex:0];
                }
            }
        
            NSInteger index = 0;
            NSArray<NSString *> *winSplitArr = [detailModel.winStr componentsSeparatedByString:@","];
            for (NSString *cardsInfo in winSplitArr) {
                NSArray<NSString *> *cardsArr = [cardsInfo componentsSeparatedByString:@"|"];
                FYBestWinsLossesPokers *pocker = [FYBestWinsLossesPokers new];
                [pocker setType:cardsArr.lastObject];
                [pocker setText:cardsArr.firstObject];
                if (index < self.resultPockerViews.count) {
                    FYPockerView *pockerView = [self.resultPockerViews objectAtIndex:index];
                    [pockerView setImgViewImgWithPokers:pocker flopType:1];
                    index ++;
                }
            }
        }
        
        // 表格头
        UILabel *lastTableHeaderLabel = nil;
        {
            NSArray<NSString *> *titles = @[NSLocalizedString(@"压", nil),
                                            NSLocalizedString(@"投注", nil),
                                            NSLocalizedString(@"赔率", nil),
                                            NSLocalizedString(@"中奖", nil)];
            for (NSInteger index = 0; index < titles.count; index ++) {
                lastTableHeaderLabel = ({
                    UILabel *label = [UILabel new];
                    [self.containerView addSubview:label];
                    [label setText:titles[index]];
                    [label setFont:FONT_PINGFANG_REGULAR(14)];
                    [label setTextColor:[UIColor whiteColor]];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setBackgroundColor:HexColor(@"#6B6B6B")];
                    //
                    CGFloat percent = [percents objectAtIndex:index].floatValue;
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.containerView.mas_right).multipliedBy(percent);
                        make.height.equalTo(@(height_table_header));
                        if (!lastTableHeaderLabel) {
                            make.top.equalTo(self.topResAreaView.mas_bottom);
                            make.left.equalTo(self.containerView.mas_left);
                        } else {
                            make.top.equalTo(lastTableHeaderLabel.mas_top);
                            make.left.equalTo(lastTableHeaderLabel.mas_right);
                        }
                    }];
                    
                    label;
                });
                lastTableHeaderLabel.mas_key = [NSString stringWithFormat:@"lastTableHeaderLabel%ld", index];
                //
                if (index < titles.count -1) {
                    UILabel *splitLineTableHeader = ({
                        UILabel *view = [[UILabel alloc] init];
                        [view setBackgroundColor:HexColor(@"#D3D3D3")];
                        [self.containerView addSubview:view];
                        
                        CGFloat percent = [percents objectAtIndex:index].floatValue;
                        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(self.containerView.mas_right).multipliedBy(percent);
                            make.centerY.equalTo(lastTableHeaderLabel.mas_centerY);
                            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                            make.height.mas_equalTo(height_table_header);
                        }];
                        
                        view;
                    });
                    splitLineTableHeader.mas_key = @"splitLineTableHeader";
                }
            }
        }
        
        // 表格尾
        UILabel *lastTableFooterLabel = nil;
        {
            NSArray<NSString *> *titles = @[NSLocalizedString(@"本期投注汇总", nil),
                                            NSLocalizedString(@"-", nil),
                                            NSLocalizedString(@"-", nil),
                                            NSLocalizedString(@"-", nil)];
            for (NSInteger index = 0; index < titles.count; index ++) {
                lastTableFooterLabel = ({
                    UILabel *label = [UILabel new];
                    [self.containerView addSubview:label];
                    [label setText:titles[index]];
                    [label setFont:FONT_PINGFANG_REGULAR(14)];
                    [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setBackgroundColor:HexColor(@"#C5C5C5")];
                    //
                    CGFloat percent = [percents objectAtIndex:index].floatValue;
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.containerView.mas_right).multipliedBy(percent);
                        make.height.equalTo(@(height_table_footer));
                        if (!lastTableFooterLabel) {
                            make.bottom.equalTo(self.cancleButton.mas_top);
                            make.left.equalTo(self.containerView.mas_left);
                        } else {
                            make.top.equalTo(lastTableFooterLabel.mas_top);
                            make.left.equalTo(lastTableFooterLabel.mas_right);
                        }
                    }];
                    
                    label;
                });
                lastTableFooterLabel.mas_key = [NSString stringWithFormat:@"lastTableFooterLabel%ld", index];
                //
                if (1 == index) {
                    [lastTableFooterLabel setText:[NSString stringWithFormat:@"%@", detailModel.bettMoney]];
                } else if (3 == index) {
                    if (detailModel.winMoney.floatValue == 0) {
                        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
                        NSString *content = [NSString stringWithFormat:@"%.2f", fabs(detailModel.winMoney.floatValue)];
                        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
                        [lastTableFooterLabel setAttributedText:attrString];
                    } else if (detailModel.winMoney.floatValue < 0) {
                        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
                        NSString *content = [NSString stringWithFormat:@"- %.2f", fabs(detailModel.winMoney.floatValue)];
                        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
                        [lastTableFooterLabel setAttributedText:attrString];
                    } else {
                        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
                        NSString *content = [NSString stringWithFormat:@"+ %.2f", fabs(detailModel.winMoney.floatValue)];
                        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
                        [lastTableFooterLabel setAttributedText:attrString];
                    }
                }
                //
                if (index < titles.count -1) {
                    UILabel *splitLineTableFooter = ({
                        UILabel *view = [[UILabel alloc] init];
                        [view setBackgroundColor:HexColor(@"#D3D3D3")];
                        [self.containerView addSubview:view];
                        
                        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(lastTableFooterLabel.mas_centerY);
                            make.centerX.equalTo(lastTableFooterLabel.mas_right);
                            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                            make.height.mas_equalTo(height_table_footer);
                        }];
                        
                        view;
                    });
                    splitLineTableFooter.mas_key = @"splitLineTableFooter";
                }
            }
        }
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(lastTableHeaderLabel.mas_bottom);
            make.bottom.equalTo(lastTableFooterLabel.mas_top);
        }];
        
    }
    return self;
}


//取消
- (void)dismissHudView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    FYBaiRenNNRecordDetailHudCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBaiRenNNRecordDetailHudCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBaiRenNNRecordDetailHudCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBaiRenNNRecordDetailHudCell reuseIdentifier]];
    }
    cell.model = self.tableDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYBaiRenNNRecordDetailHudCell headerViewHeight];
}


#pragma mark - 懒加载

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexColor(@"#000000");
        _backgroundView.alpha = 0.55;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHudView)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    return _backgroundView;
}
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HexColor(@"#FAFCFE");
        _containerView.layer.cornerRadius = CFC_AUTOSIZING_MARGIN(MARGIN);
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font =  FONT_PINGFANG_REGULAR(18);
        _titleLabel.text = NSLocalizedString(@"投注详情", nil);
        _titleLabel.textColor = HexColor(@"#1A1A1A");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc]init];
        [_cancleButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
        [_cancleButton setTitleColor:HexColor(@"#3875F6") forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = FONT_PINGFANG_REGULAR(18);
        _cancleButton.backgroundColor = HexColor(@"#FAFCFE");
        [_cancleButton addTarget:self action:@selector(dismissHudView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UIView *)topResAreaView{
    if (!_topResAreaView) {
        _topResAreaView = [[UIView alloc] init];
        [_topResAreaView addBorderWithColor:HexColor(@"#D3D3D3") cornerRadius:0.0f andWidth:SEPARATOR_LINE_HEIGHT];
    }
    return _topResAreaView;
}
- (UILabel *)topIssueLabel{
    if (!_topIssueLabel) {
        _topIssueLabel = [[UILabel alloc]init];
        _topIssueLabel.text = STR_APP_TEXT_PLACEHOLDER;
        _topIssueLabel.font =  FONT_PINGFANG_REGULAR(14);
        _topIssueLabel.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        _topIssueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _topIssueLabel;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = FLOAT_MIN;
        _tableView.sectionFooterHeight = FLOAT_MIN;
        _tableView.fd_debugLogEnabled = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYBaiRenNNRecordDetailHudCell class] forCellReuseIdentifier:[FYBaiRenNNRecordDetailHudCell reuseIdentifier]];
    }
    return _tableView;
}

@end

