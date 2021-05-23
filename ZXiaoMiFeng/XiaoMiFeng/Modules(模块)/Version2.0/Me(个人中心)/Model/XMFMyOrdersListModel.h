//
//  XMFMyOrdersListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMFOrderRateController.h"//评价页面导入结构体


NS_ASSUME_NONNULL_BEGIN


@interface XMFMyOrdersListRefundInfoDtoModel: NSObject

/** 退款金额 */
@property (nonatomic, copy) NSString *amount;
/** 订单主键ID */
@property (nonatomic, copy) NSString *keyId;
/** 联系电话 */
@property (nonatomic, copy) NSString *mobile;
/** 订单ID */
@property (nonatomic, copy) NSString *orderId;
/** 图片 */
@property (nonatomic, strong) NSArray *picUrls;
/** 退款原因 */
@property (nonatomic, copy) NSString *reason;
/** 评论类型（1：多拍、错拍，2：不想要，3：其他） */
@property (nonatomic, copy) NSString *type;
/** 用户ID */
@property (nonatomic, copy) NSString *userId;

@end


@interface XMFMyOrdersListHandleOptionModel : NSObject

/** 追加评论操作 */
@property (nonatomic, assign) BOOL appendComment;
/** 取消操作 */
@property (nonatomic, assign) BOOL cancel;
/** 取消退款 */
@property (nonatomic, assign) BOOL cancelRefund;
/** 评论操作 */
@property (nonatomic, assign) BOOL comment;
/** 确认收货操作 */
@property (nonatomic, assign) BOOL confirm;
/** 删除操作 */
@property (nonatomic, assign) BOOL orderDelete;
/** 延长收货 */
@property (nonatomic, assign) BOOL extendConfirm;
/** 支付操作 */
@property (nonatomic, assign) BOOL pay;
/** 查看物流 */
@property (nonatomic, assign) BOOL queryTrack;
/** 再次购买 */
@property (nonatomic, assign) BOOL rebuy;
/** 申请退款 */
@property (nonatomic, assign) BOOL refund;
/** 提醒发货 */
@property (nonatomic, assign) BOOL remind;
/** 修改收货地址 */
@property (nonatomic, assign) BOOL updateAddress;



@end





@interface XMFMyOrdersListGoodsListModel : NSObject
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
/** 产品ID */
@property (nonatomic, copy) NSString *productId;

/** 商品id */
@property (nonatomic, copy) NSString * goodsId;

/** 供应商名称 */
@property (nonatomic, copy) NSString *supplierName;

/** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
@property (nonatomic, copy) NSString *orderType;

//以下为评论列表的model的属性


/** 评价内容 */
@property (nonatomic, copy) NSString *content;

/** 星星数量 */
@property (nonatomic, assign) NSInteger star;

/** 选中的图片 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

/** 选中的图片数据 */
@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

/** 上传的图片链接 */
@property (nonatomic, strong) NSMutableArray *picUrlsArr;

/** 字数 */
@property (nonatomic, assign) NSInteger wordsCountNum;

/** 评论类型 */
@property (nonatomic, assign) orderRateType rateType;


@end






@interface XMFMyOrdersListModel : NSObject

/** 实付金额 */
@property (nonatomic, copy) NSString * actualPrice;
/** 订单创建时间 */
@property (nonatomic, copy) NSString * addTime;
/** 收货地址 */
@property (nonatomic, copy) NSString * address;

/** 拣货状态 1待拣货 2已拣货 */
@property (nonatomic, copy) NSString *allocateCargoStatus;

/** 自动确认收货时间 */
@property (nonatomic, copy) NSString * autoConfirmTime;
/** 纸箱条码 */
@property (nonatomic, copy) NSString * cartonBoxBarCode;
/** 收货人 */
@property (nonatomic, copy) NSString * consignee;

/** 其他优惠 */
@property (nonatomic, copy) NSString * couponPrice;

/** 商城优惠 */
@property (nonatomic, copy) NSString *otherDiscount;

/** 运费 */
@property (nonatomic, copy) NSString * freightPrice;
/** 订单商品列表 */
@property (nonatomic, strong) NSArray<XMFMyOrdersListGoodsListModel *> * goodsList;
/** 商品总金额 */
@property (nonatomic, copy) NSString * goodsPrice;
/** 按钮状态 */
//@property (nonatomic, strong) XMFMyOrdersListHandleOptionModel * handleOption;
@property (nonatomic, strong) NSMutableDictionary * handleOption;
/** 买家留言 */
@property (nonatomic, copy) NSString * keyId;
/** 订单主键ID */
@property (nonatomic, copy) NSString * leavingMessage;
/** 联系电话 */
@property (nonatomic, copy) NSString * mobile;
/** 订单编号 */
@property (nonatomic, copy) NSString * orderSn;
/** 订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’） */
@property (nonatomic, copy) NSString * orderStatus;

/** 退款信息 */
@property (nonatomic, strong) XMFMyOrdersListRefundInfoDtoModel * refundInfoDto;
/** 后台拒绝退款原因 */
@property (nonatomic, copy) NSString * remark;
/** 发货快递公 */
@property (nonatomic, copy) NSString * shipChannel;
/** 物流运单编号;9开头+12位数字 */
@property (nonatomic, copy) NSString * shipSn;
/** 发货开始时间 */
@property (nonatomic, copy) NSString * shipTime;
/** 税费 */
@property (nonatomic, copy) NSString * taxPrice;
/** 交易类型 1-快捷，2-微信，3-支付宝,4-海外SDK */
@property (nonatomic, copy) NSString * transferId;

/** 是否已签收 */
@property (nonatomic, copy) NSString *receipt;

/** 订单来源 */
@property (nonatomic, copy) NSString * orderSources;

/** 订单类型 1–bc 2–cc */
@property (nonatomic, copy) NSString *orderType;

/** 订单是否缺货 */
@property (nonatomic, copy) NSString *outOfStock;

/** 是否是历史订单需要补充身份证 */
@property (nonatomic, assign) BOOL oldFlag;

/** 仓库ID */
@property (nonatomic, copy) NSString *warehouseId;

/** 仓库名称 */
@property (nonatomic, copy) NSString *warehouseName;

/** 人工加入：是否升级过地址 */
@property (nonatomic, assign) BOOL isUpdateAddress;

/** 防伪袋袋号 */
@property (nonatomic, strong) NSArray *freeTaxBarCode;


@end

NS_ASSUME_NONNULL_END
