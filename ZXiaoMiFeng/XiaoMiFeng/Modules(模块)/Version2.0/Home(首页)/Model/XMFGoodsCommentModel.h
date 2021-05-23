//
//  XMFGoodsCommentModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/** 追加评论的model */
@interface XMFGoodsCommentAppendModel : NSObject

@property (nonatomic, strong) NSArray *picUrls;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@end


@interface XMFGoodsCommentModel : NSObject

/** 评论时间 */
@property (nonatomic, copy) NSString * addTime;
/** 追评内容 */
@property (nonatomic, copy) NSString * appendComment;
/** 评论内容 */
@property (nonatomic, copy) NSString * content;
/** 评论图片列表 */
@property (nonatomic, strong) NSArray * picUrls;
/** 商品规格 */
@property (nonatomic, copy) NSString * specifications;
/** 评论人头像 */
@property (nonatomic, copy) NSString * userIcon;
/** 评论人id */
@property (nonatomic, copy) NSString * userId;
/** 评论人名称 */
@property (nonatomic, copy) NSString * userName;

/** 评价的星星数 */
@property (nonatomic, copy) NSString *star;

/** 人工加入：商品id */
@property (nonatomic, copy) NSString *goodsId;

@end

NS_ASSUME_NONNULL_END
