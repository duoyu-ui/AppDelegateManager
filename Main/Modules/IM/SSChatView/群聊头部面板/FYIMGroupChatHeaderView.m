
#import "FYIMGroupChatHeaderView.h"

@interface FYIMGroupChatHeaderView()

/* 余额 */
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIView *balanceContainer;

/* 充值 */
@property (nonatomic, strong) UIButton *buttonOfRecharge;

/* 玩法 */
@property (nonatomic, strong) UIButton *buttonOfPlayRule;

/* 分享 */
@property (nonatomic, strong) UIButton *buttonOfShare;

@end

@implementation FYIMGroupChatHeaderView

- (instancetype)initWithGroupTemplateType:(NSInteger)groupTemplateType
{
    return [self initWithFrame:CGRectZero groupTemplateType:groupTemplateType];
}

- (instancetype)initWithFrame:(CGRect)frame groupTemplateType:(NSInteger)groupTemplateType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = HexColor(@"#DEDEDE");
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(kLineHeight);
        }];
        _groupTemplateType = groupTemplateType;
        [self createViewAutoLayout];
    }
    return self;
}

- (void)createViewAutoLayout
{
    [self setHidden:YES];
    
    // 抢庄牛牛、二八杠、龙虎斗
    if (GroupTemplate_N04_RobNiuNiu == self.groupTemplateType
        || GroupTemplate_N05_ErBaGang == self.groupTemplateType
        || GroupTemplate_N06_LongHuDou == self.groupTemplateType
        || GroupTemplate_N15_MineClearance == self.groupTemplateType) {
         self.buttonOfPlayRule.hidden = NO;
        [self createViewAutoLayoutForRobNiuNiu];
    }
    // 接龙红包
    else if (GroupTemplate_N07_JieLong == self.groupTemplateType) {
        self.buttonOfPlayRule.hidden = NO;
        [self createViewAutoLayoutForSolitaire];
    }else if (GroupTemplate_N00_FuLi == self.groupTemplateType){//福利
        self.buttonOfPlayRule.hidden = YES;
         [self createViewAutoLayoutForOthers];
    }
    // 其它
    else {
        self.buttonOfPlayRule.hidden = NO;
        [self createViewAutoLayoutForOthers];
    }
    
    // 分割线
    {
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        separatorLineView.mas_key = @"separatorLineView";
    }
    
    // 添加监听通知
    [self addNotifications];
}

