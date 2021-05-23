//
//  XMFOrdersFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
    
    "cancel":取消订单,
    "delete":暂时没用,
    "pay":去付款,
    "comment":去评价,
    "confirm":确认收货,
    "refund":申请退款,
    "rebuy":暂时没用

    */

//说明：下面的顺序和赋值不能改变，因为与创建订单的showType是对应的
/*
typedef enum : NSUInteger {
    pendingPay = 1,//待付款：cancel和pay为true
    pendingDelivery,//待发货：refund为true，表示拣货未完成；refund为false，表示拣货已完成；
    pendingReceipt,//待收货：confirm为true
    pendingComment,//待评价：comment为true
} ordersStatusType;

*/

@class XMFOrdersCellModel;

@class XMFOrdersFooterView;

@protocol XMFOrdersFooterViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFOrdersFooterViewDidClick:(XMFOrdersFooterView *)footerView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFOrdersFooterView : UIView

@property (nonatomic, strong) XMFOrdersCellModel *orderModel;


@property (nonatomic, weak) id<XMFOrdersFooterViewDelegate> delegate;

//组数
@property (nonatomic, assign) NSInteger sectionNum;

@end

NS_ASSUME_NONNULL_END
