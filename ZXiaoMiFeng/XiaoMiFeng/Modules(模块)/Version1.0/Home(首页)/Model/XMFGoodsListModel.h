//
//  XMFGoodsListModel.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/24.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
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
     brief = "ไปชๅพ3Dๅกซๅ๏ผๅๅฎ็ๆปก่ถณๆ111";
     id = 1181019;
     name = "ใๆต่ฏๅๅๅฟๅ  ใ300ๆ นๅจๆฃ็พฝไธ็ปๆฑๆ่ฏ";
     picUrl = "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/n89mkecwd33jwy8hq0av.jpg";
     retailPrice = "99.90000000000001";
     supplierId = 4;
 }
 
 */

NS_ASSUME_NONNULL_END
