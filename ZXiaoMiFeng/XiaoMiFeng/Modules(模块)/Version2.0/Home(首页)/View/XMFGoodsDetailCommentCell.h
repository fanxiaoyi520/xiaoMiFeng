//
//  XMFGoodsDetailCommentCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/24.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class XMFHomeGoodsDetailGoodsCommentsModel;

@class XMFGoodsCommentModel;

@interface XMFGoodsDetailCommentCell : UICollectionViewCell

/** ๅๅ่ฏฆๆ็่ฏ่ฎบmodel */
@property (nonatomic, strong) XMFGoodsCommentModel *commentModel;

/** ่ฏ่ฎบๅ่กจ็model */
@property (nonatomic, strong) XMFGoodsCommentModel *commentListModel;


@end

NS_ASSUME_NONNULL_END
