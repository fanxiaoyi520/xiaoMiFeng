//
//  XMFCartCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCartCell;

@class XMFShoppingCartGoodModel;

@class XMFShopCartMiddleModel;

@class XMFShopCartModel;

@class XMFShopCartDetailModel;//购物车多层级model


@protocol XMFCartCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFCartCellDidClick:(XMFCartCell *)cell button:(UIButton *)button;


@required//必须实现的方法

@end

@interface XMFCartCell : UITableViewCell

@property (nonatomic, weak) id<XMFCartCellDelegate> delegate;

//@property (nonatomic, strong) XMFShoppingCartGoodModel *model;


//购物车多层级model中的详情model
@property (nonatomic, strong) XMFShopCartDetailModel *detailModel;

//中间层
@property (nonatomic, strong) XMFShopCartMiddleModel *middleModel;

//最外层model
@property (nonatomic, strong) XMFShopCartModel *cartModel;


/** 记录最终商品的数量*/
@property (nonatomic,assign)NSInteger  goodCout;

@end

NS_ASSUME_NONNULL_END
