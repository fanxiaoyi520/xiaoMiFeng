//
//  UIView+FrameCategory.h
//  newupop
//
//  Created by ideasforHK on 2017/7/21.
//  Copyright © 2017年 ideasforHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameCategory)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;


//加载xib文件
+ (id _Nullable )XMFLoadFromXIB;

+ (id _Nullable )XMFLoadFromXIBName:(NSString *_Nullable)xibName;

@end
