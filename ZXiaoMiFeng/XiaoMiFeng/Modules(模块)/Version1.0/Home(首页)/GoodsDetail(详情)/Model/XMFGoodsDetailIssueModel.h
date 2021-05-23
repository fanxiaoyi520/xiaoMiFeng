//
//  XMFGoodsDetailIssueModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDetailIssueModel : NSObject

@property (nonatomic, copy) NSString *issueId;

@property (nonatomic, copy) NSString *question;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *version;



@end

/**
 
 {
     "id":3,
     "question":"如何申请退货？",
     "answer":"以下情况可以申请退货：如收到商品后发现与订单不符、严重质量问题或快递公司丢失商品，请在签收后7天内通过“小蜜蜂跨境电商”微信公众号联系客服。",
     "addTime":"2018-02-01 00:00:00",
     "deleted":false,
     "version":0
 }
 
 */

NS_ASSUME_NONNULL_END
