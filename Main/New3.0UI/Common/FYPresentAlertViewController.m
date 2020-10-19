//
//  FYPresentAlertViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPresentAlertViewController.h"

@interface FYPresentAlertViewController ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation FYPresentAlertViewController

+ (instancetype)alertController
{
    return [[self class] alertControllerWithContent: NSLocalizedString(@"检测到您暂未绑定手机号，存在风险，\n请及时设置。", nil)];
}

+ (instancetype)alertControllerWithContent:(NSString *)content
{
    return [[self class] alertControllerWithContent:content imageUrl:@""];
}

+ (instancetype)alertControllerWithContent:(NSString *)content imageUrl:(NSString *)imageUrl
{
    FYPresentAlertViewController *instance = [[FYPresentAlertViewController alloc] init];
    instance.content = content;
    instance.imageUrl = imageUrl;
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    UIView *container = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        view;
    });
    self.container = container;
    self.container.mas_key = @"container";
    
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [container addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_alert_!red"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat size = CFC_AUTOSIZING_WIDTH(35);
            make.centerX.equalTo(container.mas_centerX);
            make.centerY.equalTo(container.mas_bottom).multipliedBy(0.3f);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];
        
        imageView;
    });
    self.imageView = imageView;
    self.imageView.mas_key = @"imageView";
    
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [container addSubview:label];
        [label setNumberOfLines:0];
        [label setText:self.content];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];
        switch (self.alertTextAlignment) {
            case FYPresentAlertTextAlignmentLeft:
                [label setTextAlignment:NSTextAlignmentLeft];
                break;
            case FYPresentAlertTextAlignmentCenter:
                [label setTextAlignment:NSTextAlignmentCenter];
                break;
            case FYPresentAlertTextAlignmentRight:
                [label setTextAlignment:NSTextAlignmentRight];
                break;
            default:
                [label setTextAlignment:NSTextAlignmentLeft];
                break;
        }
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(margin*2.0f);
            make.left.equalTo(container.mas_left).offset(margin*5.0f);
            make.right.equalTo(container.mas_right).offset(-margin*5.0f);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    UIButton *cancleButton = ({
        UIButton *button = [self createButtonWithTitle:NSLocalizedString(@"取消", nil) action:@selector(pressCancleButtonAcion:)];
        [container addSubview:button];
        [button.titleLabel setTextColor:[UIColor grayColor]];
        [button addBorderWithColor:[UIColor grayColor] cornerRadius:5 andWidth:1.0];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(margin*2.5f);
            make.centerX.equalTo(container.mas_right).multipliedBy(0.30f);
            make.right.equalTo(container.mas_centerX).offset(-margin*1.0f);
            make.height.equalTo(@(50));
        }];
        
        button;
    });
    self.cancleButton = cancleButton;
    self.cancleButton.mas_key = @"cancleButton";
    
    UIButton *confirmButton = ({
        UIButton *button = [self createButtonWithTitle:NSLocalizedString(@"前往设置", nil) action:@selector(pressConfirmButtonAcion:)];
        [container addSubview:button];
        [button addBorderWithColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT cornerRadius:5 andWidth:1.0];
        [button setBackgroundColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancleButton.mas_top);
            make.centerX.equalTo(container.mas_right).multipliedBy(0.70f);
            make.left.equalTo(container.mas_centerX).offset(margin*1.0f);
            make.height.equalTo(@(50));
        }];
        
        button;
    });
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";
}


- (void)pressConfirmButtonAcion:(id)button
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.confirmActionBlock) {
            self.confirmActionBlock();
        }
    }];
}

- (void)pressCancleButtonAcion:(id)button
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}

- (void)setAlertTextAlignment:(FYPresentAlertTextAlignment)alertTextAlignment
{
    _alertTextAlignment = alertTextAlignment;
    switch (alertTextAlignment) {
        case FYPresentAlertTextAlignmentLeft:
            [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
            break;
        case FYPresentAlertTextAlignmentCenter:
            [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        case FYPresentAlertTextAlignmentRight:
            [self.contentLabel setTextAlignment:NSTextAlignmentRight];
            break;
        default:
            break;
    }
}


@end

