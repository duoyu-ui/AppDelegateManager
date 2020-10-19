//
//  FYGameJSSLHeadRecordView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameJSSLHeadRecordView.h"
#import "FYJSSLRecordData.h"
#import "FYJSSLLeiNumView.h"
#import "FYJJSLRecordHudView.h"
@interface FYGameJSSLHeadRecordView()
@property (nonatomic , strong) UILabel *gameNumberLab;
@property (nonatomic , strong) NSArray<FYJSSLRecordData*> *lists;
@property (nonatomic , strong) UILabel *leiDianLab;
@property (nonatomic , strong) UIButton *hubBtn;
@property (nonatomic , strong) NSMutableArray<FYJSSLLeiNumView*> *leiNumView;
@end
@implementation FYGameJSSLHeadRecordView
- (void)setChatId:(NSString *)chatId{
    _chatId = chatId;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslGameHistory parameters:@{
        @"chatId": chatId,
        @"userId": [AppModel shareInstance].userInfo.userId
    } success:^(id object) {
        self.lists = [FYJSSLRecordData mj_objectArrayWithKeyValuesArray:[object mj_JSONObject][@"data"]];
    } failure:^(id object) {
    }];
}
- (void)setLists:(NSArray<FYJSSLRecordData *> *)lists{
    _lists = lists;
    FYJSSLRecordData *data = lists.firstObject;
    self.gameNumberLab.text = [NSString stringWithFormat:@"%zd",data.gameNumber];
    [self.leiNumView enumerateObjectsUsingBlock:^(FYJSSLLeiNumView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0://万
                view.numLab.text = [NSString stringWithFormat:@"%zd",data.myriad];
                view.imgView.image = [UIImage imageNamed:@"jssl_wan_icon_sel"];
                break;
            case 1:
                view.numLab.text = [NSString stringWithFormat:@"%zd",data.thousand];
                view.imgView.image = [UIImage imageNamed:@"jssl_qian_icon_sel"];
                break;
            case 2:
                view.numLab.text = [NSString stringWithFormat:@"%zd",data.hundred];
                view.imgView.image = [UIImage imageNamed:@"jssl_bai_icon_sel"];
                break;
            case 3:
                view.numLab.text = [NSString stringWithFormat:@"%zd",data.ten];
                view.imgView.image = [UIImage imageNamed:@"jssl_shi_icon_sel"];
                break;
            case 4:
                view.numLab.text = [NSString stringWithFormat:@"%zd",data.individual];
                view.imgView.image = [UIImage imageNamed:@"jssl_ge_icon_sel"];
                break;
            default:
                break;
        }
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.gameNumberLab];
    [self addSubview:self.leiDianLab];
    [self addSubview:self.hubBtn];
    [self.gameNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(20));
    }];
    [self.leiDianLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.gameNumberLab.mas_right).offset(25);
    }];
    [self.hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(self.mas_height);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    for (int i = 0; i < 5; i++) {
        FYJSSLLeiNumView *numView = [[FYJSSLLeiNumView alloc]init];
        [self addSubview:numView];
        [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(30));
            make.centerY.equalTo(self);
            make.left.equalTo(self.leiDianLab.mas_right).offset(15 + i * 35);
        }];
        [self.leiNumView addObj:numView];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadUnder)];
    [self addGestureRecognizer:tapGesture];
}
- (void)downloadUnder{
    [FYJJSLRecordHudView showJSSLRecordWithData:self.lists];
}
#pragma mark - 懒加载
- (UILabel *)gameNumberLab{
    if (!_gameNumberLab) {
        _gameNumberLab = [[UILabel alloc]init];
        _gameNumberLab.textColor = HexColor(@"#333333");
        _gameNumberLab.font = FONT_PINGFANG_REGULAR(14);
    }
    return _gameNumberLab;
}
- (UILabel *)leiDianLab{
    if (!_leiDianLab) {
        _leiDianLab = [[UILabel alloc]init];
        _leiDianLab.textColor = HexColor(@"#333333");
        _leiDianLab.font = FONT_PINGFANG_REGULAR(14);
        _leiDianLab.text = NSLocalizedString(@"雷点", nil);
    }
    return _leiDianLab;
}
- (UIButton *)hubBtn{
    if (!_hubBtn) {
        _hubBtn = [[UIButton alloc]init];
        [_hubBtn setImage:[UIImage imageNamed:@"download_under_icon"] forState:UIControlStateNormal];
        [_hubBtn addTarget:self action:@selector(downloadUnder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hubBtn;
}
- (NSMutableArray<FYJSSLLeiNumView *> *)leiNumView{
    if (!_leiNumView) {
        _leiNumView = [NSMutableArray<FYJSSLLeiNumView*> array];
    }
    return _leiNumView;
}
@end
