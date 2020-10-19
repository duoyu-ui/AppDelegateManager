//
//  FYMessagelLayoutModel.m
//  Project
//
//  Created by Mike on 2019/4/1.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYMessagelLayoutModel.h"
#import "SSChatDatas.h"
#import "SSChatIMEmotionModel.h"
#import "NSObject+SSAdd.h"
#import "FYMessage.h"
#import "EnvelopeMessage.h"


@implementation FYMessagelLayoutModel

//根据模型返回布局
-(instancetype)initWithMessage:(FYMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}


-(void)setMessage:(FYMessage *)message {
    _message = message;
    
    if ((message.messageType == FYMessageTypeImage && message.messageFrom == FYChatMessageFromSystem) || (message.messageType == FYMessageTypeVoice && message.messageFrom == FYChatMessageFromSystem) ||(message.messageType == FYMessageTypeVideo && message.messageFrom == FYChatMessageFromSystem)) {
        [self setSystemMessage];
        return;
    }
    
    switch (message.messageType) {
        case FYMessageTypeText:
        case FYMessageTypeReportAwardInfo:
            [self setText];
            [self setCommonView];
            break;
        case FYMessageTypeRedEnvelope:
            [self setRedEnvelope];
            [self setCommonView];
            break;
        case FYMessageTypeNoticeRewardInfo:
            [self setCowCowRewardInfo];
            break;
        case FYMessageTypeImage:
            [self setImage];
            [self setCommonView];
            break;
        case FYMessageTypeVoice:
            [self setVoice];
            [self setCommonView];
            break;
        case FYMessageTypeMap:
            [self setMap];
            [self setCommonView];
            break;
        case FYMessageTypeVideo:
            [self setVideo];
            [self setCommonView];
            break;
            
        case FYMessageTypeUndo:
            [self setRecallMessage];
            [self setCommonView];
            break;
        case FYMessageTypeNotice: //提示
            [self robNNMessegeNotice:message];
            break;
        case FYMessageTypeRob://抢庄
            [self setCommonView];
            
            CGFloat timeHeight = (message.showTime == YES ? (SSChatTimeHeight + SSChatTimeTopOrBottom * 2) : 0);
            
            _cellHeight = self.headerImgRect.size.height + timeHeight + 35;
            break;
        case FYMessageTypeRobReport://抢庄报奖
            [self robNiuNiuReport:message];
            break;
        case FYMessageTypeBett://投注
        case FYMessageTypeBagLotteryBet:
        case FYMessageTypeBagBagCowBet:
        case FYMessageTypeBestNiuNiuBett:
            [self setCommonView];
            [self messageBett];
            break;
        case FYMessageTypeDelete:
            [self setRemoveMessage];
            [self setCommonView];
            break;
        case FYMessageTypeSystemWin:
            if (_message.showTime == YES){
                  _cellHeight = 160 + SSChatTimeHeight + SSChatTimeTopOrBottom * 2;
              }else{
                  _cellHeight = 160;
              }
            break;
        case FYMessageTypeRobNiuNiu:
            [self setRobNiuNiuWin:message];
            break;
        case FYMessageTypeRopPrompt:
        {
            NSDictionary *dict = [_message.text mj_JSONObject];
            if ([dict[@"type"] integerValue] == 1) {
                _cellHeight = 225;
            }else if ([dict[@"type"] integerValue] == 2){
                _cellHeight = 115;
            }else if ([dict[@"type"] integerValue] == 3){
                _cellHeight = 225;
            }else if ([dict[@"type"] integerValue] == 4){
                _cellHeight = 135;
            }else if ([dict[@"type"] integerValue] == 5){
                _cellHeight = 165;
            }else if ([dict[@"type"] integerValue] == 6){
                _cellHeight = 165;
            }else if ([dict[@"type"] integerValue] == 7){
                _cellHeight = 185;
            }else if ([dict[@"type"] integerValue] == 8){
                _cellHeight = 135;
            }else if ([dict[@"type"] integerValue] == 9){
                _cellHeight = 215;
            }else if ([dict[@"type"] integerValue] == 40){
                _cellHeight = 205;
            }else if ([dict[@"type"] integerValue] == 14){//百人牛牛
                _cellHeight = 205;
            }
        }
            break;
        case FYMessageTypeGunControlWin:
            _cellHeight = 260;
            break;
        case FYMessageTypeDeminingWin:
        case FYMessageTypeSuperDemining:
            [self deminingWin:message];
            break;
        case FYMessageTypeNiuNiu:
        case FYMessageTypeTwoNiuNiu:
            [self setNiuNiu:message];
            break;
        case FYMessageTypeJieLong:
            [self setJieLongWin:message];
            break;
        case FYMessageTypeBagBagCowWin:
            [self setBagBagCowWin:message];
            break;
        case FYMessageTypeBagLotteryResults:
            [self setBagLotteryResults:message];
            break;
            
        default:
            break;
    }
}
- (void)setBagBagCowWin:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = (NSArray*)dict[@"data"];
    _cellHeight = arr.count * 20 + 165;
}
- (void)setBagLotteryResults:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = (NSArray*)dict[@"data"][@"open"];
    _cellHeight = arr.count * 20 + 185;
}
///接龙报奖高度计算
- (void)setJieLongWin:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = (NSArray*)dict[@"grabList"];
    _cellHeight = arr.count * 20 + 145;
}
///抢庄牛牛报奖
- (void)setRobNiuNiuWin:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = dict[@"data"];
    _cellHeight = (arr.count * 20) + 208;
}
///牛牛
- (void)setNiuNiu:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = (NSArray*)dict[@"grabList"];
    _cellHeight = arr.count * 20 + 212;
}
///扫雷报奖
- (void)deminingWin:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = (NSArray*)dict[@"grabList"];
    _cellHeight = arr.count * 20 + 198;
}
//抢庄报奖
- (void)robNiuNiuReport:(FYMessage *)message{
    NSDictionary *dict = [message.text mj_JSONObject];
    NSArray *arr = dict[@"data"];
    _cellHeight = (arr.count * 30) + 170;
    
}
//投注
- (void)messageBett{
    if (_message.showTime == YES){
        _cellHeight = 80 + SSChatTimeHeight + SSChatTimeTopOrBottom * 2;
    }else{
        _cellHeight = 80;
    }
}

