//
//  XMFGoodsDetailFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailFooterView;
@class XMFGoodsDatailModel;


@protocol XMFGoodsDetailFooterViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFGoodsDetailFooterViewDidClick:(XMFGoodsDetailFooterView *)footerView button:(UIButton *)button;


@required//必须实现的方法

@end


@interface XMFGoodsDetailFooterView : UIView

@property (nonatomic, weak) id<XMFGoodsDetailFooterViewDelegate> delegate;

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
