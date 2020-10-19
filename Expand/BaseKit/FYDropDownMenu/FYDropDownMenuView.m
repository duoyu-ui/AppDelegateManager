
#import "FYDropDownMenuView.h"
#import "FYDropDownMenuTriangleView.h"
#import "TPKeyboardAvoidingTableView.h"

@interface FYDropDownMenuView () <UITableViewDataSource, UITableViewDelegate>

// 视图是否在显示
@property (nonatomic, assign) BOOL isShow;

// cell是否是正确格式的cell
@property (nonatomic, assign) BOOL isCellCorrect;

// 真实的三角形的Y(这个属性是用于状态栏的改变)
@property (nonatomic, assign) CGFloat realTriangleY;

// 父类容器
@property (nonatomic, strong) UIView *menuSuperView;

// 菜单 tableView 内容
@property (nonatomic, weak) TPKeyboardAvoidingTableView *tableView;

// tableView 的 frame
@property (nonatomic, assign) CGRect menuViewFrame;

// 菜单 view 的容器
@property (nonatomic, strong) UIView *menuContentView;

@property (nonatomic, strong) FYDropDownMenuTriangleView *triangleView;

@end


@implementation FYDropDownMenuView

#pragma mark - 生命周期<life circle>

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.menuContentView = [[UIView alloc] init];
        self.menuContentView.backgroundColor = [UIColor clearColor];
        self.menuContentView.clipsToBounds = YES;
        [self addSubview:self.menuContentView];
        
        // 公共属性的 默认属性的赋值<assign>
        self.cellClassName = @"FYDropDownMenuBasedCell";
        self.menuWidth = 150;
        self.menuCornerRadius = 5;
        self.eachMenuItemHeight = 40;
        self.menuRightMargin = 0;
        self.menuItemBackgroundColor = [UIColor whiteColor];
        self.triangleColor = [UIColor whiteColor];
        self.triangleY = 64;
        self.realTriangleY = self.triangleY;
        self.triangleRightMargin = 0;
        self.triangleSize = CGSizeMake(18, 10);
        self.bgColorbeginAlpha = 0.02;
        self.bgColorEndAlpha = 0.2;
        self.animateDuration = 0.2;
        self.menuAnimateType = FYDropDownMenuViewAnimateType_ScaleBasedTopRight;
        self.ifShouldScroll = NO;
        self.menuBarHeight = -100; //random value,to mark if outside assign
        
        self.isCellCorrect = NO;
        self.isShow = NO;
        
        // 监听状态栏高度改变的通知<observe statusbar height change notification>
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarHeightChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        // 监听状态栏的旋转<observe statusbar orientation change notification>
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 快速实例化一个菜单对象 <fast instance>

+ (instancetype)fyDropDownMenuWithSuperView:(UIView *)menuSuperView menuModelsArray:(NSArray *)menuModelsArray menuWidth:(CGFloat)menuWidth eachItemHeight:(CGFloat)eachItemHeight
{
    FYDropDownMenuView *menuView = [FYDropDownMenuView new];
    
    menuView.menuSuperView = menuSuperView;
    menuView.menuModelsArray = menuModelsArray;
    menuView.menuWidth = menuWidth;
    menuView.eachMenuItemHeight = eachItemHeight;

    [menuView setup];
    
    return menuView;
}

#pragma mark - 初始化 <setup>

- (void)setup
{
    [_tableView removeFromSuperview];
    _tableView = nil;
    
    // 屏幕的size  <screen size>
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // 设置view的圆角、frame  <set view's cornerRadius and frame>
    if (self.menuSuperView) {
        self.frame = self.menuSuperView.bounds;
        self.frame = CGRectMake(0, self.menuFrameY, self.frame.size.width, self.frame.size.height);
    } else {
        self.frame = [UIScreen mainScreen].bounds;
    }
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.bgColorEndAlpha];
    
    // 设置三角形的frame <set triangle frame>
    CGFloat horizonWidth = screenSize.width; //水平的宽度
    
    self.triangleView.frame = CGRectMake(horizonWidth - self.triangleRightMargin - self.triangleSize.width, self.realTriangleY, self.triangleSize.width, self.triangleSize.height);
    self.triangleView.triangleColor = self.triangleColor;
    
    // tableView(菜单栏)的frame <set tableView(menuBar) frame>
    CGFloat menuViewHeight = self.menuBarHeight >= 0 ? self.menuBarHeight : self.eachMenuItemHeight * self.menuModelsArray.count;
    self.menuViewFrame = CGRectMake(horizonWidth - self.menuWidth - self.menuRightMargin, CGRectGetMaxY(self.triangleView.frame), self.menuWidth, menuViewHeight);
    self.menuContentView.frame = self.menuViewFrame;
    self.tableView.frame = self.menuContentView.bounds;
    self.tableView.scrollEnabled = self.ifShouldScroll;
    self.tableView.backgroundColor = self.backgroundColor;
    
    [self.tableView reloadData];
}


