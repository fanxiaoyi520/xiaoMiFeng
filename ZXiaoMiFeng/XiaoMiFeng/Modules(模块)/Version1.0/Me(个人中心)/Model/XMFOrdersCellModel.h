//
//  XMFOrdersCellModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

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

typedef enum : NSUInteger {
    
    pendingDefault,//默认，或者全部为false
    pendingPay = 1,//待付款：cancel和pay为true
    pendingDelivery,//待发货：refund为true，表示拣货未完成；refund为false，表示拣货已完成；
    pendingReceipt,//待收货：confirm为true
    pendingComment,//待评价：comment为true
    pendingRebuy,//待重买：rebuy和delete为true
    pendingDelete,//待删除（已取消）：delete为true
    pengdingStock,//待进货（缺货）：orderStatusText为“缺货”
    
} ordersStatusType;


//操作model
@interface XMFOrdersCellHandleOptionModel : NSObject

@property (nonatomic, assign) BOOL cancel;
@property (nonatomic, assign) BOOL comment;
@property (nonatomic, assign) BOOL confirm;
@property (nonatomic, assign) BOOL orderDelete;
@property (nonatomic, assign) BOOL pay;
@property (nonatomic, assign) BOOL rebuy;
@property (nonatomic, assign) BOOL refund;



@end


//商品列表model
@interface XMFOrdersCellGoodsListModel : NSObject

@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * picUrl;


@end


@interface XMFOrdersCellModel : NSObject

@property (nonatomic, copy) NSString *orderStatusText;

//缺货状态说明文字
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *orderSn;

@property (nonatomic, copy) NSString *actualPrice;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) NSArray<XMFOrdersCellGoodsListModel *> *goodsList;

@property (nonatomic, strong) XMFOrdersCellHandleOptionModel *handleOption;

//人工加入:订单状态
@property (nonatomic, assign) ordersStatusType statusType;

/**
 
 "orderStatusText":"已取消(系统)",
 "orderSn":"20200514100157591469",
 "actualPrice":1045.86,
 "goodsList":Array[3],
 "id":3369,
 "handleOption":Object{...}
 
 */

@end

NS_ASSUME_NONNULL_END
