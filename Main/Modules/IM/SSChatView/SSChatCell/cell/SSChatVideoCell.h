//
//  SSChatVideoCell.h
//  SSChatView
//
//  Created by soldoros on 2018/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "FYChatBaseCell.h"



@interface SSChatVideoCell : FYChatBaseCell


@end


@interface SSChatVideoContent :NSObject
@property (nonatomic , copy) NSString              * fileName;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , copy) NSString              * url;

@end
