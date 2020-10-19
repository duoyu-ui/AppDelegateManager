//
//  SendRPNumTableViewCell.m
//  Project
//
//  Created by Mike on 2019/3/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SendRPNumTableViewCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRPCollectionView.h"

#define kColumn 5
#define kSpacingWidth 4
#define kTableViewMarginWidth 30
#define kBtnWidth 60

@interface SendRPNumTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *unitLabel;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultDataArray;
@property (nonatomic,strong) SendRPCollectionView *sendRPCollectionView;


@end

@implementation SendRPNumTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRPNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRPNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        //        [self initSubviews];
    }
    return self;
}
- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor{
    if (cellBackgroundColor != nil) {
        _sendRPCollectionView.cellBackgroundColor = cellBackgroundColor;
    }
}

- (void)setupUI {
    
    self.backgroundColor = HexColor(@"#EDEDED");
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(self.mas_left).offset(30);
        make.center.mas_equalTo(self);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = NSLocalizedString(@"红包个数", nil);
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = HexColor(@"#333333");
    [backView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    _unitLabel = [UILabel new];
    _unitLabel.text = NSLocalizedString(@"包", nil);
    _unitLabel.font = [UIFont systemFontOfSize2:16];
    _unitLabel.textColor = HexColor(@"#333333");
    [backView addSubview:_unitLabel];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 - kSendRPTitleCellWidth - kBtnWidth - (kColumn + 1) * kSpacingWidth) / kColumn;
    
    CGFloat height = itemWidth * 1 + kSpacingWidth * 2;
    CGFloat frameHeight = (CD_Scal(60, 812) - height) / 2;
//    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc] initWithFrame:CGRectMake(kSendRPTitleCellWidth, frameHeight, [UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 -kSendRPTitleCellWidth - kBtnWidth, height)];
    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc] init];
    
    sendRPCollectionView.collectionView.allowsMultipleSelection = NO;
    sendRPCollectionView.selectNumCollectionViewBlock = ^{
        if (self.selectNumBlock) {
            self.selectNumBlock(self.sendRPCollectionView.collectionView.indexPathsForSelectedItems);
        }
    };
    [backView addSubview:sendRPCollectionView];
    [sendRPCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(backView);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.right.equalTo(_unitLabel.mas_left).offset(-10);
    }];
    _sendRPCollectionView = sendRPCollectionView;
    
    
}


- (void)setModel:(id)model {
    
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    self.sendRPCollectionView.model = self.resultDataArray;
    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