#pragma mark - 横竖屏适配<Screen adaptation>

/** 横竖屏的改变 */
- (void)statusBarOrientationChange:(NSNotification *)note
{
    [self setup];
}

/** 状态栏frame的变化 */
- (void)statusBarHeightChanged:(NSNotification *)note
{
    CGRect statusBarFrame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];

    // 正常的状态栏高度是20
    CGFloat normalStatusBarHeight = 20;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    // FYLog(@"%@",NSStringFromCGRect(statusBarFrame));
    
    CGFloat screenWidth = 0;
    CGFloat screenHeight = 0;
    if (screenSize.height > screenSize.width) {
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
    }
    else {
        screenWidth = screenSize.height;
        screenHeight = screenSize.width;
    }
    
    // 横屏
    if (statusBarFrame.origin.y >= screenWidth || //横屏: statusBarFrame = {{0, 375}, {0, 0}}
        statusBarFrame.size.width >= screenHeight || //横屏: statusBarFrame = {{0, 0}, {667, 20}}
        statusBarFrame.origin.x >= screenHeight) { //横屏:{{568, 0}, {0, 0}}
        self.realTriangleY = self.triangleY - (44 - 32) - normalStatusBarHeight; //竖屏导航栏44， 横屏:32
        
    }
    else { //竖屏
        if (statusBarFrame.size.height == 0) {
            self.realTriangleY = self.triangleY;
        } else {
            self.realTriangleY = self.triangleY + (statusBarFrame.size.height - normalStatusBarHeight);
        }
    }
    
    [self setup];
}


#pragma mark - 懒加载<lazy load>

#define CELL_IDENTIFIER(cellClassName) ([NSString stringWithFormat:@"%@CellIdentifier",cellClassName])

