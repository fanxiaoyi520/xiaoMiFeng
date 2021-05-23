//
//  XMFOrderInfoConfirmCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderCheckedGoodsListModel;

@interface XMFOrderInfoConfirmCell : UITableViewCell

//商品信息model
@property (nonatomic, strong) XMFOrderCheckedGoodsListModel *goodListModel;



@end

NS_ASSUME_NONNULL_END
