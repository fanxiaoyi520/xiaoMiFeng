//
//  AppDelegate.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "AppDelegate.h"
#import "AvoidCrash.h"//防闪退
#import "NSArray+AvoidCrash.h"//防闪退
#import "XMFBaseUseingTabarController.h"

//支付SDK
#import "ZDPay_OrderSureViewController.h"



#import "XMFGoodsDetailViewController.h"//商品详情



@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

//创建单例
+(AppDelegate *)shareAppDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
  
    //第三方登录初始化
    [self setThirdLogin:application LaunchOptions:launchOptions];
    
    [self setupIQKeyBoard];//键盘处理
    
    [self avoidCrashMethod];//启动防闪退
    
    //这里一定要强引用self.baseVc为属性，要不然后面会不执行代理方法
    self.baseTabBarVc = [[XMFBaseUseingTabarController alloc] init];
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置window的背景颜色，防止有些present控制器的时候背景黑屏
    self.window.backgroundColor = KWhiteColor;
    
    self.window.rootViewController = self.baseTabBarVc;
    
    [self.window makeKeyAndVisible];
    

    return YES;
    
    
    
}



// NOTE: 9.0以后使用新API接口，由于APP不支持9.0以前系统所以仅使用此方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
//    return [[ZDPay_OrderSureViewController manager] handleOpenURL:url];
    
    
   if ([[GIDSignIn sharedInstance] handleURL:url]) {
        //谷歌登录
        
        return [[GIDSignIn sharedInstance] handleURL:url];
        
    }else if ([WXApi handleOpenURL:url delegate:self]){
        //微信
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]){
        
        //脸书登录
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }else if ([url.scheme isEqualToString:@"iosbemallxiaomifeng"]){
        
        DLog(@"scheme:%@\nhost:%@\nquery:%@",url.scheme,url.host,url.query);
        
        //从H5打开指定页面
        
        /*
        [MBProgressHUD showSuccess:@"唤起成功" toView:kAppWindow];
        
        
        XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:@"1181765"];
        
        XMFBaseNavigationController *naviVc = [[XMFBaseNavigationController alloc]initWithRootViewController:VCtrl];

        //模态的方式铺满全屏
        naviVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
        [self.window.rootViewController presentViewController:naviVc animated:YES completion:^{
            
            
        }];
        */
    
        
        
        return YES;
         
      
        
        
    }else if([[ZDPay_OrderSureViewController manager] handleOpenURL:url]) {
           
        return [[ZDPay_OrderSureViewController manager] handleOpenURL:url];
    
    }else{
        
        return YES;
    }
    
    
}




#pragma mark - ——————— Universal Links相关方法 ————————


// 在AppDelegate中实现下面的方法，当使用Universal Links唤醒app时会执行此方法
-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        
        NSURL *webpageURL = userActivity.webpageURL;
        
        
         [[ZDPay_OrderSureViewController manager] handleOpenURL:webpageURL];
        
        
        [WXApi handleOpenUniversalLink:userActivity delegate:self];
        
        /*
        //处理URL
        NSString *host = webpageURL.host;
        
        if ([host isEqualToString:@"apple..com"]) {
            //进行我们需要的处理
            
            
        }else {
            
//            [[UIApplication sharedApplication]openURL:webpageURL];
        }*/
        
    }
    return YES;
    
}


