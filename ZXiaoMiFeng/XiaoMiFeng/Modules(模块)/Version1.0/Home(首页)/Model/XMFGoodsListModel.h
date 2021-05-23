//
//  XMFGoodsListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsListModel : NSObject

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *goodId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *retailPrice;

@property (nonatomic, copy) NSString *supplierId;


@property (nonatomic, copy) NSString *number;

@end

/**
 
 {
     brief = "仪征3D填充，充实的满足感111";
     id = 1181019;
     name = "【测试商品勿删 】300根全棉羽丝绒抱枕芯";
     picUrl = "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/n89mkecwd33jwy8hq0av.jpg";
     retailPrice = "99.90000000000001";
     supplierId = 4;
 }
 
 */

NS_ASSUME_NONNULL_END