- (UITableView *)tableView
{
    if (_tableView == nil) {
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] init];
        [self.menuContentView addSubview:tableView];
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.clipsToBounds = YES;
        tableView.layer.masksToBounds = YES;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        self.menuContentView.layer.cornerRadius = self.menuCornerRadius;
        tableView.layer.cornerRadius = self.menuCornerRadius;
        //锚点的设置 <set anchorPoint>
        switch (self.menuAnimateType) {
            case FYDropDownMenuViewAnimateType_ScaleBasedTopRight: //右上角
                tableView.layer.anchorPoint = CGPointMake(1, 0);
                break;
            case FYDropDownMenuViewAnimateType_ScaleBasedTopLeft: //左上角
                tableView.layer.anchorPoint = CGPointMake(0, 0);
                break;
            case FYDropDownMenuViewAnimateType_ScaleBasedMiddle: //中间
                break;
            case FYDropDownMenuViewAnimateType_FadeInFadeOut: //淡入淡出效果
                break;
            case FYDropDownMenuViewAnimateType_RollerShutter: //卷帘效果
                tableView.layer.anchorPoint = CGPointMake(0.5, 1);
                break;
            case FYDropDownMenuViewAnimateType_FallFromTop:
            break;
                
            default:
                break;
        }
        
        // 注册cell <register cell>
        if ([self.cellClassName hasSuffix:@".xib"]) { //xib名称
            NSString *className = [self.cellClassName componentsSeparatedByString:@".xib"].firstObject;
            if (!NSClassFromString(className)) {
                FYLog(NSLocalizedString(@"%@这个类不存在,请查看项目中是否有该类", nil),className);
                return _tableView;
            }
            
            if (![NSClassFromString(className) isSubclassOfClass:[FYDropDownMenuBasedCell class]]) {
                FYLog(NSLocalizedString(@"%@这个类不是FYDropDownMenuBasedCell的子类,请继承这个类", nil),className);
                return _tableView;
            }
            
            self.isCellCorrect = YES;
            UINib *cellNib = [UINib nibWithNibName:className bundle:nil];
            [tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER(self.cellClassName)];
            
        } else { //cell类名
            if (!NSClassFromString(self.cellClassName)) {
                FYLog(NSLocalizedString(@"%@这个类不存在,请查看项目中是否有该类", nil),self.cellClassName);
                return _tableView;
            }
            
            if (![NSClassFromString(self.cellClassName) isSubclassOfClass:[FYDropDownMenuBasedCell class]]) {
                FYLog(NSLocalizedString(@"%@这个类不是FYDropDownMenuBasedCell的子类,请继承这个类", nil),self.cellClassName);
                return _tableView;
            }
            
            self.isCellCorrect = YES;
            [tableView registerClass:NSClassFromString(self.cellClassName) forCellReuseIdentifier:CELL_IDENTIFIER(self.cellClassName)];
        }
        
        for (NSString * cellClassName in self.cellClassNames) {
            if ([cellClassName hasSuffix:@".xib"]) { //xib名称
                NSString *className = [cellClassName componentsSeparatedByString:@".xib"].firstObject;
                if (!NSClassFromString(className)) {
                    FYLog(NSLocalizedString(@"%@这个类不存在,请查看项目中是否有该类", nil),className);
                    return _tableView;
                }
                
                if (![NSClassFromString(className) isSubclassOfClass:[FYDropDownMenuBasedCell class]]) {
                    FYLog(NSLocalizedString(@"%@这个类不是YHSDropDownMenuBasedCell的子类,请继承这个类", nil),className);
                    return _tableView;
                }
                
                self.isCellCorrect = YES;
                UINib *cellNib = [UINib nibWithNibName:className bundle:nil];
                [tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER(cellClassName)];
                
            } else { //cell类名
                if (!NSClassFromString(cellClassName)) {
                    FYLog(NSLocalizedString(@"%@这个类不存在,请查看项目中是否有该类", nil),self.cellClassName);
                    return _tableView;
                }
                
                if (![NSClassFromString(cellClassName) isSubclassOfClass:[FYDropDownMenuBasedCell class]]) {
                    FYLog(NSLocalizedString(@"%@这个类不是YHSDropDownMenuBasedCell的子类,请继承这个类", nil),self.cellClassName);
                    return _tableView;
                }
                
                self.isCellCorrect = YES;
                [tableView registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:CELL_IDENTIFIER(cellClassName)];
            }
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (FYDropDownMenuTriangleView *)triangleView {
    if (_triangleView == nil) {
        FYDropDownMenuTriangleView *triangleView = [[FYDropDownMenuTriangleView alloc] init];
        [self addSubview:triangleView];
        triangleView.backgroundColor = [UIColor clearColor];
        _triangleView = triangleView;
    }
    return _triangleView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCellCorrect == NO) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    FYDropDownMenuBasedModel *menuModel = self.menuModelsArray[indexPath.row];
    NSString *cellClassName = menuModel.cellClassName;
    
    FYDropDownMenuBasedCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER(cellClassName)];
    if (!cell) {
        Class className = NSClassFromString(cellClassName);
        cell = [[className alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER(cellClassName)];
    }
    cell.menuModel = menuModel;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.delegate respondsToSelector:@selector(fyDropDownMenuView:WillAppearMenuCell:index:)]) {
        [self.delegate fyDropDownMenuView:self WillAppearMenuCell:cell index:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShow == YES) {
        FYDropDownMenuBasedModel *menuModel = self.menuModelsArray[indexPath.row];
        if (menuModel.menuBlock) {
            menuModel.menuBlock();
        }
        // 关闭菜单
        [self dismissMenuWithAnimation:NO then:^{
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYDropDownMenuBasedModel *menuModel = self.menuModelsArray[indexPath.row];
    NSString *cellClassName = menuModel.cellClassName;
    CGFloat height = [self.tableView fd_heightForCellWithIdentifier:CELL_IDENTIFIER(cellClassName)
                                                   cacheByIndexPath:indexPath
                                                      configuration:^(FYDropDownMenuBasedCell *cell) {
                                                          cell.menuModel = menuModel;
                                                      }];
    return height > 0 ? height : self.eachMenuItemHeight;
}



#pragma mark - 事件处理<action>

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /** 点击view退出菜单 */
    if (self.isShow == YES) {
        [self dismissMenuWithAnimation:YES then:^{
            
        }];
    }
}

/**
 *  关闭菜单
 *  @param animation 是否需要动画效果
 *  如果是点击cell  执行block里面的代码就无需动画
 *  如果死点击view的其他区域，没有执行block代码，则需要一个动画效果
 */
- (void)dismissMenuWithAnimation:(BOOL)animation then:(void (^)(void))then
{
    if (self.isShow == NO) return;
    
    [self menuWillDisappear];
    self.isShow = NO;
    
    //================================
    //          需要动画效果
    //================================
    if (animation == YES) {
        
        __weak typeof(self) weakSelf = self;
        
        //=============
        //淡入淡出动画效果
        //=============
        
        if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FadeInFadeOut) {
            [UIView animateWithDuration:self.animateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.bgColorbeginAlpha];
                weakSelf.tableView.alpha = 0;
                weakSelf.triangleView.alpha = 0;
                
                
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
                
                !then ?: then();
            }];
        }
        
        //============
        //   卷帘效果
        //============
        
        else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_RollerShutter) {
            [UIView animateWithDuration:self.animateDuration animations:^{
                CGRect frame = weakSelf.menuContentView.bounds;
                frame.size.height = 0;
                weakSelf.tableView.frame = frame;
                weakSelf.backgroundColor = FYCOLOR(0, 0, 0, weakSelf.bgColorbeginAlpha);
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
                
                !then ?: then();
            }];
            
        }
        
        
        //============
        // 从上往下落下
        //============
        
        else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FallFromTop) {
            
            
            [UIView animateWithDuration:self.animateDuration animations:^{
                CGRect tableViewLayerFrame = self.menuContentView.bounds;
                tableViewLayerFrame.origin.y = -tableViewLayerFrame.size.height;
                weakSelf.tableView.layer.frame = tableViewLayerFrame;
                weakSelf.backgroundColor = FYCOLOR(0, 0, 0, weakSelf.bgColorbeginAlpha);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                
                !then ?: then();
            }];
        }
        
        //=============
        //伸缩动画效果
        //=============
        else {
            //动画效果:在0.2秒内 大小缩小到 0.1倍 ，背景颜色由深变浅(其实颜色都是黑色，只是通过alpha来控制颜色的深浅)
            [UIView animateWithDuration:self.animateDuration animations:^{
                [weakSelf.tableView.layer setValue:@(0.1) forKeyPath:@"transform.scale"];
                weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:weakSelf.bgColorbeginAlpha];
                weakSelf.tableView.alpha = 0;
                weakSelf.triangleView.alpha = 0;
                
            } completion:^(BOOL finished) {
                //动画结束:将控制器的view从父控件中移除(父控件就是 KeyWindow)
                [weakSelf removeFromSuperview];
                
                !then ?: then();
            }];
        }
        
        
    }
    
    //================================
    //          不需要动画效果
    //================================
    
    
    else {
        //=============
        //淡入淡出动画效果
        //=============
        
        if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FadeInFadeOut) {
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.bgColorbeginAlpha];
            [self removeFromSuperview];
            
            !then ?: then();
        }
        
        //=============
        //   卷帘效果
        //=============
        
        else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_RollerShutter) {
            [self removeFromSuperview];
            
            !then ?: then();
        }

        
        //=============
        //  从上往下落下
        //=============
        
        else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FallFromTop) {
            CGRect tableViewLayerFrame = self.menuContentView.bounds;
            tableViewLayerFrame.origin.y = -tableViewLayerFrame.size.height;
            self.tableView.layer.frame = tableViewLayerFrame;
            [self removeFromSuperview];
            
            !then ?: then();
        }
        
        //=============
        //  伸缩动画效果
        //=============
        else {
            [self.tableView.layer setValue:@(0.1) forKeyPath:@"transform.scale"];
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.bgColorbeginAlpha];
            [self removeFromSuperview];
            
            !then ?: then();
        }
        
    }
    
    [self menuDidDisappear];
}


