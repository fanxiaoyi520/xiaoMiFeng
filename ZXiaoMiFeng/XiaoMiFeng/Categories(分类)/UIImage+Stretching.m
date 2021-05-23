//
//  UIImage+Stretching.m
//  advertisingCattle
//
//  Created by 🐝小蜜蜂🐝 on 2019/1/5.
//  Copyright © 2019 xiaomifeng. All rights reserved.
//

#import "UIImage+Stretching.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Stretching)

/**
 *  返回一张可以随意拉伸不变形的图片
 *  @param name 图片名字
 */
+(UIImage *)stretchableImageWithImgae:(NSString *)name{
    
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    
    return [normal stretchableImageWithLeftCapWidth:w topCapHeight:h];
    
}

+(UIImage *)stretchableImageResizableImageWithCapInsets:(NSString *)name{
    
    
    UIImage *image = [UIImage imageNamed:name];
    
    CGFloat top = 10;     // 顶端预留部分
    CGFloat bottom = 10 ; // 底端预留部分
    CGFloat left = 40; // 左端预留部分
    CGFloat right = 40; // 右端预留部分
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    ///注意：拉伸之后一定要赋值回去
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    //UIImageResizingModeStretch：`拉伸`模式，通过`拉伸`Insets指定的矩形区域来填充图片
    //UIImageResizingModeTile：`平铺`模式，通过`重复显示`Insets指定的矩形区域来填充图片
    return image;
}

/**
 获取网络图片高度
 */
+ (CGSize)getImageSizeWithURL:(id)URL
{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
    
}


+ (UIImage *)resizableImage:(UIImage *)image
{
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(w, h, w, h)];
}




@end
