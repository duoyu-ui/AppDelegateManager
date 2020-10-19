

#import "FYMenu.h"
#import "FYMenuView.h"

@interface FYMenu()
@property (nonatomic, strong) NSMutableArray<FYMenuItem *> *menuItems;
@property (nonatomic, weak) FYMenuView *menuView;
@property (nonatomic, assign) BOOL observing;
@end

@implementation FYMenu

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.menuItems = [NSMutableArray array];
        self.titleFont = [UIFont systemFontOfSize2:15];
        self.arrowHight = 8.f;
        self.menuCornerRadiu = 5.f;
        self.edgeInsets = UIEdgeInsetsMake(1, 10, 1, 10);
        self.minMenuItemHeight = 35.f;
        self.minMenuItemWidth = 32.f; 
        self.gapBetweenImageTitle = 5.f;
        self.menuSegmenteLineStyle = IFMMenuSegmenteLineStylefollowContent;
        self.menuBackgroundStyle = IFMMenuBackgroundStyleDark;
        self.showShadow = YES;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray<FYMenuItem *> *)items{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
    }
    return self;
}
- (instancetype)initWithItems:(NSArray<FYMenuItem *> *)items BackgroundStyle:(IFMMenuBackgroundStyle)backgroundStyle{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
        self.menuBackgroundStyle = backgroundStyle;
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)addMenuItem:(FYMenuItem *)menuItem{
    [self.menuItems addObject:menuItem];
}

- (void) orientationWillChange: (NSNotification *)note
{
    [self dismissMenu];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view{
    NSParameterAssert(view);
    NSParameterAssert(self.menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    FYMenuView *menuView = [[FYMenuView alloc] init];
    [view addSubview:menuView];
    _menuView = menuView;
    [menuView showMenuInView:view fromRect:rect menu:self menuItems:self.menuItems];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, kNavBarAndStatusBarHeight, 1, 1);
    [self showFromRect:rect inView:navigationController.view];
}
- (void)showFromTabBarController:(UITabBarController *)tabBarController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - kTabBarHeight, 1, 1);
    [self showFromRect:rect inView:tabBarController.view];
}

- (void) dismissMenu
{
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