/** 显示菜单 */
- (void)showMenu
{
    [self menuWillShow];
    
    [self refreshMenuFrame];
    
    self.isShow = YES;
    if (self.menuSuperView) {
        [self.menuSuperView addSubview:self];
    } else {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
    }
    
    //将背景颜色设置浅的背景颜色
    self.backgroundColor = FYCOLOR(0, 0, 0, self.bgColorbeginAlpha);
    __weak typeof(self) weakSelf = self;
    

    //=============
    //  淡入淡出效果
    //=============
    
    if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FadeInFadeOut) {
        self.tableView.alpha = 0;
        self.triangleView.alpha = 0;
        
        [UIView animateWithDuration:self.animateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.backgroundColor = FYCOLOR(0, 0, 0, self.bgColorEndAlpha);
            weakSelf.tableView.alpha = 1;
            weakSelf.triangleView.alpha = 1;
        } completion:^(BOOL finished) {
            [weakSelf menuDidShow];
        }];
    }
    
    //=============
    //   卷帘效果
    //=============
    
    else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_RollerShutter) {
        self.backgroundColor = FYCOLOR(0, 0, 0, self.bgColorbeginAlpha);
        CGRect frame = self.menuContentView.bounds;
        frame.size.height = 0;
        self.tableView.frame = frame;
        [UIView animateWithDuration:self.animateDuration animations:^{
            weakSelf.tableView.frame = weakSelf.menuContentView.bounds;
            weakSelf.backgroundColor = FYCOLOR(0, 0, 0, weakSelf.bgColorEndAlpha);
        } completion:^(BOOL finished) {
            [weakSelf menuDidShow];
        }];
    }
    
    //============
    //  上往下落下
    //============
    
    else if (self.menuAnimateType == FYDropDownMenuViewAnimateType_FallFromTop) {
        CGRect tableViewLayerFrame = self.menuContentView.bounds;
        tableViewLayerFrame.origin.y = -tableViewLayerFrame.size.height;
        self.tableView.layer.frame = tableViewLayerFrame;

        [UIView animateWithDuration:self.animateDuration animations:^{
            weakSelf.tableView.layer.frame = weakSelf.menuContentView.bounds;
            weakSelf.backgroundColor = FYCOLOR(0, 0, 0, weakSelf.bgColorEndAlpha);
        } completion:^(BOOL finished) {
            [weakSelf menuDidShow];
        }];

    }
    
    
    
    //============
    //  伸缩效果
    //============
    
    else {
        self.tableView.alpha = 0;
        self.triangleView.alpha = 0;
        //先将menu的tableView缩小
        [self.tableView.layer setValue:@(0.1) forKeyPath:@"transform.scale"];
        //执行动画：背景颜色 由浅到深,menu的tableView由小到大，回复到正常大小
        [UIView animateWithDuration:self.animateDuration animations:^{
            weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.bgColorEndAlpha];
            [weakSelf.tableView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            weakSelf.tableView.alpha = 1;
            weakSelf.triangleView.alpha = 1;
        } completion:^(BOOL finished) {
            [weakSelf menuDidShow];
        }];
    }
}

