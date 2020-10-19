//
//  DYTableView.m
//  ID贷
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "DYTableView.h"
#import "MJRefresh.h"
#import "DYButton.h"

@interface DYTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) DYButton *noDataBtn;

@end


@implementation DYTableView

@synthesize noDataText = _noDataText;
@synthesize noDataImage = _noDataImage;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}


- (void)setupView {
    self.isShowNoData = YES;
    
    [self setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
    [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
    [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
    [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
    [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
    [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];

    self.mj_header = refreshHeader;
    self.tableFooterView = [UIView new];
    self.dy_dataSource = @[].mutableCopy;

    self.dataSource = self;
    self.delegate = self;
    self.pageSize = 99999;
    self.pageIndex = 1;
    
    [self addSubview:self.noDataBtn];
    [self.noDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    [self.noDataBtn addTarget:self action:@selector(nodataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_noDataBtn setTitle:self.noDataText forState:UIControlStateNormal];
    [_noDataBtn setImage:[UIImage imageNamed:self.noDataImage] forState:UIControlStateNormal];
}

- (void)nodataBtnClick {
    [self.mj_header beginRefreshing];
    self.noDataBtn.hidden = YES;
}

- (void)manualUpdateNoDataView:(BOOL)isShow {
    
    self.noDataBtn.hidden = !isShow;
}

- (void)loadLocalData {
    if (self.loadLocalDataCallback) {
        kWeakly(self);
        self.loadLocalDataCallback(^(NSArray<id> * _Nonnull sources) {
            if (sources.count > 0) {
                [weakself.dy_dataSource removeAllObjects];
                [weakself.dy_dataSource addObjectsFromArray:sources];
                [weakself reloadData];
                [weakself updateNoDataView];
            }else {
                
                [self loadData];
            }
        });
    }
    
}


- (void)loadData {
    self.pageIndex = 1;
    
    if (self.loadDataCallback) {
        kWeakly(self);
        self.loadDataCallback(self.pageIndex, ^(NSArray * _Nonnull sources) {
            [weakself handleDragDownData:sources];
        });
    }

}

- (void)loadMoreData {
    self.pageIndex += 1;
    
    if (self.loadDataCallback) {
        kWeakly(self);
        self.loadDataCallback(self.pageIndex, ^(NSArray * _Nonnull sources) {
            [weakself handleUpDragData:sources];
        });
    }
    
}


//- (void)setDy_dataSource:(NSMutableArray<id> *)dy_dataSource {
//    _dy_dataSource = dy_dataSource;
//
//    [self updateNoDataView];
//}


/**
 下拉刷新
 */
- (void)handleDragDownData:(NSArray *)sources {
    if (sources.count == 0) {
        self.dy_dataSource = [NSMutableArray arrayWithArray:sources];
        [self.mj_header endRefreshing];
        [self reloadData];
        [self updateNoDataView];
        return;
    }
    
    [self.mj_header endRefreshing];
    [self.dy_dataSource removeAllObjects];
    [self.dy_dataSource addObjectsFromArray:sources];
    [self reloadData];
    
    if (sources.count > 0 && sources.count == self.pageSize) {
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    
    if (sources.count < self.pageSize && self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
    
    [self updateNoDataView];
    //如果代理是交给当前的view进行处理 就显示
//    if (self.dataSource == self) {
//        if (sources.count == 0 && self.isShowNoData) {
//            self.noDataBtn.hidden = NO;
//        } else {
//            self.noDataBtn.hidden = YES;
//        }
//    }
//
}

- (void)handleUpDragData:(NSArray *)sources {
    [self.mj_footer endRefreshing];
    
    NSMutableArray *indexes = [[NSMutableArray alloc] initWithCapacity:sources.count];
    for (id objc in sources) {
        [indexes addObject:[NSIndexPath indexPathForRow:self.dy_dataSource.count inSection:0]];
        [self.dy_dataSource addObject:objc];
        
    }
    
    [self insertRowsAtIndexPaths:indexes withRowAnimation:0];
    
    if (sources.count < self.pageSize) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)begainRefreshData {
    if (self.noDataBtn) {
        self.noDataBtn.hidden = true;
    }
    
    [self.mj_header beginRefreshing];
}

- (void)updateNoDataView {
    
    if (self.isShowNoData) {
        self.noDataBtn.hidden = self.dy_dataSource.count > 0 ? YES : NO;
    }
}

#pragma mark - Private

//- (void)setDy_dataSource:(NSMutableArray<DYTableViewModel *> *)dy_dataSource {
//
//    _dy_dataSource = dy_dataSource;
//    self.noDataBtn.hidden = self.dy_dataSource.count > 0 ? YES : NO;
//}

- (void)setNoDataText:(NSString *)noDataText {
    _noDataText = noDataText;
    
    [_noDataBtn setTitle:self.noDataText forState:UIControlStateNormal];
}


- (void)setNoDataImage:(NSString *)noDataImage {
    _noDataImage = noDataImage;
    [_noDataBtn setImage:[UIImage imageNamed:self.noDataImage] forState:UIControlStateNormal];

}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self updateNoDataView];
    return self.dy_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dy_dataSource[indexPath.row];
    kWeakly(self);
    cell.OtherClickFlag = ^(id model, NSInteger flag) {
        if (weakself.didSelectedCellCallback) {
            weakself.didSelectedCellCallback(model, @(flag));
        }
    };
    if (indexPath.row == self.dy_dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10000);
    } else {
        cell.separatorInset = self.dy_separateInsets;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedCellCallback) {
        self.didSelectedCellCallback(indexPath,nil);
    }
    if (self.didSelectedCellModelCallback) {
        self.didSelectedCellModelCallback(self.dy_dataSource[indexPath.row]);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowHeight > 0) {
        return self.rowHeight;
    }
    
    CGFloat height = [self.heightCache[@(indexPath.row)] floatValue];
    if (height == 0) {
        id model = self.dy_dataSource[indexPath.row];
        //处理 model没有继承自DYTableViewModel
        if ([model isKindOfClass:DYTableViewModel.class]) {
            height = [self.dy_dataSource[indexPath.row] calculateCellheight];
            self.heightCache[@(indexPath.row)] = @(height);
        } else {
            //尝试去调用 这个模型的方法
            if ([model respondsToSelector:@selector(calculateCellheight)]) {
                height = [[model performSelector:@selector(calculateCellheight)] floatValue];
            }
        }
        
    }
    return height;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canDeleteCell;
}
    
    
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         
         if (self.deleteCellCallback) {
             self.deleteCellCallback();
         }
    }
    
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NSLocalizedString(@"删除", nil);
}


#pragma mark - Lazy

- (DYButton *)noDataBtn {
    
    if (!_noDataBtn) {
        _noDataBtn = [DYButton new];
        _noDataBtn.direction = 1;
        _noDataBtn.margin = 14;
        _noDataBtn.hidden = YES;
        _noDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_noDataBtn setTitleColor:[UIColor hex:@"#cccccc"] forState:UIControlStateNormal];
    }
    
    return _noDataBtn;
}

- (NSString *)noDataText {
    if (_noDataText.length == 0) {
        _noDataText = NSLocalizedString(@"暂无记录", nil);
    }
    return _noDataText;
}

- (NSString *)noDataImage {
    if (_noDataImage.length == 0) {
        _noDataImage = @"noDataImage";
    }
    return _noDataImage;
}

@end



@implementation DYTableViewCell


- (void)setModel:(id)model {
    
    _model = model;
    if ([model isKindOfClass:NSDictionary.class]) {
        
        NSString *avatar = model[@"avatar"];
        if ([avatar hasPrefix:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:kDefaultAvatarImage];
        } else {
            self.imageView.image = [UIImage imageNamed:avatar];
        }
        self.textLabel.text = model[@"text"];
    }
   
}

@end

@implementation DYTableViewModel



- (CGFloat)calculateCellheight {
    
    NSAssert(1, @"You must rewrite this method in subclass.");
    return 0;
}
@end
