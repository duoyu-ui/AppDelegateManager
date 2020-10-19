//
//  SendRedPackedCell.m
//  Project
//
//  Created by Mike on 2019/2/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SelectMineNumCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRPCollectionView.h"

#define kColumn 5
#define kSpacingWidth 4
#define kTableViewMarginWidth 20
#define kBtnWidth 60

@interface SelectMineNumCell()
///虚线
@property (nonatomic , strong) UIImageView *leftLineImgView;
@property (nonatomic , strong) UIImageView *rightLineImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UILabel *moneyLabel;


@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultDataArray;
@property (nonatomic,strong) SendRPCollectionView *sendRPCollectionView;


@end

@implementation SelectMineNumCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SelectMineNumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectMineNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self initNotif];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = HexColor(@"#EDEDED");

    [self addSubview:self.titleLabel];
    [self addSubview:self.leftLineImgView];
    [self addSubview:self.rightLineImgView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(20);
    }];
    [self.leftLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.right.equalTo(self.titleLabel.mas_left).offset(-30);
    }];
    [self.rightLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.titleLabel);
           make.right.mas_equalTo(-30);
           make.height.mas_equalTo(2);
           make.left.equalTo(self.titleLabel.mas_right).offset(30);
       }];
    CGSize size = CGSizeMake(kBtnWidth-15, kBtnWidth-15);
    [self addSubview:self.noButton];
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 - kSendRPTitleCellWidth - kBtnWidth  - (kColumn + 1) * kSpacingWidth) / kColumn;
    CGFloat height = itemWidth * 2 + kSpacingWidth * 3;

    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc]init];
    sendRPCollectionView.collectionView.allowsMultipleSelection = YES;
    sendRPCollectionView.tag = 99;
    sendRPCollectionView.selectNumCollectionViewBlock = ^{
        if (self.selectNumBlock) {
            self.selectNumBlock(self.sendRPCollectionView.collectionView.indexPathsForSelectedItems);
        }
    };
    sendRPCollectionView.selectMoreMaxCollectionViewBlock = ^{
        if (self.selectMoreMaxBlock) {
            self.selectMoreMaxBlock(YES);
        }
    };
    sendRPCollectionView.cellBackgroundColor = [UIColor whiteColor];
    [self addSubview:sendRPCollectionView];
    [sendRPCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(kSendRPTitleCellWidth-20);
        make.height.mas_equalTo(height + 30);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.6);
    }];
    _sendRPCollectionView = sendRPCollectionView;
    
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendRPCollectionView.mas_right).offset(10);
        make.centerY.equalTo(sendRPCollectionView.mas_centerY);
        make.size.mas_equalTo(size);
    }];
    
    
 
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sendRPCollectionView.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 8;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:13];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = HexColor(@"#E16754");
    [submitBtn setTitle:NSLocalizedString(@"塞钱进红包", nil) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_sendRedpacked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    [submitBtn delayEnable];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.4, 45));
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}


- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    UITextField *textFieldObj = (UITextField *)notiObject.object;
    NSInteger mObjectInte = [textFieldObj.text integerValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld.0",mObjectInte];
    self.money = textFieldObj.text;

}



/**
 设置颜色为背景图片
 
 @param color <#color description#>
 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)action_sendRedpacked {
    if (self.mineCellSubmitBtnBlock) {
        self.mineCellSubmitBtnBlock(self.money);
    }
}

- (void)onNoButton:(UIButton *)btn {
    btn.selected = !btn.selected;

//    if (btn.selected) {
//        self.noButton.backgroundColor = HexColor(@"#E16754");
//        [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    } else {
//        self.noButton.backgroundColor = HexColor(@"#FFFFFF");
//        [self.noButton setTitleColor:HexColor(@"#6B6B6B") forState:UIControlStateNormal];
//    }
    
    if (self.selectNoPlayingBlock) {
        self.selectNoPlayingBlock(btn.selected);
    }
}


- (void)setModel:(id)model {
    
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    self.sendRPCollectionView.model = self.resultDataArray;

    if (self.money == nil || [self.money isEqual:[NSNull null]]) {
        self.money = @"0";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%@.0", self.money];
    
}

- (void)setIsBtnDisplay:(BOOL)isBtnDisplay {
    self.noButton.selected = !isBtnDisplay;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftLineImgView.image = [self drawLineOfDashByImageView:self.leftLineImgView];
    self.rightLineImgView.image = [self drawLineOfDashByImageView:self.rightLineImgView];
}
- (UIButton *)noButton{
    if (!_noButton) {
        _noButton = [UIButton new];
        _noButton.layer.cornerRadius = (kBtnWidth-15)/2;
        _noButton.layer.masksToBounds = YES;
        _noButton.backgroundColor = HexColor(@"#E16754");
        [_noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_noButton setTitle:NSLocalizedString(@"不", nil) forState:UIControlStateNormal];
        [_noButton setTitle:NSLocalizedString(@"雷", nil) forState:UIControlStateSelected];
        [_noButton addTarget:self action:@selector(onNoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noButton;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:43];
        _moneyLabel.textColor = HexColor(@"#181818");
        _moneyLabel.text = @"0.0";
    }
    return _moneyLabel;;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = NSLocalizedString(@"选择埋雷数字", nil);
        _titleLabel.textColor = HexColor(@"#333333");
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;;
}
- (UIImageView *)leftLineImgView{
    if (!_leftLineImgView) {
        _leftLineImgView = [[UIImageView alloc]init];
    }
    return _leftLineImgView;
}
- (UIImageView *)rightLineImgView{
    if (!_rightLineImgView) {
        _rightLineImgView = [[UIImageView alloc]init];
    }
    return _rightLineImgView;
}
/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);

    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];

    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();

    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {4,4};

    CGContextSetStrokeColorWithColor(line, HexColor(@"#C2C2C2").CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);

    CGContextMoveToPoint(line, 0.0, 2.0);

    CGContextAddLineToPoint(line, 300, 2.0);

    CGContextStrokePath(line);

    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
-(void)setMaxNum:(NSInteger)maxNum{
    _maxNum = maxNum;
    _sendRPCollectionView.maxNum = maxNum;
}
@end


