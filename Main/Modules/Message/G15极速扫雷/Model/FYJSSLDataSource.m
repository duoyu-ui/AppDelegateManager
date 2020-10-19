//
//  FYJSSLDataSource.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLDataSource.h"

@implementation FYJSSLDataSource
+ (NSArray<FYJSSLDataSource *> *)setJSSLDataSource{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 5; j++) {
            FYJSSLDataSource *data = [[FYJSSLDataSource alloc]init];
            data.digits = j;
            switch (j) {
                case 0:
                    data.imgNor = [UIImage imageNamed:@"jssl_wan_icon_nor"];
                    data.imgSel = [UIImage imageNamed:@"jssl_wan_icon_sel"];
                    break;
                case 1:
                    data.imgNor = [UIImage imageNamed:@"jssl_qian_icon_nor"];
                    data.imgSel = [UIImage imageNamed:@"jssl_qian_icon_sel"];
                    break;
                case 2:
                    data.imgNor = [UIImage imageNamed:@"jssl_bai_icon_nor"];
                    data.imgSel = [UIImage imageNamed:@"jssl_bai_icon_sel"];
                    break;
                case 3:
                    data.imgNor = [UIImage imageNamed:@"jssl_shi_icon_nor"];
                    data.imgSel = [UIImage imageNamed:@"jssl_shi_icon_sel"];
                    break;
                case 4:
                    data.imgNor = [UIImage imageNamed:@"jssl_ge_icon_nor"];
                    data.imgSel = [UIImage imageNamed:@"jssl_ge_icon_sel"];
                    break;
                default:
                    break;
            }
            data.num = i;
            data.isSelected = NO;
            [arr addObj:data];
        }
    }
    return arr;
}
+ (NSArray<FYJSSLDataSource*>*)singleSelect:(NSArray<FYJSSLDataSource*>*)dataSource{
    [dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *data, NSUInteger idx, BOOL * _Nonnull stop) {
           dataSource[idx].isSelected = NO;
       }];
       int row = (arc4random() % 5);
       NSMutableArray <NSString*>*codeArray = [NSMutableArray array];
       for (int i = 0; i < 3; i++) {
           //获取一个随机整数范围在：[0,9]包括0，包括9
           int code= (arc4random() % 10);
           for (int j=0; j<codeArray.count; j++) {
               NSString *s = codeArray[j];
               while ( s.intValue == code) {
                   code = (arc4random() % 10);
                   j = -1;
               }
           }
           [codeArray addObject:[NSString stringWithFormat:@"%d",code]];
           [dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *list, NSUInteger idx, BOOL * _Nonnull stop) {
               if (list.num == code && list.digits == row) {
                   dataSource[idx].isSelected = YES;
               }
           }];
       }
    return dataSource;
}
+ (NSArray<FYJSSLDataSource*>*)multiSelectWithData:(NSArray<FYJSSLDataSource*>*)dataSource num:(int)num rando:(int)rando{
    [dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *data, NSUInteger idx, BOOL * _Nonnull stop) {
        dataSource[idx].isSelected = NO;
    }];
    NSMutableArray <NSString*>*codeArray = [NSMutableArray array];
    for (int i = 0; i < num; i++) {
        //获取一个随机整数范围在：[0,9]包括0，包括9
        int code= (arc4random() % 10);
        for (int j=0; j<codeArray.count; j++) {
            NSString *s = codeArray[j];
            while ( s.intValue == code) {
                code = (arc4random() % 10);
                j = -1;
            }
        }
        [codeArray addObject:[NSString stringWithFormat:@"%d",code]];
        [dataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource *list, NSUInteger idx, BOOL * _Nonnull stop) {
            if (list.num == code && list.digits == i + rando) {
                dataSource[idx].isSelected = YES;
            }
        }];
    }
    return dataSource;
}
@end
