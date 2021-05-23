//
//  XMFSelectGoodsTypeView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsPropertyModel;

@class XMFHomeGoodsPropertyProductsModel;

@class XMFSelectGoodsTypeView;

@class XMFGoodsSpecInfoModel;

@class XMFHomeGoodsDetailModel;

@protocol XMFSelectGoodsTypeViewDelegate<NSObject>

@optional//选择实现的方法


//确定按钮被点击
-(void)buttonsXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView productId:(NSString *)productId selectedGoodCount:(NSString *)selectedGoodCount;

//点击规格cell方法
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId;



@required//必须实现的方法

@end





@interface XMFSelectGoodsTypeView : UIView

/** 数量 */
@property (weak, nonatomic) IBOutlet UITextField *amountTfd;


-(void)show;

-(void)hide;


/** 商品属性的总model */
@property (nonatomic, strong) XMFHomeGoodsPropertyModel *propertyModel;

/** 选中的产品类型model */
@property (nonatomic, strong) XMFHomeGoodsPropertyProductsModel *selectedProductModel;

/** 代理 */
@property (nonatomic, weak) id<XMFSelectGoodsTypeViewDelegate> delegate;

/** block回调 */
@property (nonatomic, copy) void (^selectGoodsTypeBlock)(XMFHomeGoodsPropertyProductsModel *productModel , NSString *selectedGoodCount);


/** 2.1商品规格model */
@property (nonatomic, strong) XMFGoodsSpecInfoModel *specInfoModel;


/** 2.1 Block回调 */
@property (nonatomic, copy) void (^selectGoodsSpecInfoBlock)(NSString *goodsId , NSString *selectedGoodCount);


/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;



@end

NS_ASSUME_NONNULL_END