//牛牛提示信息
- (void)robNNMessegeNotice:(FYMessage*)message{
    CGFloat timeH = 0;
    if (_message.showTime == YES){
        timeH = SSChatTimeHeight + SSChatTimeTopOrBottom * 2;
    }
    if (message.nnMessageModel.type == SolitaireGameAward) {
        _cellHeight = 55 + timeH;
    }else if (message.nnMessageModel.type == RobNiuNiuTypeSaoLeiResult){
        _cellHeight = 55 + timeH;
    }else{
        _cellHeight = 35 + timeH;
    }
}

#pragma mark - 公共部分
- (void)setCommonView {
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _nickNameRect = CGRectMake(FYChatIconLeftOrRight*2 + SSChatIconWH,SSChatCellTopOrBottom, FYChatNameWidth, FYChatNameSpacingHeight-4);
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _nickNameRect = CGRectMake(0,0, 0, 0);
    }
    
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom * 2 + SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        CGRect userRect = self.nickNameRect;
        userRect.origin.y = SSChatTimeTopOrBottom * 2 + SSChatTimeHeight;
        self.nickNameRect = userRect;
        
        CGFloat bubbleY;
        if(_message.messageFrom == FYMessageDirection_RECEIVE){
            bubbleY = _nickNameRect.origin.y + FYChatNameSpacingHeight;
        } else {
            bubbleY = _nickNameRect.origin.y;
        }
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, bubbleY, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
        
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + 10;
    
}

#pragma mark - 红包
- (void)setRedEnvelope
{
//    FYRedEnvelopeType redEnveType = _message.redEnvelopeMessage.type;
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        //红包图片宽676 高234
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*(234.0 / 676.0));
//        if (redEnveType == FYRedEnvelopeType_Fu) {
//        } else if (redEnveType == FYRedEnvelopeType_Cow || redEnveType == FYRedEnvelopeType_ErRenNN) {
//             _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*0.3946188f);
//        } else {
//            _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*0.42f);
//        }
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _textLabRect.origin.x = SSChatTextLRB;
        _textLabRect.origin.y = SSChatTextTop;
        
    } else {
        
        _bubbleBackViewRect = CGRectMake( SSChatIcon_RX - FYRedEnvelopeBackWidth - FYChatIconLeftOrRight, SSChatCellTopOrBottom, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*(234.0 / 676.0));
//        if (redEnveType == FYRedEnvelopeType_Fu) {
//        } else if (redEnveType == FYRedEnvelopeType_Cow || redEnveType == FYRedEnvelopeType_ErRenNN) {
//             _bubbleBackViewRect = CGRectMake( SSChatIcon_RX - FYRedEnvelopeBackWidth - FYChatIconLeftOrRight, SSChatCellTopOrBottom, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*0.3946188f);
//        } else {
//            _bubbleBackViewRect = CGRectMake( SSChatIcon_RX - FYRedEnvelopeBackWidth - FYChatIconLeftOrRight, SSChatCellTopOrBottom, FYRedEnvelopeBackWidth, FYRedEnvelopeBackWidth*0.42f);
//        }
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _textLabRect.origin.x = SSChatTextLRS;
        _textLabRect.origin.y = SSChatTextTop;
    }
}

