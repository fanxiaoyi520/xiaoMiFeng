//
//  XMFOrderRateFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderRateFooterView;

@protocol XMFOrderRateFooterViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFOrderRateFooterViewDidClick:(XMFOrderRateFooterView *)footerView button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFOrderRateFooterView : UIView

@property (nonatomic, weak) id<XMFOrderRateFooterViewDelegate> delegate;


/** 匿名评价 */
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;



@end

NS_ASSUME_NONNULL_END