- (void)createViewAutoLayoutForRobNiuNiu
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat btnWidth = 70;
    
    [self addSubview:self.balanceContainer];
    [self.balanceContainer addSubview:self.balanceLabel];
    [self addSubview:self.buttonOfRecharge];
    [self addSubview:self.buttonOfPlayRule];
    [self addSubview:self.buttonOfShare];
    
    {
        // 余额
        {
            [self.balanceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(6);
                make.bottom.equalTo(self.mas_bottom).offset(-margin*0.3f);
                make.top.equalTo(self.mas_top).offset(margin*0.5f);
                make.width.greaterThanOrEqualTo(@(60));
            }];
            
            UIImageView *balanceImageView = ({
                UIImageView *imageView = [[UIImageView alloc] init];
                [self.balanceContainer addSubview:imageView];
                [imageView setImage:[UIImage imageNamed:@"icon_group_header_balance"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.balanceContainer).offset(margin*0.8);
                    make.centerY.equalTo(self.balanceContainer.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(13, 16));
                }];
                
                imageView;
            });
            balanceImageView.mas_key = @"balanceImageView";
            
            [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(balanceImageView.mas_right).offset(margin*0.6f);
                make.centerY.equalTo(self.balanceContainer.mas_centerY);
                make.width.mas_greaterThanOrEqualTo(40);
            }];
            
            [self.balanceContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.balanceLabel.mas_right).offset(margin*0.8f);
            }];
        }

        // 充值
        [self.buttonOfRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.balanceContainer.mas_right);
            make.centerY.equalTo(self.balanceContainer.mas_centerY);
            make.height.equalTo(self.balanceContainer.mas_height).multipliedBy(0.65f);
            make.width.equalTo(self.balanceContainer.mas_height).multipliedBy(1.3f);
        }];
        
        // 分享
        {
            [self.buttonOfShare mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.balanceContainer.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-margin);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnWidth*0.45f);
            }];
            
            UILabel *titleLabel = ({
                UILabel *label = [UILabel new];
                [self.buttonOfShare addSubview:label];
                [label setText:NSLocalizedString(@"分享", nil)];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                    make.right.equalTo(self.buttonOfShare.mas_right);
                }];

                label;
            });
            titleLabel.mas_key = @"titleLabel";

            UIImageView *iconImageView = ({
                CGFloat imageSize = btnWidth * 0.32f;
                UIImageView *imageView = [[UIImageView alloc] init];
                [self.buttonOfShare addSubview:imageView];
                [imageView setImage:[UIImage imageNamed:@"icon_game_share"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                    make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
                }];

                imageView;
            });
            iconImageView.mas_key = @"iconImageView";
        }
        
        // 玩法
        {
            [self.buttonOfPlayRule mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.buttonOfShare);
                make.right.equalTo(self.buttonOfShare.mas_left);
                make.width.equalTo(self.buttonOfShare.mas_width);
            }];
            
            UILabel *titleLabel = ({
                UILabel *label = [UILabel new];
                [self.buttonOfPlayRule addSubview:label];
                [label setText:NSLocalizedString(@"玩法", nil)];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                    make.right.equalTo(self.buttonOfPlayRule.mas_right);
                }];

                label;
            });
            titleLabel.mas_key = @"titleLabel";

            UIImageView *iconImageView = ({
                CGFloat imageSize = btnWidth * 0.35f;
                UIImageView *imageView = [[UIImageView alloc] init];
                [self.buttonOfPlayRule addSubview:imageView];
                [imageView setImage:[UIImage imageNamed:@"icon_game_howto"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                    make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
                }];

                imageView;
            });
            iconImageView.mas_key = @"iconImageView";
        }
    }
}

- (void)createViewAutoLayoutForSolitaire
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat btnWidth = 70;

    [self addSubview:self.balanceContainer];
    [self.balanceContainer addSubview:self.balanceLabel];
    [self addSubview:self.buttonOfRecharge];
    [self addSubview:self.buttonOfPlayRule];
    [self addSubview:self.buttonOfShare];


    
    // 余额
    {
        [self.balanceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(6);
            make.top.equalTo(self.mas_top).offset(margin*0.5f);
            make.bottom.equalTo(self.mas_bottom).offset(-margin*0.5f);
            make.width.greaterThanOrEqualTo(@(60));
        }];
        
        UIImageView *balanceImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.balanceContainer addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:@"icon_group_header_balance"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.balanceContainer).offset(margin*0.8);
                make.centerY.equalTo(self.balanceContainer.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(13, 16));
            }];
            
            imageView;
        });
        balanceImageView.mas_key = @"balanceImageView";
        
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceImageView.mas_right).offset(margin*0.6f);
            make.centerY.equalTo(self.balanceContainer.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(40);
        }];
        
        [self.balanceContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.balanceLabel.mas_right).offset(margin*0.8f);
        }];
    }

    // 充值
    [self.buttonOfRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceContainer.mas_right);
        make.centerY.equalTo(self.balanceContainer.mas_centerY);
        make.height.equalTo(self.balanceContainer.mas_height).multipliedBy(0.65f);
        make.width.equalTo(self.balanceContainer.mas_height).multipliedBy(1.3f);
    }];
    
    // 分享
    {
        [self.buttonOfShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.balanceContainer.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-margin);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth*0.45f);
        }];

        UILabel *titleLabel = ({
            UILabel *label = [UILabel new];
            [self.buttonOfShare addSubview:label];
            [label setText:NSLocalizedString(@"分享", nil)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                make.right.equalTo(self.buttonOfShare.mas_right);
            }];

            label;
        });
        titleLabel.mas_key = @"titleLabel";

        UIImageView *iconImageView = ({
            CGFloat imageSize = btnWidth * 0.32f;
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.buttonOfShare addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:@"icon_game_share"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            }];

            imageView;
        });
        iconImageView.mas_key = @"iconImageView";
    }

    // 玩法
    {
        [self.buttonOfPlayRule mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.buttonOfShare);
            make.right.equalTo(self.buttonOfShare.mas_left);
            make.width.equalTo(self.buttonOfShare.mas_width);
        }];

        UILabel *titleLabel = ({
            UILabel *label = [UILabel new];
            [self.buttonOfPlayRule addSubview:label];
            [label setText:NSLocalizedString(@"玩法", nil)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                make.right.equalTo(self.buttonOfPlayRule.mas_right);
            }];

            label;
        });
        titleLabel.mas_key = @"titleLabel";

        UIImageView *iconImageView = ({
            CGFloat imageSize = btnWidth * 0.35f;
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.buttonOfPlayRule addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:@"icon_game_howto"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            }];

            imageView;
        });
        iconImageView.mas_key = @"iconImageView";
    }
}

