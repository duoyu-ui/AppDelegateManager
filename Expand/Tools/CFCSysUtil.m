
#import "CFCSysUtil.h"

@implementation CFCSysUtil

#pragma mark -
#pragma mark 验证对象是否为空（数组、字典、字符串）
+ (BOOL)validateObjectIsNull:(id)obj
{
    if (nil == obj || obj == [NSNull null]) {
        return YES;
    }
    
    // 字典
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if([obj isKindOfClass:[NSNull class]]) {
            return YES;
        }
    }
    // 数组
    else if ([obj isKindOfClass:[NSArray class]]) {
        if([obj isKindOfClass:[NSNull class]]) {
            return YES;
        }
    }
    // 字符串
    else if ([obj isKindOfClass:[NSString class]]) {
        return [CFCSysUtil validateStringEmpty:obj];
    }
    
    return NO;
}

#pragma mark 验证字符串是否为空
+ (BOOL)validateStringEmpty:(NSString *)value
{
    if (nil == value
        || [@"NULL" isEqualToString:value]
        || [value isEqualToString:@"<null>"]
        || [value isEqualToString:@"(null)"]
        || [value isEqualToString:@"null"]) {
        return YES;
    }
    // 删除两端的空格和回车
    NSString *str = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (str.length <= 0);
}

#pragma mark 验证字符串是否为URL
+ (BOOL)validateStringUrl:(NSString *)url
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

