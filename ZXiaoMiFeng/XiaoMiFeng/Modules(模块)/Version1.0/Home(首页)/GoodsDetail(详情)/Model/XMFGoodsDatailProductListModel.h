//
//  XMFGoodsDatailProductListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDatailProductListModel : NSObject

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *freeShipping;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsSn;

@property (nonatomic, copy) NSString * grossWeight;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString * incomeTax;

@property (nonatomic, copy) NSString * netWeight;

@property (nonatomic, copy) NSString * number;

@property (nonatomic, copy) NSString * postage;

@property (nonatomic, copy) NSString * price;

@property (nonatomic, strong) NSArray<NSString *> * specifications;

@property (nonatomic, copy) NSString * taxFlag;

@property (nonatomic, copy) NSString * taxHsCode;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *version;



@end

NS_ASSUME_NONNULL_END
