//
//  XMFOrdersHeaderFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;

@class XMFOrdersHeaderFooterView;

@protocol XMFOrdersHeaderFooterViewDelegate<NSObject>

@optional//选择实现的方法


-(void)buttonsOnXMFOrdersHeaderFooterViewDidClick:(XMFOrdersHeaderFooterView *)footerView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFOrdersHeaderFooterView : UITableViewHeaderFooterView


@property (nonatomic, strong) XMFOrdersCellModel *orderModel;

//组数
@property (nonatomic, assign) NSInteger sectionNum;

@property (nonatomic, weak) id<XMFOrdersHeaderFooterViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
