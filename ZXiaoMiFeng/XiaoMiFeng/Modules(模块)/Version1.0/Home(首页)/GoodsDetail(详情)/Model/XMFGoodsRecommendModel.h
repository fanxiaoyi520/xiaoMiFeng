//
//  XMFGoodsRecommendModel.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsRecommendModel : NSObject

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *merId;

@property (nonatomic, copy) NSString *commendId;

@property (nonatomic, copy) NSString *retailPrice;

//ๆ็ๆถ่็ฌๆๅญๆฎต
@property (nonatomic, copy) NSString *valueId;

//ไบบๅทฅๅ ๅฅ
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isSelected;

@end

/**
 
 {
     "brief":"ๆต่ฏๆฐๆฎ๏ผๆตๅๆฐๆฎ",
     "picUrl":"https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/gwmfpsj0fape6uf27erb4kn7yqkk.png",
     "addTime":"2020-04-28 13:59:47",
     "goodsId":1182340,
     "name":"song_testing413",
     "merId":38,
     "id":8779,
     "retailPrice":156.19
 }
 
 */

NS_ASSUME_NONNULL_END
