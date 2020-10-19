//
//  FYJSSLGameRecordDetailHudView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameRecordDetailHudView.h"
#import "FYJSSLGameRecordDetailHudCell.h"
#import "FYJSSLGameRecordDetailModel.h"
#import "FYJSSLGameRecordHudModel.h"
#import "FYJSSLGameResultModel.h"
#import "FYJSSLGameRecordModel.h"

@interface FYJSSLGameRecordDetailHudView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UILabel *titleLabel;
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<FYJSSLGameRecordHudModel *> *tableDataSource;

@end

@implementation FYJSSLGameRecordDetailHudView

+ (void)showRecordDetailHudView:(FYJSSLGameRecordModel *)recordModel params:(NSDictionary *)params
{
    [[self class] loadRequestRecordData:recordModel params:params then:^(BOOL success, NSMutableArray<FYJSSLGameRecordHudModel *> *itemModels) {
        dispatch_main_async_safe(^{
            FYJSSLGameRecordDetailHudView *hubView = [[FYJSSLGameRecordDetailHudView alloc] initWithFrame:UIScreen.mainScreen.bounds itemModels:itemModels];
            [[UIApplication sharedApplication].keyWindow addSubview:hubView];
            [hubView.tableView reloadData];
        });
    }];
}

+ (void)loadRequestRecordData:(FYJSSLGameRecordModel *)recordModel  params:(NSDictionary *)params then:(void (^)(BOOL success, NSMutableArray<FYJSSLGameRecordHudModel *> *itemModels))then
{
    PROGRESS_HUD_SHOW
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [parameters setObj:recordModel.gameNumber forKey:@"gameNumber"];
    [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslGameRecordsDetail parameters:parameters success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"投注记录详情 => %@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(response);
            NSMutableArray<FYJSSLGameRecordHudModel *> *allItemModels = [FYJSSLGameRecordHudModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
            !then ?: then(YES,allItemModels);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame itemModels:(NSMutableArray<FYJSSLGameRecordHudModel *> *)itemModels
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableDataSource = [NSMutableArray arrayWithArray:itemModels];
        //
        CGFloat table_number = 2.5;
        CGFloat table_count = self.tableDataSource.count;
        CGFloat height_title = CFC_AUTOSIZING_WIDTH(45);
        CGFloat height_cancle = CFC_AUTOSIZING_WIDTH(50);
        CGFloat height_table_cell = [FYJSSLGameRecordDetailHudCell headerViewHeight];
        CGFloat height_table_content = table_count > table_number ? height_table_cell * table_number : height_table_cell * table_count;
        CGFloat container_width = SCREEN_WIDTH * 0.85f;
        CGFloat container_height = height_title + height_cancle + height_table_content;

        [self addSubview:self.backgroundView];
        self.backgroundView.frame = self.bounds;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.cancleButton];
        [self.containerView addSubview:self.tableView];
        
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

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.equalTo(self.cancleButton.mas_top);
        }];
        
        UIView *splitLineTop = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:HexColor(@"#D3D3D3")];
            [self.titleLabel addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.titleLabel);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        splitLineTop.mas_key = @"splitLineTop";
        
        UIView *splitLineBottom = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:HexColor(@"#D3D3D3")];
            [self.cancleButton addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.cancleButton);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        splitLineBottom.mas_key = @"splitLineBottom";
        
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
    FYJSSLGameRecordDetailHudCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYJSSLGameRecordDetailHudCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYJSSLGameRecordDetailHudCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYJSSLGameRecordDetailHudCell reuseIdentifier]];
    }
    cell.indexPath = indexPath;
    cell.model = self.tableDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYJSSLGameRecordDetailHudCell headerViewHeight];
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
        [_tableView registerClass:[FYJSSLGameRecordDetailHudCell class] forCellReuseIdentifier:[FYJSSLGameRecordDetailHudCell reuseIdentifier]];
    }
    return _tableView;
}

@end