#pragma mark 验证字符串数据是否相等
+ (BOOL)validateStrArray:(NSArray<NSString *> *)strArray1 isEqualToStrArray:(NSArray<NSString *> *)strArray2
{
    if (!strArray1 || !strArray2) {
        return NO;
    }
    
    if (strArray1.count != strArray2.count) {
        return NO;
    }
    
    for (NSInteger idx = 0; idx < strArray1.count; idx ++) {
        NSString *str1 = [strArray1 objectAtIndex:idx];
        NSString *str2 = [strArray2 objectAtIndex:idx];
        if (![str1 isEqualToString:str2]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 将阿拉伯数字转换为中文数字
+ (NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}


#pragma mark -
#pragma mark 验证请求数据是否成功
+ (BOOL)validateNetRequestResult:(id)response
{
    return [[self class] validateNetRequestResult:response key:NET_REQUEST_KEY_STATUS value:ResultCodeSuccess];
}

#pragma mark 验证请求数据是否成功
+ (BOOL)validateNetRequestResult:(id)response key:(NSString *)key value:(NSInteger)value
{
    if (![response isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    NSDictionary *responseData = (NSDictionary *)response;
    if (![responseData hasKey:key]) {
        return NO;
    }
    
    id returnStatus = [responseData objectForKey:key];
    if ([CFCSysUtil validateObjectIsNull:returnStatus]) {
        return NO;
    }
    
    if ([returnStatus isKindOfClass:[NSString class]]
        || [returnStatus isKindOfClass:[NSNumber class]]) {
        if (value == [returnStatus integerValue]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 获取网络请求
+ (id)objectOfNetRequestResultData:(id)response
{
    if (![response isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *responseData = (NSDictionary *)response;
    if (![responseData hasKey:NET_REQUEST_KEY_DATA]) {
        return nil;
    }

    return [responseData objectForKey:NET_REQUEST_KEY_DATA];
}

#pragma mark 弹出提示信息 - 网络成功信息
+ (void)alterSuccMessage:(id)response
{
    if([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict =(NSDictionary *)response;
        NSString *msg = [dict stringForKey:NET_REQUEST_KEY_MESS];
        if (![CFCSysUtil validateStringEmpty:msg]) {
            dispatch_main_async_safe(^{
                [JSLProgressAlertUtil showMessageToWindow:msg];
            });
        }
    } else {
        [[FunctionManager sharedInstance] handleFailResponse:response];
    }
}

#pragma mark 弹出提示信息 - 网络错误信息
+ (void)alterErrorMessage:(id)error
{
    if([error isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict =(NSDictionary *)error;
        NSString *msg = [dict stringForKey:NET_REQUEST_KEY_MESS_ALTER];
        if (![CFCSysUtil validateStringEmpty:msg]) {
            dispatch_main_async_safe(^{
                [JSLProgressAlertUtil showMessageToWindow:msg];
            });
        }
    } else {
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }
}

#pragma mark 弹出提示信息
+ (void)alterSringMessage:(NSString *)message
{
    dispatch_main_async_safe(^{
        [JSLProgressAlertUtil showMessageToWindow:message];
    });
}

#pragma mark -
#pragma mark 验证Token是否有效
+ (void)validateAuthToken:(id)response
{
    // Token失效：参照安卓处理方式：
    // 账号在不同地方登录，后台无法验证Token失效的问题，下面方法特殊处理，用于处理此种情况。
    // 说明：下面代码在后台返回的提示信息内容不改变的状态下才会有用。主要检查主页的的请求接口返回数据。
    if([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict =(NSDictionary *)response;
        NSString *msg = [dict stringForKey:NET_REQUEST_KEY_MESS_ALTER];
        if (![CFCSysUtil validateStringEmpty:msg]) {
            if ([NSLocalizedString(@"页码不能为空", nil) isEqualToString:msg]
                || [NSLocalizedString(@"type不能为空", nil) isEqualToString:msg]
                || [NSLocalizedString(@"该群不存在", nil) isEqualToString:msg]
                || [NSLocalizedString(@"每页显示行数不能为空", nil) isEqualToString:msg]
                || [NSLocalizedString(@"充值大类type不能为空", nil) isEqualToString:msg]
                || [NSLocalizedString(@"登录信息已失效，请重新登陆!", nil) isEqualToString:msg]) {
                [[FYIMMessageManager shareInstance] userSignout];
                [[AppModel shareInstance] logout];
                // 如果是在显示页面检测到Token无效，则直接弹框（后台线程中无法弹出提示框）
                dispatch_main_async_safe(^{
                    AlertViewCus *alterView = [AlertViewCus createInstanceWithView:nil];
                    [alterView showWithText:NSLocalizedString(@"登录已过期，请重新陆", nil) button:NSLocalizedString(@"确定", nil) callBack:^(id object) {

                    }];
                });
            }
        }
    }
}

#pragma mark -
#pragma mark 删除字符串两端的空格与回车
+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)value
{
    if ([CFCSysUtil validateObjectIsNull:value]) {
        return @"";
    }
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 删除字符串中的空格与回车
+ (NSString *)stringRemoveSpaceAndWhitespaceAndNewline:(NSString *)value
{
    NSString *temp = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

#pragma mark -
#pragma mark 获取当前时间
+ (NSString *)getCurrentTimeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark 获取所有字体名称列表
+ (NSArray<NSString *> *)getAllFontFamilyNames
{
    NSMutableArray<NSString *> *fontNames = [NSMutableArray array];
    for(NSString *fontfamilyname in [UIFont familyNames]) {
        FYLog(@"Family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname]) {
            [fontNames addObject:fontName];
            FYLog(@"\tFont:'%@'",fontName);
        }
    }
    return [NSArray arrayWithArray:fontNames];
}

#pragma mark 获取长度最大字符串
+ (NSString *)getMaxLengthItemString:(NSArray<NSString *> *)items
{
    __block NSString *maxLengthItem = @"";
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > maxLengthItem.length) {
            maxLengthItem = obj;
        }
    }];
    return maxLengthItem;
}

#pragma mark 获取带有不同样式的文字内容
+ (NSAttributedString *)attributedString:(NSArray*)stringArray attributeArray:(NSArray *)attributeArray
{
    // 定义要显示的文字内容
    NSString *string = [stringArray componentsJoinedByString:@""]; // 拼接传入的字符串数组
    // 通过要显示的文字内容来创建一个带属性样式的字符串对象
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithString:string];
    for(NSInteger i = 0; i < stringArray.count; i++){
        // 将某一范围内的字符串设置样式
        [result setAttributes:attributeArray[i] range:[string rangeOfString:stringArray[i]]];
    }
    // 返回已经设置好了的带有样式的文字
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

/**
 * 查找子字符串在父字符串中的所有位置
 * @return 返回位置数组
 */
+ (NSArray<NSValue *> *)getAllRangesOfString:(NSString *)text matchingSubstring:(NSString *)pattern
{
    if (VALIDATE_STRING_EMPTY(text) || VALIDATE_STRING_EMPTY(pattern)) {
        return nil;
    }
    
    NSMutableArray *matchingRanges = [NSMutableArray new];
    NSUInteger textLength = text.length;
    NSRange match = makeRangeFromIndex(0, textLength);

    while(match.location != NSNotFound) {
        match = [text rangeOfString:pattern options:0L range:match];
        if (match.location != NSNotFound) {
            NSValue *value = [NSValue value:&match withObjCType:@encode(NSRange)];
            [matchingRanges addObject:value];
            match = makeRangeFromIndex(match.location + 1, textLength);
        }
    }
    
    return [matchingRanges copy];
}

NSRange makeRangeFromIndex(NSUInteger index, NSUInteger length) {
    return NSMakeRange(index, length - index);
}



@end


