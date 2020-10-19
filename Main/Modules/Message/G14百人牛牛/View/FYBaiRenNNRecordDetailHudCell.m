//
//  FYBaiRenNNRecordDetailHudCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNRecordDetailHudCell.h"
#import "FYBaiRenNNRecordDetailModel.h"

@interface FYBaiRenNNRecordDetailHudCell ()
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemLabels;
@end


@implementation FYBaiRenNNRecordDetailHudCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)headerViewHeight
{
    return CFC_AUTOSIZING_WIDTH(35.0);
}

+ (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.52f), @(0.66f), @(0.80f), @(1.0f) ];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray<NSNumber *> *percents = [[self class] getColumnPercents];
    UIFont *titleFont = FONT_PINGFANG_REGULAR(14);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    CGFloat itemHeight = [[self class] headerViewHeight];
    
    UILabel *lastItemLabel = nil;
    _itemLabels = [NSMutableArray array];
    for (NSInteger index = 0; index < percents.count; index ++) {
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setText:STR_APP_TEXT_PLACEHOLDER];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            CGFloat percent = [percents objectAtIndex:index].floatValue;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
                make.height.equalTo(@(itemHeight));
                if (!lastItemLabel) {
                    make.top.equalTo(self.contentView.mas_top);
                    make.left.equalTo(self.contentView.mas_left);
                } else {
                    make.top.equalTo(lastItemLabel.mas_top);
                    make.left.equalTo(lastItemLabel.mas_right);
                }
            }];
            
            label;
        });
        lastItemLabel.mas_key = [NSString stringWithFormat:@"titleLabel%ld", index];
        //
        if (index < percents.count -1) {
            UILabel *splitLine = ({
                UILabel *view = [[UILabel alloc] init];
                [view setBackgroundColor:HexColor(@"#E6E6E6")];
                [self.contentView addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(lastItemLabel.mas_right);
                     make.top.bottom.equalTo(self.contentView);
                    make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                }];
                
                view;
            });
            splitLine.mas_key = @"splitLine";
        }
        //
        [_itemLabels addObj:lastItemLabel];
    }
    
    UILabel *separatorLineView = ({
        UILabel *view = [[UILabel alloc] init];
        [view setBackgroundColor:HexColor(@"#E6E6E6")];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}

#pragma mark - 设置数据模型
- (void)setModel:(FYBaiRenNNRecordDetailInfoModel *)model
{
    if (![model isKindOfClass:[FYBaiRenNNRecordDetailInfoModel class]]) {
        return;
    }
    
    _model = model;

    // 压
    UILabel *column1Label = [self.itemLabels objectAtIndex:0];
    [column1Label setText:[self buildColumn1Title:self.model]];
    
    // 投注
    UILabel *column2Label = [self.itemLabels objectAtIndex:1];
    [column2Label setText:[NSString stringWithFormat:@"%@", self.model.singleMoney]];
    
    // 赔率
    UILabel *column3Label = [self.itemLabels objectAtIndex:2];
    [column3Label setText:[NSString stringWithFormat:@"%@", self.model.odds]];
    
    // 投注
    UILabel *column4Label = [self.itemLabels objectAtIndex:3];
    if (self.model.money.floatValue == 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"未中奖", nil)] attributeArray:@[attrText]];
        [column4Label setAttributedText:attrString];
    } else if (self.model.money.floatValue < 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"- %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [column4Label setAttributedText:attrString];
    } else {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"+ %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [column4Label setAttributedText:attrString];
    }
}

