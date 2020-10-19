//
//  FYSystemMessageController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSystemNewMessageController.h"
#import "FYSystemMessageModel.h"
#import "FYSystemNewMessageCell.h"
static NSString *const FYSystemNewMessageCellID = @"FYSystemNewMessageCellID";
@interface FYSystemNewMessageController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <FYSystemMessageRecords*>*datasArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldDisplay; // 是否显示EmptyDataSet空白页（默认NO）
@end

@implementation FYSystemNewMessageController

- (instancetype)initWithSessionId:(NSString *)sessionId
{
    self = [super init];
    if (self) {
        _sessionId = sessionId;
        _isEmptyDataSetShouldDisplay = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"系统消息", nil);
    [self initSubView];
    [self bindRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    WEAKSELF(weakSelf)
    
    // 将当前系统消息 session 未读消息数清空
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FYContacts *session = [IMSessionModule.sharedInstance getSessionWithSessionId:weakSelf.sessionId];
        if (session) {
            session.unReadMsgCount = 0;
            [IMSessionModule.sharedInstance updateSeesion:session];
            [IMMessageSysModule.sharedInstance deleteAllSystemMessageEntities];
            [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
        }
    });
}

- (void)initSubView
{
    self.page = 0;
    self.view.backgroundColor = HexColor(@"#EDEDED");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindRefreshing
{
    CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPacketConfig)];
    [self.tableView setMj_header:refreshHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)stopRefreshing
{
    if (self.tableView.mj_header && [self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)loadPacketConfig
{
    self.page = 1;
    [self.datasArr removeAllObjects];
    [self loadData];
}

- (void)loadData
{
    WEAKSELF(weakSelf)
    [NET_REQUEST_MANAGER allSystemMessagesWithrTime:@"" page:self.page success:^(id response) {
        FYSystemMessageModel *model = [FYSystemMessageModel mj_objectWithKeyValues:response];
        NSArray <FYSystemMessageRecords*> *list = [FYSystemMessageRecords mj_objectArrayWithKeyValuesArray:model.data.records];
        if (list.count < 20) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            //
            CFCRefreshFooter *refreshFooter = [CFCRefreshFooter footerWithRefreshingBlock:^{
                weakSelf.page += 1;
                [weakSelf loadData];
            }];
            [weakSelf.tableView setMj_footer:refreshFooter];
        }
        
        [list enumerateObjectsUsingBlock:^(FYSystemMessageRecords * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    APPINFORMATION.lastSysMsgNoticeReadTime = obj.releaseTime;
                    [APPINFORMATION saveAppModel];
                });
            }
            [weakSelf.datasArr addObj:obj];
        }];
        
        if (weakSelf.datasArr.count <= 0) {
            [weakSelf.tableView setMj_footer:nil];
            [weakSelf setIsEmptyDataSetShouldDisplay:YES];
        }
        [weakSelf.tableView reloadData];
        [weakSelf stopRefreshing];
    } fail:^(id error) {
        [[FunctionManager sharedInstance]handleFailResponse:error];
        [weakSelf setIsEmptyDataSetShouldDisplay:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf stopRefreshing];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = HexColor(@"#EDEDED");
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYSystemNewMessageCell class] forCellReuseIdentifier:FYSystemNewMessageCellID];
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
/**cell样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FYSystemNewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:FYSystemNewMessageCellID];
    if (self.datasArr.count > indexPath.row) {
        cell.list = self.datasArr[indexPath.row];
    }
    return cell;
}

/**cell个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

/**cell高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYSystemMessageRecords *list = self.datasArr[indexPath.row];
    CGSize textSize = [list.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:SCREEN_WIDTH * 0.7];
    return textSize.height + 90;
}

/**cell点击*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = STR_SCROLL_EMPTY_DATASET_TITLE;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSString *text = STR_SCROLL_EMPTY_DATASET_TIPINFO;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13.0f)],
                                  NSForegroundColorAttributeName:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00],
                                  NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    CGSize imageSize = CGSizeMake(SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE, SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE);
    return [[UIImage imageNamed:ICON_SCROLLVIEW_EMPTY_DATASET_MESSAGE] imageByScalingProportionallyToSize:imageSize];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return - CFC_AUTOSIZING_WIDTH(90.0f);
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.isEmptyDataSetShouldDisplay && self.datasArr.count == 0);
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    [self loadData];
}

- (NSMutableArray <FYSystemMessageRecords*>*)datasArr
{
    if (!_datasArr) {
        _datasArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasArr;
}


@end