#pragma mark - 文本
-(void)setText {
    
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, 0, SSChatTextInitWidth, 100);
    mTextView.attributedText = _message.attTextString;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
    
    _textLabRect = mTextView.bounds;// [NSObject getRectWith:_message.attTextString width:SSChatTextInitWidth];
    
    CGFloat textWidth  = _textLabRect.size.width;
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        _textLabRect.origin.x = SSChatTextLRB;
        _textLabRect.origin.y = SSChatTextTop;
        
    } else {
        
        //        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatTextLRB-textWidth-SSChatTextLRS, SSChatCellTopOrBottom +FYChatNameSpacingHeight, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatTextLRB-textWidth-SSChatTextLRS, SSChatCellTopOrBottom, textWidth+SSChatTextLRB+SSChatTextLRS, textHeight+SSChatTextTop+SSChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _textLabRect.origin.x = SSChatTextLRS;
        _textLabRect.origin.y = SSChatTextTop;
    }
    
}

#pragma mark - 牛牛报奖信息
-(void)setCowCowRewardInfo {
    
    NSInteger height = 20 + 10;
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    if(_message.showTime == YES) {
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
    }

    _cellHeight = _timeLabRect.origin.y + SSChatTimeHeight + SSChatTimeTopOrBottom +  + CowBackImageHeight + height;
}

#pragma mark - 系统消息
-(void)setSystemMessage {
    
    _cellHeight =  30;
    
}
#pragma mark - 语音消息
-(void)setVoice{
    if (_message.isReceivedMsg) {
        NSDictionary *dict = [_message.text mj_JSONObject];
        _message.voiceTime = [NSString stringWithFormat:@"%@",dict[@"time"]];
        _message.voiceDuration = [dict[@"time"] integerValue];
        _message.voiceRemotePath = [NSString stringWithFormat:@"%@",dict[@"url"]];
    }
   
    //计算时间
    CGRect rect = [NSObject getRectWith:_message.voiceTime width:150 font:[UIFont systemFontOfSize:SSChatVoiceTimeFont] spacing:0 Row:0];
    CGFloat timeWidth  = rect.size.width;
    CGFloat timeHeight = rect.size.height;
    
    //根据时间设置按钮实际长度
    CGFloat timeLength = SSChatVoiceMaxWidth - SSChatVoiceMinWidth;
    CGFloat changeLength = timeLength/60;
    CGFloat currentLength = changeLength*_message.voiceDuration+SSChatVoiceMinWidth;
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);

        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y + 20, currentLength, SSChatVoiceHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);

        _voiceImgRect = CGRectMake(20, (_bubbleBackViewRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
        _voiceTimeLabRect = CGRectMake(20 + SSChatVoiceImgSize, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth + 10, timeHeight);
        
    }else{
        
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-currentLength, self.headerImgRect.origin.y, currentLength, SSChatVoiceHeight);
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
        _voiceImgRect = CGRectMake(_bubbleBackViewRect.size.width-SSChatVoiceImgSize-20, (_bubbleBackViewRect.size.height-SSChatVoiceImgSize)/2, SSChatVoiceImgSize, SSChatVoiceImgSize);
        _voiceTimeLabRect = CGRectMake(_bubbleBackViewRect.size.width - SSChatVoiceImgSize - 20 - timeWidth - 10, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth + 10, timeHeight);
        
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom + 10;
    NSLog(@"_cellHeight:%lf",_cellHeight);
}


#pragma mark - 图片消息
-(void)setImage {
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (_message.isReceivedMsg) {
         NSDictionary *imageDict = (NSDictionary *)[_message.text mj_JSONObject];
        imgWidth  = [imageDict[@"width"] floatValue];
        imgHeight = [imageDict[@"height"] floatValue];
    } else {
        if ([self isEqualImageUrl:_message.imageUrl]) {
            NSDictionary *size = [self setupImageShowSize:_message.text];
            if (size != nil) {
                imgWidth = [size[@"width"] floatValue];
                imgHeight = [size[@"height"] floatValue];
            }
        }else {
            imgWidth = [_message.selectPhoto[@"width"] floatValue];
            imgHeight = [_message.selectPhoto[@"height"] floatValue];
        }
    }
    
    CGSize realImageSize = CGSizeMake(imgWidth, imgHeight);
    
    
    if (imgWidth == 0) {
        imgWidth = 100;
    }
    if (imgHeight == 0) {
        imgHeight = 100;
    }
    CGSize imageSize = [self contentSize:SCREEN_WIDTH size:realImageSize];
    
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, SSChatCellTopOrBottom + FYChatNameSpacingHeight, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight- imageSize.width, self.headerImgRect.origin.y, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom;
    
}


