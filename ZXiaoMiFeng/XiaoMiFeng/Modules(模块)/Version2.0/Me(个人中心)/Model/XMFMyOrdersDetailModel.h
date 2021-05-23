//
//  XMFMyOrdersDetailModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListGoodsListModel;


@interface XMFMyOrdersDetailGoodsListModel : NSObject
/** 评论状态 0:不可评论 1可以评论 2可以追加评论 */
@property (nonatomic, copy) NSString * commentStatus;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 主键id */
@property (nonatomic, copy) NSString * keyId;
/** 商品税费 */
@property (nonatomic, copy) NSString * incomeTax;
/** 购买数量 */
@property (nonatomic, copy) NSString * number;
/** 商品图片 */
@property (nonatomic, copy) NSString * picUrl;
/** 商品售价 */
@property (nonatomic, copy) NSString * price;
/** 缺货说明 */
@property (nonatomic, copy) NSString * remark;
/** 商品规格 */
@property (nonatomic, strong) NSArray * specifications;
/** 是否缺货 */
@property (nonatomic, copy) NSString * status;



@end



@interface XMFMyOrdersDetailModel : NSObject

/** 实付金额 */
@property (nonatomic, copy) NSString * actualPrice;
/** 订单创建时间 */
@property (nonatomic, copy) NSString * addTime;
/** 收货地址 */
@property (nonatomic, copy) NSString * address;
/** 自动确认收货时间 */
@property (nonatomic, copy) NSString * autoConfirmTime;
/** 纸箱条码 */
@property (nonatomic, copy) NSString * cartonBoxBarCode;
/** 收货人 */
@property (nonatomic, copy) NSString * consignee;
/** 其他优惠 */
@property (nonatomic, copy) NSString * couponPrice;
/** 运费 */
@property (nonatomic, copy) NSString * freightPrice;
/** 订单商品列表 */
@property (nonatomic, strong) NSArray<XMFMyOrdersListGoodsListModel *> * goodsList;
/** 商品总金额 */
@property (nonatomic, copy) NSString * goodsPrice;
/** 操作的字典 */
@property (nonatomic, strong) NSMutableDictionary * handleOption;
/** 订单主键ID */
@property (nonatomic, copy) NSString * keyId;
/** 买家留言 */
@property (nonatomic, copy) NSString * leavingMessage;
/** 联系电话 */
@property (nonatomic, copy) NSString * mobile;
/** 订单编号 */
@property (nonatomic, copy) NSString * orderSn;
/** 订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’） */
@property (nonatomic, copy) NSString * orderStatus;
/** 退款信息 */
@property (nonatomic, copy) NSString * refundInfoDto;
/** 后台拒绝退款原因 */
@property (nonatomic, copy) NSString * remark;
/** 发货快递公司 */
@property (nonatomic, copy) NSString * shipChannel;
/** 物流运单编号;9开头+12位数字 */
@property (nonatomic, copy) NSString * shipSn;
/** 发货开始时间 */
@property (nonatomic, copy) NSString * shipTime;
/** 税费 */
@property (nonatomic, copy) NSString * taxPrice;
/** 交易类型 1:银联 2:微信 3:支付宝 4:H5支付 5:Apple Pay  6:银联云闪付  7：银联二维码 8：微信H5 9:支付宝H5 10:未知 */
@property (nonatomic, copy) NSString * transferId;

/** 是否已签收 */
@property (nonatomic, copy) NSString *receipt;

/** 订单来源（临时自己加的） */
@property (nonatomic, copy) NSString * orderSource;

@end

NS_ASSUME_NONNULL_END