- (NSString *)buildColumn1Title:(FYBaiRenNNRecordDetailInfoModel *)model
{
    /*
     //猜胜负
     LANSHENG(1,1,"蓝方胜"),
     HONGSHENG(1,2,"红方胜"),
     
     //猜两面
     DA(2,1,"大"),
     XIAO(2,2,"小"),
     DAN(2,3,"单"),
     SHUANG(2,4,"双"),
     DADAN(2,5,"大单"),
     XIAODAN(2,6,"小单"),
     DASHUAGN(2,7,"大双"),
     XIAOSHUANG(2,8,"小双"),
    
     //猜牛牛
     WUNIU(3,0,"无牛"),
     NIUYI(3,1,"牛一"),
     NIUER(3,2,"牛二"),
     NIUSAN(3,3,"牛三"),
     NIUSI(3,4,"牛四"),
     NIUWU(3,5,"牛五"),
     NIULIU(3,6,"牛六"),
     NIUQI(3,7,"牛七"),
     NIUBA(3,8,"牛八"),
     NIUJIU(3,9,"牛九"),
     NIUNIU(3,10,"牛牛"),
     WUHUANIU(3,11,"五花牛"),
     
     //猜牌面
     A(4,1,"A"),
     ER(4,2,"2"),
     SAN(4,3,"3"),
     SI(4,4,"4"),
     WU(4,5,"5"),
     LIU(4,6,"6"),
     QI(4,7,"7"),
     BA(4,8,"8"),
     JIU(4,9,"9"),
     SHI(4,10,"10"),
     J(4,11,"J"),
     Q(4,12,"Q"),
     K(4,13,"K");
     */
    
    NSString *resultTitle = @"";
    NSDictionary *dicts = @{
        @"1" : @{ @"oneLevelTitle":NSLocalizedString(@"猜胜负", nil),
                  @"twoLevelDicts":@{ @"1":NSLocalizedString(@"蓝方胜", nil),
                                      @"2":NSLocalizedString(@"红方胜", nil) } },
        @"2" : @{ @"oneLevelTitle":NSLocalizedString(@"猜两面", nil),
                  @"twoLevelDicts":@{ @"1":NSLocalizedString(@"大", nil),
                                      @"2":NSLocalizedString(@"小", nil),
                                      @"3":NSLocalizedString(@"单", nil),
                                      @"4":NSLocalizedString(@"双", nil),
                                      @"5":NSLocalizedString(@"大单", nil),
                                      @"6":NSLocalizedString(@"小单", nil),
                                      @"7":NSLocalizedString(@"大双", nil),
                                      @"8":NSLocalizedString(@"小双", nil) } },
        @"3" : @{ @"oneLevelTitle":NSLocalizedString(@"猜牛牛", nil),
                  @"twoLevelDicts":@{ @"0":NSLocalizedString(@"无牛", nil),
                                      @"1":NSLocalizedString(@"牛一", nil),
                                      @"2":NSLocalizedString(@"牛二", nil),
                                      @"3":NSLocalizedString(@"牛三", nil),
                                      @"4":NSLocalizedString(@"牛四", nil),
                                      @"5":NSLocalizedString(@"牛五", nil),
                                      @"6":NSLocalizedString(@"牛六", nil),
                                      @"7":NSLocalizedString(@"牛七", nil),
                                      @"8":NSLocalizedString(@"牛八", nil),
                                      @"9":NSLocalizedString(@"牛九", nil),
                                      @"10":NSLocalizedString(@"牛牛", nil),
                                      @"11":NSLocalizedString(@"五花牛", nil) } },
        @"4" : @{ @"oneLevelTitle":NSLocalizedString(@"猜牌面", nil),
                  @"twoLevelDicts":@{ @"1":NSLocalizedString(@"A", nil),
                                      @"2":NSLocalizedString(@"2", nil),
                                      @"3":NSLocalizedString(@"3", nil),
                                      @"4":NSLocalizedString(@"4", nil),
                                      @"5":NSLocalizedString(@"5", nil),
                                      @"6":NSLocalizedString(@"6", nil),
                                      @"7":NSLocalizedString(@"7", nil),
                                      @"8":NSLocalizedString(@"8", nil),
                                      @"9":NSLocalizedString(@"9", nil),
                                      @"10":NSLocalizedString(@"10", nil),
                                      @"11":NSLocalizedString(@"J", nil),
                                      @"12":NSLocalizedString(@"Q", nil),
                                      @"13":NSLocalizedString(@"K", nil) } }
    };
    
    NSDictionary *dictOfOneLevel = [dicts objectForKey:self.model.oneLevelType];
    if (1 == model.oneLevelType.integerValue
        || 3 == model.oneLevelType.integerValue) {
        NSDictionary *dictOfTwo = [dictOfOneLevel objectForKey:@"twoLevelDicts"];
        NSString *oneLevelTitle = [dictOfOneLevel objectForKey:@"oneLevelTitle"];
        NSString *twoLevelTitle = [dictOfTwo objectForKey:self.model.twoLevelType];
        resultTitle = [NSString stringWithFormat:@"%@/%@", oneLevelTitle,twoLevelTitle];
    } else if (2 == model.oneLevelType.integerValue
               || 4 == model.oneLevelType.integerValue) {
        NSDictionary *dictOfTwo = [dictOfOneLevel objectForKey:@"twoLevelDicts"];
        NSString *oneLevelTitle = [dictOfOneLevel objectForKey:@"oneLevelTitle"];
        NSString *twoLevelTitle = [dictOfTwo objectForKey:self.model.twoLevelType];
        NSString *pokerNum = [NSString stringWithFormat:@"%ld", self.model.pokerNum.integerValue];
        if ([[NSBundle currentLanguage] hasPrefix:@"zh"]) {
            pokerNum = [CFCSysUtil translationArabicNum:self.model.pokerNum.integerValue];
        }
        NSString *pockerNumTitle = [NSString stringWithFormat:NSLocalizedString(@"胜方第%@张", nil), pokerNum];
        resultTitle = [NSString stringWithFormat:@"%@/%@/%@", oneLevelTitle,pockerNumTitle,twoLevelTitle];
    } else {
        NSDictionary *dictOfTwo = [dictOfOneLevel objectForKey:@"twoLevelDicts"];
        NSString *oneLevelTitle = [dictOfOneLevel objectForKey:@"oneLevelTitle"];
        NSString *twoLevelTitle = [dictOfTwo objectForKey:self.model.twoLevelType];
        resultTitle = [NSString stringWithFormat:@"%@/%@", oneLevelTitle,twoLevelTitle];
    }
    return resultTitle;
}




@end