/// 检测是否有图片资源
- (BOOL)isEqualImageUrl:(NSString *)url {
    if ([NSString isBlankString:url]) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)setupImageShowSize:(NSString *)text {
    if ([NSString isBlankString:text]) {
        return nil;
    }
    
    NSMutableDictionary *size = [NSMutableDictionary dictionary];
    NSDictionary *JSONData = [text mj_JSONObject];
    if (JSONData[@"url"]) {
        NSString *width = JSONData[@"width"];
        NSString *height = JSONData[@"height"];
        [size setObject:width forKey:@"width"];
        [size setObject:height forKey:@"height"];
    }
    return size;
}


- (CGSize)contentSize:(CGFloat)cellWidth size:(CGSize)size
{
    CGFloat attachmentImageMinWidth  = (cellWidth / 4.0);
    CGFloat attachmentImageMinHeight = (cellWidth / 4.0);
    CGFloat attachmemtImageMaxWidth  = (cellWidth - 184);
    CGFloat attachmentImageMaxHeight = (cellWidth - 184);
    
    
    CGSize imageSize;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        imageSize = size;
    }
    else
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_message.imageUrl]]];
        //        UIImage *image = [UIImage imageWithContentsOfFile:_message.imageUrl];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize contentSize = [self sizeWithImageOriginSize:imageSize
                                               minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                               maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight )];
    return contentSize;
}


- (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}


-(void)setMap{
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-SSChatMapWidth, self.headerImgRect.origin.y, SSChatMapWidth, SSChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
        
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + SSChatCellTopOrBottom;
    
}

//短视频
-(void)setVideo{
 
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    if (_message.isReceivedMsg) {
        NSDictionary *imageDict = (NSDictionary *)[_message.text mj_JSONObject];
        imgWidth  = [imageDict[@"width"] floatValue];
        imgHeight = [imageDict[@"height"] floatValue];
    } else {
        if ([self isEqualImageUrl:_message.videoRemotePath]) {
            NSDictionary *size = [self setupImageShowSize:_message.text];
            if (size != nil) {
                imgWidth = [size[@"width"] floatValue];
                imgHeight = [size[@"height"] floatValue];
            }
        }else {
            imgWidth = [_message.selectVideo[@"width"] floatValue];
            imgHeight = [_message.selectVideo[@"height"] floatValue];
        }
    }
      
      if (imgWidth == 0) {
          imgWidth = 100;
      }
      if (imgHeight == 0) {
          imgHeight = 100;
      }
    CGFloat imgActualHeight = SSChatVideoWidth;
    CGFloat imgActualWidth =  SSChatVideoWidth * imgWidth/imgHeight;
    
    if(imgActualWidth>SSChatVideoWidth){
        imgActualWidth = SSChatVideoWidth;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    
    if(_message.messageFrom == FYMessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(FYChatIconLeftOrRight,SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(FYChatIconLeftOrRight+SSChatIconWH+FYChatIconLeftOrRight, self.headerImgRect.origin.y+ 20,imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRB, SSChatAirBottom, SSChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(SSChatIcon_RX, SSChatCellTopOrBottom, SSChatIconWH, SSChatIconWH);
        
        _bubbleBackViewRect = CGRectMake(SSChatIcon_RX-SSChatDetailRight-imgActualWidth, self.headerImgRect.origin.y + 20, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(SSChatAirTop, SSChatAirLRS, SSChatAirBottom, SSChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(FYSCREEN_Width/2-100, SSChatTimeTopOrBottom, 200, SSChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = SSChatTimeTopOrBottom+SSChatTimeTopOrBottom+SSChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + SSChatCellTopOrBottom + 20;
    
}



//显示支付定金订单信息
-(void)setOrderValue1{
    
    
}

//显示直接购买订单信息
-(void)setOrderValue2{
    
    
}


//撤销的消息
-(void)setRecallMessage{
    
    
}


//删除的消息
-(void)setRemoveMessage{
    
    
    
}







@end
