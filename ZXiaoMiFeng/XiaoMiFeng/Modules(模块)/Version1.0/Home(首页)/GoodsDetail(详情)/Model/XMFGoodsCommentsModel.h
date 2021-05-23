//
//  XMFGoodsCommentsModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsCommentsModel : NSObject

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *commentsId;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray *picList;

@property (nonatomic, strong) NSArray *specifications;


@end

/**
 
 {
     "addTime":"2020-05-11 10:26:05",
     "picList":[
         "http://test19.qtopay.cn/wx/storage/fetch-imgfile/jpeg/20200511102512.jpeg",
         "http://test19.qtopay.cn/wx/storage/fetch-imgfile/jpeg/20200511102521.jpeg",
         "http://test19.qtopay.cn/wx/storage/fetch-imgfile/jpeg/20200511102528.jpeg"
     ],
     "nickname":"",
     "id":1355,
     "avatar":"https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/2dcsydzr3ggf8lscmx3q.png",
     "specifications":[
         "150*132"
     ],
     "content":"123"
 }
 
 */

NS_ASSUME_NONNULL_END
