//
//  EqualPchHeader.h
//  thirdLgoin
//
//  Created by ðå°èèð on 2020/6/27.
//  Copyright Â© 2020 å°èè. All rights reserved.
//

#ifndef EqualPchHeader_h
#define EqualPchHeader_h


#pragma mark - âââââââ ç¬¬ä¸æ¹å¤´æä»¶åå®å®ä¹(æ¬åºæ¾å°AppDelegateé) ââââââââ
//è°·æ­éç½®
#import <Firebase.h>
#import <GoogleSignIn/GoogleSignIn.h>


//è¸ä¹¦éç½®
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define kFacebookAppID  @"939612749844666"//è¸ä¹¦ï¼åºç¨ç¨å¼ç¼å·


//å¾®ä¿¡éç½®
#import "WXApi.h"

#define APP_ID @"wx53a612d04b9e1a22"
#define UNIVERSAL_LINK @"https://www.bmall.com.hk/.well-known/apple-app-site-association/"



#pragma mark - âââââââ å·¥å· ââââââââ
#import "UtilsMacros.h"//å®å®ä¹
#import "XMFURLSuffixString.h"//æ¥å£å°åå®å®ä¹
#import "XMFNetworking.h"//ç½ç»è¯·æ±å·¥å·
#import "UIView+FrameCategory.h"//UIViewçåç±»
#import "UILabel+YBAttributeTextTapAction.h"//UIlabelææ¬å¯ç¹å»
#import "UIView+GFCorner.h"//ååè§
#import "UIView+GFBorder.h"//å è¾¹æ¡
#import "DateUtils.h"//æ¶é´æ¥æå·¥å·
#import "XMFCommonManager.h"//å¨å±éç½®
#import "UIView+Toast.h"//æç¤ºè¯­
#import "UIView+XMFToast.h"//æç¤ºè¯­çå°è£
#import "NSDictionary+NullObject.h"//å¤æ­å­æ®µæ¯å¦ä¸ºç©º
#import "NSString+Verify.h"//æå­æ ¡éª
#import "LimitInput.h"//éå¶è¾å¥
#import "UIButton+XMFImageTitlePosition.h"//æé®æå­å¾çä½ç½®è®¾ç½®


#pragma mark - âââââââ æ§å¶å¨ ââââââââ
#import "XMFBaseViewController.h"//åºç±»æ§å¶å¨
#import "XMFBaseNavigationController.h"//å¯¼èªæ§å¶å¨
#import "XMFResponseObjectModel.h"//è¿åæ°æ®å½ç±»model
#import "YYModel.h"//æ°æ®æ¨¡åå·¥å·
#import "LYEmptyViewHeader.h"//å ä½å¾
#import "XMFAlertController.h"//ç»§æ¿æ§å¼¹æ¡
#import "IQKeyboardManager.h"//é®çå¤ç

#import <JXTAlertManager/JXTAlertManagerHeader.h>//å¼¹æ¡
#import "XMFPlatformInfoModel.h"//ç»å½é¡µå¹³å°ä¿¡æ¯



#pragma mark - âââââââ éç¥åç§° ââââââââ

#define KPost_LoginSDK_Notice_LoginStatusChange @"LoginSDK_Notice_LoginStatusChange"


#endif /* EqualPchHeader_h */
