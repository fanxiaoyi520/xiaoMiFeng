//
//  XMFConfirmOrderCell.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/2.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFConfirmOrderGoodsListModel;

@interface XMFConfirmOrderCell : UITableViewCell

/** εεmodel */
@property (nonatomic, strong) XMFConfirmOrderGoodsListModel *goodsListModel;

@end

NS_ASSUME_NONNULL_END
