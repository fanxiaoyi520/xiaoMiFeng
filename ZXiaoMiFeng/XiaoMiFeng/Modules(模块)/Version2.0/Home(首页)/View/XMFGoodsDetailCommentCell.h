//
//  XMFGoodsDetailCommentCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class XMFHomeGoodsDetailGoodsCommentsModel;

@class XMFGoodsCommentModel;

@interface XMFGoodsDetailCommentCell : UICollectionViewCell

/** 商品详情的评论model */
@property (nonatomic, strong) XMFGoodsCommentModel *commentModel;

/** 评论列表的model */
@property (nonatomic, strong) XMFGoodsCommentModel *commentListModel;


@end

NS_ASSUME_NONNULL_END
