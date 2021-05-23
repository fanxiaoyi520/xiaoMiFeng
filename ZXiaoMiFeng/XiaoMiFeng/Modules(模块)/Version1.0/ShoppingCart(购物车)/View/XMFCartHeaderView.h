//
//  XMFCartHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCartHeaderView;

@class XMFShopCartMiddleModel;

@protocol XMFCartHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFCartHeaderViewDidClick:(XMFCartHeaderView *)headerView button:(UIButton *)button section:(NSInteger)section;

@required//必须实现的方法

@end


@interface XMFCartHeaderView : UIView


/** 记录组数 */
@property (nonatomic,assign)NSInteger  section;

@property (nonatomic, weak) id<XMFCartHeaderViewDelegate> delegate;

@property (nonatomic, strong) XMFShopCartMiddleModel *middleModel;

@end

NS_ASSUME_NONNULL_END
