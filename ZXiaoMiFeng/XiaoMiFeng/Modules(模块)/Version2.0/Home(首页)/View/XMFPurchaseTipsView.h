//
//  XMFPurchaseTipsView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/25.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsDetailModel;

@class XMFHomeGoodsDetailPurchaseInstructionsModel;


@interface XMFPurchaseTipsView : UIView

-(void)show;

-(void)hide;

//内容文字
@property (nonatomic, copy) NSString *contentStr;


@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 购物说明model数组 */
@property (nonatomic, strong) NSArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> *instructionsModelArr;

@end

NS_ASSUME_NONNULL_END
