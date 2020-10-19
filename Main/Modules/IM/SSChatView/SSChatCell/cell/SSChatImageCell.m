//
//  SSChatImageCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/12.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatImageCell.h"

@implementation SSChatImageCell

-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
}

-(void)initSubviews {
    
    self.errorBtn.hidden = YES;
    
    self.mImgView = [UIImageView new];
    self.mImgView.layer.cornerRadius = 5;
    self.mImgView.layer.masksToBounds = YES;
    self.mImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.mImgView.backgroundColor = [UIColor whiteColor];
    [self.bubbleBackView addSubview:self.mImgView];
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.mImgView setUserInteractionEnabled:YES];
    [self.mImgView addGestureRecognizer:gr];
    
}

- (void)longPress:(UILongPressGestureRecognizer *) gestureRecognizer {
    NSLog(@"longPress");
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        CGRect rect = [gestureRecognizer view].frame;
        
        UIMenuItem *peiMenuItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"删除", nil) action:@selector(onDeleteMessage:)];
        UIMenuItem *withdrawItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"撤回", nil) action:@selector(withdrawMessage:)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:@[peiMenuItem,withdrawItem]];

        NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);

        //        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setTargetRect:CGRectMake(rect.size.width/2, 10.f, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)copy:(id) sender {
    // called when copy clicked in menu
}


- (BOOL)canBecomeFirstResponder {
    NSLog(@"canBecomeFirstResponder");
    return YES;
}

- (void)addMenuItemView {
    UIMenuItem *peiMenuItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"删除", nil) action:@selector(onDeleteMessage:)];
    UIMenuItem *withdrawItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"撤回", nil) action:@selector(withdrawMessage:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[peiMenuItem,withdrawItem]];
}



-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) || action == @selector(onDeleteMessage:) || action == @selector(withdrawMessage:)) {
        if (action == @selector(withdrawMessage:) && self.model.message.messageFrom == FYMessageDirection_RECEIVE) {
            if([AppModel shareInstance].userInfo.managerFlag || [AppModel shareInstance].userInfo.groupowenFlag || [AppModel shareInstance].userInfo.innerNumFlag){
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}


- (void)onDeleteMessage:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDeleteMessageCell:indexPath:)]){
        [self.delegate onDeleteMessageCell:self.model.message indexPath:self.indexPath];
    }
}


- (void)withdrawMessage:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onWithdrawMessageCell:)]){
        [self.delegate onWithdrawMessageCell:self.model.message];
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
        [self.mImgView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.message.imageUrl]] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    } else {
        if (model.message.selectPhoto[@"image"] != nil) {
            self.errorBtn.hidden = YES;
            self.mImgView.image = (UIImage *)model.message.selectPhoto[@"image"];
        }else {
            if ([self isEqualImageUrl:model.message.imageUrl]) {
                self.errorBtn.hidden = YES;
                [self handleJSONWithImageData:model.message.text];
            }
        }
    }
        
    //给图片设置一个描边 描边跟背景按钮的气泡图片一样
    UIImageView *btnImgView = [[UIImageView alloc]initWithImage:image];
    btnImgView.frame = CGRectInset(self.mImgView.frame, 0.0f, 0.0f);
    self.mImgView.layer.mask = btnImgView.layer;
    
    // 消息加载状态
    BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
    NSLog(@"%@",isActivityIndicatorHidden ? @"YES": @"NO");
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
- (BOOL)isEqualImageUrl:(NSString *)url {
    if ([NSString isBlankString:url]) {
        return YES;
    }
    return NO;
}

- (void)handleJSONWithImageData:(NSString *)json {
    if ([NSString isBlankString:json]) {
        return;
    }
    
    NSDictionary *JSONData = [json mj_JSONObject];
    if (![self isEqualImageUrl:JSONData[@"url"]]) {
        NSString *imageUrl = JSONData[@"url"];
        [self.mImgView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:imageUrl]] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
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


//点击展开图片
-(void)buttonPressed:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatImageVideoCellIndexPatch:layout:)]){
        [self.delegate didChatImageVideoCellIndexPatch:self.indexPath layout:self.model];
    }
}

// 点击消息背景事件
-(void)bubbleBackViewAction:(UIImageView *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatImageVideoCellIndexPatch:layout:)]){
        [self.delegate didChatImageVideoCellIndexPatch:self.indexPath layout:self.model];
    }
}

@end
