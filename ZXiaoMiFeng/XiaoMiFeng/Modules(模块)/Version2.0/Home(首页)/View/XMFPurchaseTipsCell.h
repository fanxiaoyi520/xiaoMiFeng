//
//  XMFPurchaseTipsCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsDetailPurchaseInstructionsModel;

@interface XMFPurchaseTipsCell : UITableViewCell


@property (nonatomic, assign) NSInteger cellRow;


@property (nonatomic, strong) XMFHomeGoodsDetailPurchaseInstructionsModel *instructionsModel;


@end

NS_ASSUME_NONNULL_END