/** 重载菜单 */
- (void)reloadMenu
{
    [self.tableView reloadData];
}

- (BOOL)isShowMenu
{
    return self.isShow;
}

- (void)dismissMenu:(BOOL)animation
{
    [self dismissMenu:animation then:^{
        
    }];
}

- (void)dismissMenu:(BOOL)animation then:(void (^)(void))then
{
    if (self.isShow == YES) {
        [self dismissMenuWithAnimation:animation then:^{
            !then ?: then();
        }];
    } else {
        !then ?: then();
    }
}

- (void)menuWillShow {
    
    if ([self.delegate respondsToSelector:@selector(fyDropDownMenuViewWillAppear:)]) {
        [self.delegate fyDropDownMenuViewWillAppear:self];
    }
}

- (void)menuDidShow {

    if ([self.delegate respondsToSelector:@selector(fyDropDownMenuViewWDidAppear:)]) {
        [self.delegate fyDropDownMenuViewWDidAppear:self];
    }
}

- (void)menuWillDisappear {
    
    if ([self.delegate respondsToSelector:@selector(fyDropDownMenuViewWillDisappear:)]) {
        [self.delegate fyDropDownMenuViewWillDisappear:self];
    }
}

- (void)menuDidDisappear {
    if ([self.delegate respondsToSelector:@selector(fyDropDownMenuViewWDidDisappear:)]) {
        [self.delegate fyDropDownMenuViewWDidDisappear:self];
    }
}


