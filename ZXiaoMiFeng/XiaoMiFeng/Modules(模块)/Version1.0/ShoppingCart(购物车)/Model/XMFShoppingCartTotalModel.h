//
//  XMFShoppingCartTotalModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFShoppingCartTotalModel : NSObject

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *checkedGoodsCount;

@property (nonatomic, copy) NSString *goodsAmount;

@property (nonatomic, copy) NSString *checkedGoodsAmount;


@end

/**
 
 {
   "goodsCount": 5,
   "checkedGoodsCount": 5,
   "goodsAmount": 965.78,
   "checkedGoodsAmount": 965.78
 }
 
 
 */

NS_ASSUME_NONNULL_END
