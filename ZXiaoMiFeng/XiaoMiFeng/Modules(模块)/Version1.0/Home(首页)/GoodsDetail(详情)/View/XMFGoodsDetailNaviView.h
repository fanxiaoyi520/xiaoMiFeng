//
//  XMFGoodsDetailNaviView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailNaviView;

@protocol XMFGoodsDetailNaviViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFGoodsDetailNaviViewDidClick:(XMFGoodsDetailNaviView *)naviView button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFGoodsDetailNaviView : UIView

@property (nonatomic, weak) id<XMFGoodsDetailNaviViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
