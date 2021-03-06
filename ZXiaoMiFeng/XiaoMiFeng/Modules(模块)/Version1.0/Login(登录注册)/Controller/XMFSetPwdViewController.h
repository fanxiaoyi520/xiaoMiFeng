//
//  XMFSetPwdViewController.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/22.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    forgetPwdSetPwd,//ๅฟ่ฎฐๅฏ็ 
    resetPwd,//้็ฝฎๅฏ็ 
    registerSetPwd,//ๆณจๅ
} setPwdType;

@interface XMFSetPwdViewController : XMFBaseViewController

@property (nonatomic, assign) setPwdType pwdType;

//่ชๅฎไนinitๆนๆณ
-(instancetype)initWithType:(setPwdType)pwdType;


//้ช่ฏ็ 
@property (nonatomic, copy) NSString *codeStr;

//ๅบๅท
@property (nonatomic, copy) NSString *areaCodeStr;

//ๆๆบๅท
@property (nonatomic, copy) NSString *phoneStr;



@end

NS_ASSUME_NONNULL_END
