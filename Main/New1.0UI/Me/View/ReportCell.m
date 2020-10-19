//
//  ReportCell.m
//  Project
//
//  Created by fy on 2019/1/9.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ReportCell.h"
#import "ReportFormsView.h"
@interface ReportCell ()
@end

@implementation ReportCell
//-(void)setFrame:(CGRect)frame
//{
//    frame.origin.x = 80;
//    frame.origin.y  += 0;
//    frame.size.width -= 2*frame.origin.x;
//    frame.size.height -= 0;
//    [super setFrame:frame];
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
//        make.bottom.equalTo(self.titleLabel.mas_top).offset(-7);
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.width.height.equalTo(@40);
        
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = HEXCOLOR(0xbe0036);
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImageView.mas_right).offset(5);
       make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.equalTo(@17);
    make.top.equalTo(self.iconImageView.mas_top).offset(3);
        
    }];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textColor = HEXCOLOR(0x808080);
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        
        make.height.equalTo(self.titleLabel);
    make.bottom.equalTo(self.iconImageView.mas_bottom).offset(-3);
    }];
    
    UIView* lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = TBSeparaColor;
    [self.contentView addSubview:lineView1];
    lineView1.tag = 211;
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.height.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    UIView* lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = TBSeparaColor;
    [self.contentView addSubview:lineView2];
    lineView2.tag = 212;
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.width.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-0.5);
    }];
}

+(instancetype)cellWith:(UICollectionView *)collectionView indexPath:(NSIndexPath*)indexPath{
    ReportCell *cell = (ReportCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ReportCell" forIndexPath:indexPath];
    return cell;
}

-(void)richElementsInCellWithModel:(ReportFormsItem*)item indexPath:(NSIndexPath*)indexPath{
    self.iconImageView.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.title;
    
    if ([item.title containsString:@"/"]) {
        NSArray  *array = [item.title componentsSeparatedByString:@"/"];
        if (array.count<2) {
            return;
        }
        NSString* preString = array.firstObject;
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:preString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName:HEXCOLOR(0xbe0036)}];
        
        NSString* midString = @"/";
        NSMutableAttributedString *mattributeStr = [[NSMutableAttributedString alloc] initWithString:midString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName : HEXCOLOR(0x666666)}];
        
        NSString* suffixString = array.lastObject;
        NSMutableAttributedString *attributeStr2 = [[NSMutableAttributedString alloc] initWithString:suffixString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName : HEXCOLOR(0xbe0036)}];
        
        [strAtt appendAttributedString:mattributeStr];
        [strAtt appendAttributedString:attributeStr2];
        [self.titleLabel setAttributedText: strAtt];
    }
    
    self.descLabel.text = [NSString stringWithFormat:@"%@",item.desc];
    if ([FunctionManager isEmpty:item.title]) {
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.height.equalTo(self.titleLabel); make.centerY.equalTo(self.contentView);
            
           make.centerX.equalTo(self.titleLabel);
        }];
    }
    else{
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel);

            make.height.equalTo(self.titleLabel);
            make.bottom.equalTo(self.iconImageView.mas_bottom).offset(-1);
        }];
    }
}
@end