//注意：微信和QQ回调方法用的是同一个，这里注意判断resp类型来区别分享来源
- (void)onResp:(id)resp{

    if([resp isKindOfClass:[SendMessageToWXResp class]]){//微信回调
        
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;

        if(response.errCode == WXSuccess){
            //目前分享回调只会走成功
            NSLog(@"分享完成");
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类

        SendAuthResp *req = (SendAuthResp *)resp;
        if([req.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
            NSLog(@"微信登录完成，code：%@", req.code);//获取到第一步code
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:req];
            
        }
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
        
        WXLaunchMiniProgramResp *req = (WXLaunchMiniProgramResp *)resp;
        NSLog(@"%@", req.extMsg);// 对应JsApi navigateBackApplication中的extraData字段数据
    }
}



/*
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSLog(@"continueUserActiity enter");
    NSLog(@"\tAction Type : %@", userActivity.activityType);
    NSLog(@"\tURL         : %@", userActivity.webpageURL);
    NSLog(@"\tuserinfo :%@",userActivity.userInfo);
     
    NSLog(@"continueUserActiity exit");
    restorationHandler(nil);
     
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:userActivity.webpageURL];
 
     NSLog(@"COOKIE{name: %@", cookies);
    
        if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
            
            NSURL *webpageURL = userActivity.webpageURL;
            [[ZDPay_OrderSureViewController manager] handleOpenURL:webpageURL];
        }
    return YES;
}*/



#pragma mark - ——————— 自定义方法 ————————


/**
 设置键盘管理器
 */
- (void)setupIQKeyBoard {
    
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;

    // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
    // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = NO;
    // 设置占位文字的字体
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17];
    
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";//完成，简繁体一样
    
    
    /*
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //默认为YES，关闭为NO
    manager.enable = YES;
    //键盘弹出时，点击背景，键盘收回
    manager.shouldResignOnTouchOutside = YES;
    //如果YES，那么使用textField的tintColor属性为IQToolbar，否则颜色为黑色。默认是否定的。
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //如果YES，则在IQToolbar上添加textField的占位符文本。默认是肯定的。
    manager.shouldShowToolbarPlaceholder = YES;
    //设置IQToolbar按钮的文字
    manager.toolbarDoneBarButtonItemText = @"完成";
    //隐藏键盘上面的toolBar,默认是开启的
    manager.enableAutoToolbar = YES;
  */
}


//防止闪退配置
-(void)avoidCrashMethod{
    
    //启动防止崩溃功能(注意区分becomeEffective和makeAllEffective的区别)
    //具体区别请看 AvoidCrash.h中的描述
    //建议在didFinishLaunchingWithOptions最初始位置调用 上面的方法
    
    [AvoidCrash makeAllEffective];
    
    //若出现unrecognized selector sent to instance导致的崩溃并且控制台输出:
    //-[__NSCFConstantString initWithName:age:height:weight:]: unrecognized selector sent to instance
    //你可以将@"__NSCFConstantString"添加到如下数组中，当然，你也可以将它的父类添加到下面数组中
    //比如，对于部分字符串，继承关系如下
    //__NSCFConstantString --> __NSCFString --> NSMutableString --> NSString
    //你可以将上面四个类随意一个添加到下面的数组中，建议直接填入 NSString
    NSArray *noneSelClassStrings = @[
                                     @"NSString"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
    
}


//防止闪退接收异常的通知
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
   DLog(@"%@",note.userInfo);
}

#pragma mark - ——————— 第三方初始化 ————————

-(void)setThirdLogin:(UIApplication *)application LaunchOptions:(NSDictionary *)launchOptions{
    
    
       // Firebase 初始化配置
       [FIRApp configure];
       
       [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
       
       
       // 为了使用 Facebook SDK 应该调用如下方法
       [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
       // 注册 FacebookAppID
       [FBSDKSettings setAppID:kFacebookAppID];

    
       
       //微信初始化，向微信注册
       [WXApi registerApp:APP_ID
       universalLink:UNIVERSAL_LINK];
    
    
}


#pragma mark - ——————— 获取控制器 ————————
/**获取Window当前显示的ViewController*/
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
             break;
         }
     }
     return vc;
 }

/*
 
 如果我们不开发iPadOS多窗口APP，SceneDelegate窗口管理我们可以不需要直接删掉就好了。

 1、删除掉info.plist中Application Scene Manifest选项，同时，文件SceneDelegate可删除可不删
 2、下面两个方法相关代码注释掉
 
 3、AppDelegate.h中添加属性@property (strong, nonatomic) UIWindow * window;

 
 
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

 */

@end
