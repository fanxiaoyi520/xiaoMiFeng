//
//  AppDelegate.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/8.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMFBaseUseingTabarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

//æ³¨æè¿éæå±æ§åå¨è¿éæ¯ä¸ºäºæ¹ä¾¿AppDelegateçåç±»ä½¿ç¨
@property (nonatomic, strong) XMFBaseUseingTabarController *baseTabBarVc;

//åä¾
+(AppDelegate *)shareAppDelegate;

@end