- (void)createViewAutoLayoutForOthers
{
      CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
      CGFloat btnWidth = 70;
    
      [self addSubview:self.balanceContainer];
      [self.balanceContainer addSubview:self.balanceLabel];
      [self addSubview:self.buttonOfRecharge];
      [self addSubview:self.buttonOfPlayRule];
      [self addSubview:self.buttonOfShare];

      // 余额
      {
          [self.balanceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.mas_left).offset(6);
              make.top.equalTo(self.mas_top).offset(margin*0.5f);
              make.bottom.equalTo(self.mas_bottom).offset(-margin*0.5f);
              make.width.greaterThanOrEqualTo(@(60));
          }];
          
          UIImageView *balanceImageView = ({
              UIImageView *imageView = [[UIImageView alloc] init];
              [self.balanceContainer addSubview:imageView];
              [imageView setImage:[UIImage imageNamed:@"icon_group_header_balance"]];
              [imageView setContentMode:UIViewContentModeScaleAspectFill];

              [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(self.balanceContainer).offset(margin*0.8);
                  make.centerY.equalTo(self.balanceContainer.mas_centerY);
                  make.size.mas_equalTo(CGSizeMake(13, 16));
              }];
              
              imageView;
          });
          balanceImageView.mas_key = @"balanceImageView";
          
          [self.balanceLabel setText:[NSString stringWithFormat:@"%.2lf",[APPINFORMATION.userInfo.balance floatValue]]];
          [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(balanceImageView.mas_right).offset(margin*0.6f);
              make.centerY.equalTo(self.balanceContainer.mas_centerY);
              make.width.mas_greaterThanOrEqualTo(40);
          }];
          
          [self.balanceContainer mas_updateConstraints:^(MASConstraintMaker *make) {
              make.right.equalTo(self.balanceLabel.mas_right).offset(margin*0.8f);
          }];
      }

      // 充值
      [self.buttonOfRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.balanceContainer.mas_right);
          make.centerY.equalTo(self.balanceContainer.mas_centerY);
          make.height.equalTo(self.balanceContainer.mas_height).multipliedBy(0.65f);
          make.width.equalTo(self.balanceContainer.mas_height).multipliedBy(1.3f);
      }];
      
      // 分享
      {
          [self.buttonOfShare mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(self.balanceContainer.mas_centerY);
              make.right.equalTo(self.mas_right).offset(-margin);
              make.width.mas_equalTo(btnWidth);
              make.height.mas_equalTo(btnWidth*0.45f);
          }];

          UILabel *titleLabel = ({
              UILabel *label = [UILabel new];
              [self.buttonOfShare addSubview:label];
              [label setText:NSLocalizedString(@"分享", nil)];
              [label setTextAlignment:NSTextAlignmentRight];
              [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
              [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

              [label mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                  make.right.equalTo(self.buttonOfShare.mas_right);
              }];

              label;
          });
          titleLabel.mas_key = @"titleLabel";

          UIImageView *iconImageView = ({
              CGFloat imageSize = btnWidth * 0.32f;
              UIImageView *imageView = [[UIImageView alloc] init];
              [self.buttonOfShare addSubview:imageView];
              [imageView setImage:[UIImage imageNamed:@"icon_game_share"]];
              [imageView setContentMode:UIViewContentModeScaleAspectFill];

              [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                  make.centerY.equalTo(self.buttonOfShare.mas_centerY);
                  make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
              }];

              imageView;
          });
          iconImageView.mas_key = @"iconImageView";
      }

      // 玩法
      {
          [self.buttonOfPlayRule mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.bottom.equalTo(self.buttonOfShare);
              make.right.equalTo(self.buttonOfShare.mas_left);
              make.width.equalTo(self.buttonOfShare.mas_width);
          }];

          UILabel *titleLabel = ({
              UILabel *label = [UILabel new];
              [self.buttonOfPlayRule addSubview:label];
              [label setText:NSLocalizedString(@"玩法", nil)];
              [label setTextAlignment:NSTextAlignmentRight];
              [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
              [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];

              [label mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                  make.right.equalTo(self.buttonOfPlayRule.mas_right);
              }];

              label;
          });
          titleLabel.mas_key = @"titleLabel";

          UIImageView *iconImageView = ({
              CGFloat imageSize = btnWidth * 0.35f;
              UIImageView *imageView = [[UIImageView alloc] init];
              [self.buttonOfPlayRule addSubview:imageView];
              [imageView setImage:[UIImage imageNamed:@"icon_game_howto"]];
              [imageView setContentMode:UIViewContentModeScaleAspectFill];

              [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.right.equalTo(titleLabel.mas_left).offset(-margin*0.2f);
                  make.centerY.equalTo(self.buttonOfPlayRule.mas_centerY);
                  make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
              }];

              imageView;
          });
          iconImageView.mas_key = @"iconImageView";
      }
}

