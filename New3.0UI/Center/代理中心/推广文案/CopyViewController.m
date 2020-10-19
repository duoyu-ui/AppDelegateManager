//
//  CopyViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "CopyViewController.h"
#import "CopyCell.h"

@interface CopyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CopyViewController

#pragma mark - Getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [UITableView normalTable];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)createHeaderView {
    float rate = 223 / 718.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * rate)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"copyBg"];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return view;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTabView];
    [self requestData];
}

- (void)setupTabView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakSelf
    [SVProgressHUD show];
    self.tableView.mj_header = [CFCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark - Handle Data

- (void)requestData {
    WEAK_OBJ(weakObj, self);
    [NET_REQUEST_MANAGER requestCopyListWithSuccess:^(id object) {
        [weakObj getDataBack:object];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)getDataBack:(NSDictionary *)dict {
    [SVProgressHUD dismiss];
    
    self.tableView.tableHeaderView = [self createHeaderView];
    self.dataArray = dict[@"data"];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"kCopyCellIdentifier";
    CopyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[CopyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell initView];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell setIndex:indexPath.row + 1];
    
    NSString *s = dict[@"content"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:s];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [s length])];
    [cell.tLabel setAttributedText:attributedString1];
    
    //cell.tLabel.text = dict[@"content"];
    return cell;
}

@end
