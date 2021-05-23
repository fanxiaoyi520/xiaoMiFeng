//
//  XMFConfirmOrderCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFConfirmOrderGoodsListModel;

@interface XMFConfirmOrderCell : UITableViewCell

/** 商品model */
@property (nonatomic, strong) XMFConfirmOrderGoodsListModel *goodsListModel;

@end

NS_ASSUME_NONNULL_END
