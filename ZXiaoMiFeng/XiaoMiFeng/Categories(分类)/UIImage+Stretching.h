//
//  UIImage+Stretching.h
//  advertisingCattle
//
//  Created by 🐝小蜜蜂🐝 on 2019/1/5.
//  Copyright © 2019 xiaomifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Stretching)

/**
 *  返回一张可以随意拉伸不变形的图片
 *  @param name 图片名字
 */
+(UIImage *)stretchableImageWithImgae:(NSString *)name;

/**
 第一种基本类似，但是这里不方便的地方就是预留的部分不好把握，因为要拉伸的图片大小不可控，不推荐使用，仅供参考

 @param name 图片名字
 */
+(UIImage *)stretchableImageResizableImageWithCapInsets:(NSString *)name;


/**
 获取网络图片高度
 */
+ (CGSize)getImageSizeWithURL:(id)URL;

+ (UIImage *)resizableImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
