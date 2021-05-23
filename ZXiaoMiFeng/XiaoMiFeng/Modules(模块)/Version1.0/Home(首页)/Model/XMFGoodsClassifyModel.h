//
//  XMFGoodsClassifyModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsClassifyModel : NSObject

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *enabled;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *classifyId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pics;

@property (nonatomic, copy) NSString *desc;



@end

/**
 
 {
                deleted = 0;
                enabled = 1;
                icon = "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/a1a09jrxxt01sy0uqlfl.png";
                id = 1181001;
                name = "母婴";
                pics = "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/f9x0pvvuvn0zjsjoz13u.png";
            }
 
 */

NS_ASSUME_NONNULL_END
