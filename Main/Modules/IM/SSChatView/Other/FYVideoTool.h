//
//  FYVideoTool.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYVideoTool : NSObject

/// 获取压缩过的视频
/// @param videoAsset AVURLAsset
/// @param success 成功的回调
/// @param failure 失败的回调
+ (void)startExportMP4VideoWithVideoAsset:(AVURLAsset *)videoAsset success:(void (^)(NSString *outputPath,NSString *fileName,UIImage *img))success failure:(void (^)(NSString *errorMessage, NSError *error))failure;
///获取视频第一帧
+ (UIImage *)getImageWithAsset:(AVAsset *)asset;
@end

NS_ASSUME_NONNULL_END
