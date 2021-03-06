//
//  XMFMyAuthenticationListModel.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/10/27.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMyAuthenticationListModel : NSObject

/** ่ฎค่ฏๆ ่ฎฐ */
@property (nonatomic, copy) NSString *authenId;

/** ่บซไปฝ่ฏๅท */
@property (nonatomic, copy) NSString *idCardNo;

/** ่ฎค่ฏๅงๅ */
@property (nonatomic, copy) NSString *realName;


/*
"id": 1,
"idCardNo": 101010101010,
"realName": "ๅผ ไธ"
*/
@end

NS_ASSUME_NONNULL_END
