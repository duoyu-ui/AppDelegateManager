
#import "UIViewController+PixelColor.h"

@implementation UIViewController (PixelColor)

/**
 判断颜色是否相等
 @return YES相等
 */
- (BOOL) isEqualColor:(UIColor*)color1 withColor:(UIColor*)color2
{
    if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
        return YES;
    } else {
        return NO;
    }
}


/**
 获取屏幕截图
 @return 返回屏幕截图
 */
- (UIImage *)fullScreenshots
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    return viewImage;
}

/**
 获取点击的颜色
 @param point 点击位置
 @return 返回点击地方的颜色
 */
- (UIColor*)getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = [self getPixelColorAtLocation:point withImage:[self fullScreenshots]];
    return color;
}

/**
 获取点击的颜色
 @param point 点击的位置
 @return 返回点击地方的颜色
 */
- (UIColor*)getPixelColorAtLocation:(CGPoint)point withImage:(UIImage*)image
{
    UIColor* color = nil;
    
    CGImageRef inImage = image.CGImage;
    
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    
    if (cgctx == NULL) { return nil; }

    size_t w = CGImageGetWidth(inImage);

    size_t h = CGImageGetHeight(inImage);

    CGRect rect = {{0,0},{w,h}};

    // Draw the image to the bitmap context. Once we draw, the memory

    // allocated for the context for rendering will then contain the

    // raw image data in the specified color space.

    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap

    // context.

    unsigned char* data = CGBitmapContextGetData (cgctx);

    if (data != NULL) {
        
        //offset locates the pixel in the data from x,y.

        //4 for 4 bytes of data per pixel, w is width of one row of data.

        @try {
            
            int offset = 4*((w*round(point.y))+round(point.x));
            
            int alpha = data[offset];
            
            int red = data[offset+1];
            
            int green = data[offset+2];
            
            int blue = data[offset+3];
            
            FYLog(NSLocalizedString(@"屏幕颜色[%@]RGBA(%i,%i,%i,%i)", nil), self.title, red, green, blue, alpha);
            
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
            
        } @catch (NSException * e) {
            
            FYLog(@"%@",[e reason]);
            
        } @finally {
            
        }
        
    }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage
{
    CGContextRef context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *bitmapData;
    
    int bitmapByteCount;
    
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    
    // alpha.
    
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    
    // where any drawing to the bitmap context will be rendered.
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    
    // per component. Regardless of what the source image format is
    
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    
    // specified here by CGBitmapContextCreate.
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8, // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
    {
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}


@end

