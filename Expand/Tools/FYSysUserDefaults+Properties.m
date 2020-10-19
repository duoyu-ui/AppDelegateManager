
#import "FYSysUserDefaults+Properties.h"

@implementation FYSysUserDefaults (Properties)

@dynamic touchButtonOriginX;
@dynamic touchButtonOriginY;

- (NSDictionary *)setupDefaults
{
    // 设置默认值
    return @{
                @"touchButtonOriginX": [NSNumber numberWithFloat:SCREEN_MIN_LENGTH-FULL_SUSPEND_BALL_SIZE],
                @"touchButtonOriginY": [NSNumber numberWithFloat:STATUS_BAR_HEIGHT]
             };
}

- (NSDictionary *)setupDefaultsOfProperties
{
    // 设置默认值
    return @{
             
             };
}

- (NSString *)suitName
{
    // 自定义分类存储文件名称，默认为 Bundle Identifier
    return @"jsl.module.devkit.userdefaults";
}

- (NSString *)transformKey:(NSString *)key
{
    // NSUserDefaults 中的键值是与你给的键值一样的，如果你需要加点前缀用以标注，用这个方法 transformKey: 即可
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"FYSysUserDefaultsKey%@", key];
}


@end
