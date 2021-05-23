//
//  XMFGoodsDetailSpecificationListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailValueListModel;


@interface XMFGoodsDetailSpecificationListModel : NSObject

@property (nonatomic, copy) NSString *name;


@property (nonatomic, strong) NSArray<XMFGoodsDetailValueListModel *> *valueList;

@end

NS_ASSUME_NONNULL_END
