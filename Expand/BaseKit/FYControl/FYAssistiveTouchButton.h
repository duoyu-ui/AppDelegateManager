
#import "FYAssistiveTouchComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYAssistiveTouchButtonDelegate;

@interface FYAssistiveTouchButton : FYAssistiveTouchComponent
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, weak) id <FYAssistiveTouchButtonDelegate> delegate;

+ (instancetype)spreadButtonWithCapacity:(NSUInteger)itemsNum;
- (void)spreadButtonDidClickItemAtIndex:(void(^)(NSUInteger index))indexBlock;

- (void)hitTestWithEventToShrinkCloseHandle;

@end

@protocol FYAssistiveTouchButtonDelegate <NSObject>
@optional
- (void)touchButton:(FYAssistiveTouchButton *)touchButton didSelectedAtIndex:(NSUInteger)index withSelectedButton:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
