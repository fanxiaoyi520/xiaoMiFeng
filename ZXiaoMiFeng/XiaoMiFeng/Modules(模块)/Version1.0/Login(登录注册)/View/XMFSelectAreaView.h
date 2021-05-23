//
//  XMFSelectAreaView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFAreaCode;

@interface XMFSelectAreaView : UIView

-(void)show;

-(void)hide;

@property (nonatomic, strong) NSArray<XMFAreaCode *> *areaArr;

@property (nonatomic, copy) void (^selectedAreaBlock)(XMFAreaCode *areaModel);

@end

NS_ASSUME_NONNULL_END
