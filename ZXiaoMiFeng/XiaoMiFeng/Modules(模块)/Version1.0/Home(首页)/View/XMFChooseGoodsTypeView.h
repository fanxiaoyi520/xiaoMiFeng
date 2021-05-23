//
//  XMFChooseGoodsTypeView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
 1、首页 —— 包含：客服，收藏，加入购物车，立即购买；
 2、商品详情页 —— 商品选择，包含：加入购物车；
 3、商品详情页 —— 加入购物车，包含：确定；
 4、商品详情页 —— 立即购买，包含：确定购买；
 
 */

typedef enum : NSUInteger {
    
    goodsListAddCart,
    goodsDetailChooseType,
    goodsDetailAddCart,
    goodsDetailSoonPay,
    
} chooseGoodsType;



@class XMFGoodsDatailModel;

@class XMFGoodsDatailProductListModel;

@class XMFChooseGoodsTypeView;

@protocol XMFChooseGoodsTypeViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFChooseGoodsTypeViewDidClick:(XMFChooseGoodsTypeView *)typeView button:(UIButton *)button;


@required//必须实现的方法

@end


@interface XMFChooseGoodsTypeView : UIView

//收藏
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

//数量
@property (weak, nonatomic) IBOutlet UITextField *amountTfd;

//商品详情model
@property (nonatomic, strong) XMFGoodsDatailModel *model;

//类型
@property (nonatomic, assign) chooseGoodsType chooseType;

@property (nonatomic, weak) id<XMFChooseGoodsTypeViewDelegate> delegate;

-(void)show;

-(void)hide;

//选中的商品
@property (nonatomic, copy) void (^ChooseGoodsTypeBlock)(XMFGoodsDatailProductListModel *productModel , NSString *selectedGoodCount);

//选中的产品类型model
@property (nonatomic, strong) XMFGoodsDatailProductListModel *selectedProductModel;




@end

NS_ASSUME_NONNULL_END