//=================================================================
//                   公共属性的set方法<set method>
//=================================================================
#pragma mark - 公共属性的set方法<set method>

- (void)setMenuModelsArray:(NSArray *)menuModelsArray {//1
    _menuModelsArray = menuModelsArray;
}

- (void)setCellClassName:(NSString *)cellClassName {//2
    _cellClassName = cellClassName;
}

- (void)setMenuWidth:(CGFloat)menuWidth {//3
    if (menuWidth != FYDefaultFloat) {
        _menuWidth = menuWidth;
    }
}

- (void)setMenuCornerRadius:(CGFloat)menuCornerRadius {//4
    if (menuCornerRadius != FYDefaultFloat) {
        _menuCornerRadius = menuCornerRadius;
    }
}

- (void)setEachMenuItemHeight:(CGFloat)eachMenuItemHeight {//5
    if (eachMenuItemHeight != FYDefaultFloat) {
        _eachMenuItemHeight = eachMenuItemHeight;
    }
}

- (void)setMenuRightMargin:(CGFloat)menuRightMargin {//6
    if (menuRightMargin != FYDefaultFloat) {
        _menuRightMargin = menuRightMargin;
    }
}

- (void)setMenuItemBackgroundColor:(UIColor *)menuItemBackgroundColor { //7
    _menuItemBackgroundColor = menuItemBackgroundColor;
    
}

- (void)setTriangleColor:(UIColor *)triangleColor {//8
    _triangleColor = triangleColor;
}

- (void)setTriangleY:(CGFloat)triangleY {//9
    if (triangleY != FYDefaultFloat) {
        _triangleY = triangleY;
        self.realTriangleY = _triangleY;
    }
}

- (void)setTriangleRightMargin:(CGFloat)triangleRightMargin {//10
    if (triangleRightMargin != FYDefaultFloat) {
        _triangleRightMargin = triangleRightMargin;
    }
}

- (void)setTriangleSize:(CGSize)triangleSize {//11
    _triangleSize = triangleSize;
}

- (void)setBgColorbeginAlpha:(CGFloat)bgColorbeginAlpha {//12
    if (bgColorbeginAlpha != FYDefaultFloat) {
        _bgColorbeginAlpha = bgColorbeginAlpha;
    }
}

- (void)setBgColorEndAlpha:(CGFloat)bgColorEndAlpha {//13
    if (bgColorEndAlpha != FYDefaultFloat) {
        _bgColorEndAlpha = bgColorEndAlpha;
    }
}

- (void)setAnimateDuration:(CGFloat)animateDuration {//14
    if (animateDuration != FYDefaultFloat) {
        _animateDuration = animateDuration;
    }
}

- (void)setMenuAnimateType:(FYDropDownMenuViewAnimateType)menuAnimateType { //15
    _menuAnimateType = menuAnimateType;
}

- (void)setIfShouldScroll:(BOOL)ifShouldScroll {//16
    _ifShouldScroll = ifShouldScroll;
}

- (void)setMenuBarHeight:(CGFloat)menuBarHeight { //17
    if (menuBarHeight != FYDefaultFloat) {
        _menuBarHeight = menuBarHeight;
    }
}

- (void)setMenuFrameY:(CGFloat)menuFrameY {//19
    if (menuFrameY != 0) {
        _menuFrameY = menuFrameY;
    }
}


#pragma mark - 私有方法 <Private>

- (void)refreshMenuFrame
{
    CGFloat menuViewHeight = 0.0;
    for (NSInteger idx = 0; idx < self.menuModelsArray.count; idx ++) {
        CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        menuViewHeight += height;
    }
    CGRect menuContentViewFrame = CGRectMake(self.menuViewFrame.origin.x,
                                             self.menuViewFrame.origin.y,
                                             self.menuViewFrame.size.width,
                                             menuViewHeight);
    self.menuContentView.frame = menuContentViewFrame;
    self.tableView.frame = CGRectMake(0, 0, self.menuViewFrame.size.width, menuViewHeight);
}

@end
