//
//  AppDelegate.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMFBaseUseingTabarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

//注意这里把属性写在这里是为了方便AppDelegate的分类使用
@property (nonatomic, strong) XMFBaseUseingTabarController *baseTabBarVc;

//单例
+(AppDelegate *)shareAppDelegate;

@end

