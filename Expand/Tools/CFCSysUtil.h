
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFCSysUtil : NSObject

#pragma mark -
#pragma mark 验证对象是否为空（数组、字典、字符串）
+ (BOOL)validateObjectIsNull:(id)obj;
#pragma mark 验证字符串是否为空
+ (BOOL)validateStringEmpty:(NSString *)value;
#pragma mark 验证字符串是否为URL
+ (BOOL)validateStringUrl:(NSString *)url;

#pragma mark 验证字符串数据是否相等
+ (BOOL)validateStrArray:(NSArray<NSString *> *)strArray1 isEqualToStrArray:(NSArray<NSString *> *)strArray2;

#pragma mark 将阿拉伯数字转换为中文数字
+ (NSString *)translationArabicNum:(NSInteger)arabicNum;

#pragma mark -
#pragma mark 验证请求数据是否成功
+ (BOOL)validateNetRequestResult:(id)response;
+ (BOOL)validateNetRequestResult:(id)response key:(NSString *)key value:(NSInteger)value;

#pragma mark -
#pragma mark 获取网络请求数据
+ (id)objectOfNetRequestResultData:(id)response;

#pragma mark -
#pragma mark 弹出错误提示信息框
+ (void)alterSuccMessage:(id)response;
+ (void)alterErrorMessage:(id)error;
+ (void)alterSringMessage:(NSString *)message;

#pragma mark -
#pragma mark 验证Token是否有效
+ (void)validateAuthToken:(id)response;

#pragma mark -
#pragma mark 删除字符串两端的空格与回车
+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)value;
#pragma mark 删除字符串中的空格与回车
+ (NSString *)stringRemoveSpaceAndWhitespaceAndNewline:(NSString *)value;

#pragma mark -
#pragma mark 获取当前时间
+ (NSString *)getCurrentTimeStamp;
#pragma mark 获取所有字体名称列表
+ (NSArray<NSString *> *)getAllFontFamilyNames;
#pragma mark 获取长度最大字符串
+ (NSString *)getMaxLengthItemString:(NSArray<NSString *> *)items;
#pragma mark 获取带有不同样式的文字内容
+ (NSAttributedString *)attributedString:(NSArray*)stringArray attributeArray:(NSArray *)attributeArray;
#pragma mark 查找子字符串在父字符串中的所有位置
+ (NSArray<NSValue *> *)getAllRangesOfString:(NSString *)text matchingSubstring:(NSString *)pattern;


@end

NS_ASSUME_NONNULL_END