//- (void)setModelOfNiuNiu:(RobNiuNiuQunModel *)modelOfNiuNiu
//{
//    _modelOfNiuNiu = modelOfNiuNiu;
//    
    // 庄家
//    self.zjNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"庄家: %@", nil),_modelOfNiuNiu.bankNick ?_modelOfNiuNiu.bankNick :NSLocalizedString(@"暂无庄家", nil)];
    // 期数
//    self.qiShuLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld期", nil),_modelOfNiuNiu.gameNumber];
    // 群状态
//    self.groupStatusLabel.text = [self getGroupStatus:_modelOfNiuNiu.status];
//    NSLog(NSLocalizedString(@"群状态: %@", nil),[self getGroupStatus:_modelOfNiuNiu.status]);
//    NSLog(NSLocalizedString(@"群状态: %zd", nil),_modelOfNiuNiu.status);
    // 上庄
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString(@"上庄:  %ld 元", nil), (long)_modelOfNiuNiu.banMoney]];
//    NSDictionary *dict = @{NSBackgroundColorAttributeName:CDCOLORA(255, 255, 255, 0.15)};
//    [att setAttributes:dict range:NSMakeRange(4, att.length - 5)];
//    self.szMoneyLabel.attributedText = att;
    // 游戏人数/抢庄人数
//    self.qzPeopleLabel.text =[NSString stringWithFormat:@"%@:%ld", [self getRobNumType:_modelOfNiuNiu.status], _modelOfNiuNiu.people];
    // 结束时间
//    {
//        self.endTime = _modelOfNiuNiu.endTime;
//        self.jieShuTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"距结束:%ld秒", nil), (long)self.endTime];
        //
//        [self.timer invalidate];
//        self.timer = nil;
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endTimeDjis) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    }
//
//}

//- (void)setModelOfSolitaire:(FYSolitaireInfoModel *)modelOfSolitaire
//{
//    _modelOfSolitaire = modelOfSolitaire;
//
//}

- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];

}



#pragma mark - Notification

/// 添加监听通知
- (void)addNotifications
{
    // 余额变动通知
    [NOTIF_CENTER addObserver:self selector:@selector(doNotificationUpdateUserInfoBalance:) name:kNotificationUserInfoBalanceChange object:nil];
}

