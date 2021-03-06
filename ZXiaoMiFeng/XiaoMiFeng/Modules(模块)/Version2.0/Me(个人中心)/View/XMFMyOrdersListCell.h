//
//  XMFMyOrdersListCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/31.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListGoodsListModel;

@interface XMFMyOrdersListCell : UITableViewCell

/** ๆ็่ฎขๅๅ่กจmodel */
@property (nonatomic, strong) XMFMyOrdersListGoodsListModel *goodsListModel;

/** ่ฎขๅ่ฏฆๆๅๅmodel */
@property (nonatomic, strong) XMFMyOrdersListGoodsListModel *detailGoodsModel;

@end

NS_ASSUME_NONNULL_END
