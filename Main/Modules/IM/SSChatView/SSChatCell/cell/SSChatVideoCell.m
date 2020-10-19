//
//  SSChatVideoCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatVideoCell.h"
#import <GMenuController/GMenuController.h>
#import "FYVideoTool.h"
@interface SSChatVideoCell()
@property (nonatomic , strong) NSArray *arr;
@end
@implementation SSChatVideoCell


-(void)initChatCellUI{
    
    [super initChatCellUI];
   
    
    self.mImgView = [UIImageView new];
    self.mImgView.layer.cornerRadius = 5;
    self.mImgView.layer.masksToBounds  = YES;
    self.mImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.mImgView.backgroundColor = [UIColor whiteColor];
    [self.bubbleBackView addSubview:self.mImgView];
    self.mImgView.userInteractionEnabled = YES;
    
    self.mVideoImg = [UIImageView new];
    self.mVideoImg.bounds = CGRectMake(0, 0, 40, 40);
    [self.mImgView addSubview:self.mVideoImg];
    self.mVideoImg.image = [UIImage imageNamed:@"icon_bofang"];
    self.mVideoImg.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    [self.bubbleBackView addGestureRecognizer:gr];
    GMenuItem *item = [[GMenuItem alloc] initWithTitle:NSLocalizedString(@"删除", nil) target:self action:@selector(onDeleteMessage)];
    self.arr = @[item];
    
}
///长按删除
- (void)longPress:(UILongPressGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGRect rect = [gestureRecognizer view].frame;
        [[GMenuController sharedMenuController] setMenuItems:self.arr];
        [[GMenuController sharedMenuController] setTargetRect:rect inView:self.contentView];
        [[GMenuController sharedMenuController] setMenuVisible:YES];
        
    }
}
- (void)onDeleteMessage{
    [[GMenuController sharedMenuController] setMenuVisible:NO];
     if(self.delegate && [self.delegate respondsToSelector:@selector(onDeleteMessageCell:indexPath:)]){
          [self.delegate onDeleteMessageCell:self.model.message indexPath:self.indexPath];
      }
}

-(void)setModel:(FYMessagelLayoutModel *)model{
    
    [super setModel:model];
    
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
    self.mImgView.frame = self.bubbleBackView.bounds;
    if (model.message.isReceivedMsg) {
        self.errorBtn.hidden = YES;
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:model.message.videoRemotePath]];
        self.mImgView.image = [FYVideoTool getImageWithAsset:asset];
    } else {
        if (model.message.videoimgData != nil) {
            self.errorBtn.hidden = YES;
            self.mImgView.image = [UIImage imageWithData:model.message.videoimgData];
        }else {
            if ([self isEqualVideoUrl:model.message.videoRemotePath]) {
                self.errorBtn.hidden = YES;
                [self handleJSONWithVideoData:model.message.text];
            }
        }
    }
    //给图片设置一个描边 描边跟背景按钮的气泡图片一样
    UIImageView *btnImgView = [[UIImageView alloc]initWithImage:image];
    btnImgView.frame = CGRectInset(self.mImgView.frame, 0.0f, 0.0f);
    self.mImgView.layer.mask = btnImgView.layer;
    self.mVideoImg.center = self.mImgView.center;
    
    // 消息加载状态
    BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
    [self.traningActivityIndicator setHidden:isActivityIndicatorHidden];
    if (isActivityIndicatorHidden) {
        [self.traningActivityIndicator stopAnimating];
    } else {
        [self.traningActivityIndicator startAnimating];
        [self layoutActivityIndicator];
    }
    
    if (model.message.deliveryState == FYMessageDeliveryStateFailed) {
        [self layoutErrorBtn];
    } else {
        self.errorBtn.hidden = YES;
    }
}


/// 检测是否有图片资源
- (BOOL)isEqualVideoUrl:(NSString *)url {
    if ([NSString isBlankString:url]) {
        return YES;
    }
    return NO;
}

- (void)handleJSONWithVideoData:(NSString *)json {
    if ([NSString isBlankString:json]) {
        return;
    }
    
    NSDictionary *JSONData = [json mj_JSONObject];
    if (![self isEqualVideoUrl:JSONData[@"url"]]) {
        NSString *videoUrl = JSONData[@"url"];
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoUrl]];
        self.mImgView.image = [FYVideoTool getImageWithAsset:asset];
    }
}

- (void)layoutErrorBtn
{
    CGFloat centerX = 0;
    if ((self.model.message.messageFrom == FYMessageDirection_SEND))
    {
        centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
        self.errorBtn.center = CGPointMake(centerX,
                                           self.bubbleBackView.center.y);
        self.errorBtn.hidden = NO;
        [self.traningActivityIndicator stopAnimating];
    }
}

- (void)layoutActivityIndicator
{
    if (self.traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        if ((self.model.message.messageFrom == FYMessageDirection_SEND))
        {
            centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
            self.traningActivityIndicator.center = CGPointMake(centerX,
                                                               self.bubbleBackView.center.y);
        }
    }
}

- (BOOL)activityIndicatorHidden
{
    if (self.model.message.isReceivedMsg)
    {
        return self.model.message.deliveryState != FYMessageDeliveryStateDelivering;
    }
    return NO;
}


// 点击消息背景事件
-(void)bubbleBackViewAction:(UIImageView *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatImageVideoCellIndexPatch:layout:)]){
        [self.delegate didChatImageVideoCellIndexPatch:self.indexPath layout:self.model];
    }
}

@end
@implementation SSChatVideoContent
@end