/// 通知事件处理 - 余额实时变动
- (void)doNotificationUpdateUserInfoBalance:(NSNotification *)notification
{
    NSDictionary *object = (NSDictionary *)notification.object;
    NSString *balance = [object stringForKey:@"balance"];
    if (VALIDATE_STRING_EMPTY(balance)) {
        return;
    }
    
    WEAKSELF(weakSelf);
    dispatch_main_async_safe((^{
        NSString *formatBalacne = [NSString stringWithFormat:@"%0.2f", balance.floatValue];
        [weakSelf setBalance:formatBalacne];
        [weakSelf.balanceLabel setText:formatBalacne];
    }));
}


#pragma mark - Getter / Setter

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    [self.balanceLabel setText:balance];
}

- (UIView *)balanceContainer
{
    if (!_balanceContainer) {
        _balanceContainer = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressActionOfCheckBalance:)];
        [_balanceContainer addGestureRecognizer:tapGesture];
    }
    return _balanceContainer;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.font = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)];
        _balanceLabel.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    }
    return _balanceLabel;
}

- (UIButton *)buttonOfRecharge
{
    if (!_buttonOfRecharge) {
        _buttonOfRecharge = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonOfRecharge addCornerRadius:3.0f];
        [_buttonOfRecharge.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
        [_buttonOfRecharge setTitle:NSLocalizedString(@"充值", nil) forState:UIControlStateNormal];
        [_buttonOfRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonOfRecharge setBackgroundColor:COLOR_HEXSTRING(@"#E75E58")];
        [_buttonOfRecharge addTarget:self action:@selector(pressActionOfButtonRecharge:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOfRecharge;
}

- (UIButton *)buttonOfPlayRule
{
    if (!_buttonOfPlayRule) {
        _buttonOfPlayRule = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonOfPlayRule addTarget:self action:@selector(pressActionOfButtonPlayRule:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOfPlayRule;
}

- (UIButton *)buttonOfShare
{
    if (!_buttonOfShare) {
        _buttonOfShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonOfShare addTarget:self action:@selector(pressActionOfButtonShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOfShare;
}



#pragma mark - FYIMGroupChatHeaderViewDelegate

// 余额
- (void)pressActionOfCheckBalance:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupHeaderView:didActionOfCheckBalance:)]) {
        [self.delegate groupHeaderView:self didActionOfCheckBalance:self.balanceLabel];
    }
}

// 充值
- (void)pressActionOfButtonRecharge:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupHeaderView:didActionOfRecharge:)]) {
        [self.delegate groupHeaderView:self didActionOfRecharge:sender];
    }
}

// 玩法
- (void)pressActionOfButtonPlayRule:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupHeaderView:didActionOfPlayRule:)]) {
        [self.delegate groupHeaderView:self didActionOfPlayRule:sender];
    }
}

//分享
- (void)pressActionOfButtonShare:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupHeaderView:didActionOfShare:)]) {
        [self.delegate groupHeaderView:self didActionOfShare:sender];
    }
}


#pragma mark - Private

- (NSString *)getRobNumType:(NSInteger)type
{
    switch (type) {
        case 2 :
            return NSLocalizedString(@"抢庄人数", nil);
            break;
        case 1 :
        case 3:
        case 4:
        case 5:
        case 6:
            return NSLocalizedString(@"游戏人数", nil);
            break;
        default:
            return @"";
            break;
    }
}

// 群状态
- (NSString *)getGroupStatus:(NSInteger)status
{
    switch (status) {
        case 1:
            return NSLocalizedString(@"连续上庄", nil);
            break;
        case 2:
            return NSLocalizedString(@"抢庄", nil);
            break;
        case 3:
            return NSLocalizedString(@"投注", nil);
            break;
        case 4:
            return NSLocalizedString(@"发包", nil);
            break;
        case 5:
            return NSLocalizedString(@"抢包", nil);
            break;
        case 6:
            return NSLocalizedString(@"结算", nil);
            break;
        case 7:
            return NSLocalizedString(@"停用", nil);
            break;
        default:
            return nil;
            break;
    }
}

@end

