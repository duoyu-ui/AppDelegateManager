
#import "CFCNavSXFixSpaceUitl.h"

@implementation CFCNavSXFixSpaceUitl

+ (void)load
{
    [UINavigationConfig shared].sx_disableFixSpace = NO;
    [UINavigationConfig shared].sx_defaultFixSpace = 10.0f;
}

+ (void)enableFixSpace
{
    [UINavigationConfig shared].sx_disableFixSpace = NO;
}

+ (void)disableFixSpace
{
    [UINavigationConfig shared].sx_disableFixSpace = YES;
}



@end
