//
//  XMFBaseTabBarController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseTabBarController.h"
#import "XMFBaseNavigationController.h"//导航控制器
#import "XMFHomeViewController.h"//首页
#import "XMFShoppingCartController.h"//购物车
//#import "XMFProductViewController.h"//小蜜蜂产品
#import "XMFMineViewController.h"//我的



@interface XMFBaseTabBarController ()<UITabBarDelegate>

@end

@implementation XMFBaseTabBarController


-(instancetype)init{
    
    if (self = [super init]) {
        
//        [self createTabbar];
//        self.tabBar.backgroundColor = [UIColor whiteColor];
//        self.tabBar.translucent = NO;
//        self.tabBar.delegate = self;
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    /*
     
     //设置SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
     
     */
}




/*
#pragma mark mark
- (void)createTabbar{

    
    
    //首页
    XMFHomeViewController *homeVC = [[XMFHomeViewController alloc] init];

    [self addChildVc:homeVC Title:@"首页" Image:@"icon_home_line" selectedImage:@"icon_home_fill"];
    
    //购物车
    XMFShoppingCartController *cartVC = [[XMFShoppingCartController alloc] init];
    
     [self addChildVc:cartVC Title:@"购物车" Image:@"icon_gouwuche_line" selectedImage:@"icon_gouwuche_fill"];

    
    //小蜜蜂产品
    
    
    XMFProductsViewController *productVC = [[XMFProductsViewController alloc]init];
    
     [self addChildVc:productVC Title:@"小蜜蜂产品" Image:@"icon_xmf" selectedImage:@"icon_xmf_fill"];
    
    
    //我的
    XMFMineViewController  *mineVc = [[XMFMineViewController alloc] init];
    
    [self addChildVc:mineVc Title:@"个人中心" Image:@"icon_gr" selectedImage:@"icon_gr_fill"];
    
    
}

#pragma mark - 方法
//
 //*  添加一个子控制器
// *
// *  @param childVc       子控制器
// *  @param title         名字
// *  @param image         图片
// *  @param selectedImage 选中时的图片
 //
- (void)addChildVc:(UIViewController *)childVc Title:(NSString *)title Image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    
    //设置子控制器的标题和图片
    // 同时设置tabbar和navigationBar的文字
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    

    // 默认文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFang-SC-Medium" size:9.0];
    textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x666666);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
     
    
    
    // 选中文字样式
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:9.0];
    selectTextAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x333333);
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    //防止pop回来之后就变成系统的蓝色,设置tintcolor与选中的颜色一样
    self.tabBar.tintColor = UIColorFromRGB(0x333333);
    
    
    // 用自定义的导航控制器包装tabBarController每一个子控制器
    XMFBaseNavigationController *navi = [[XMFBaseNavigationController alloc] initWithRootViewController:childVc];
    
    // 添加为子控制器
    [self addChildViewController:navi];
    
    
    
    //设置tabbar的背景为透明
//    self.tabBar.backgroundImage = [self imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
//
//    [self.tabBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]]];
//
//    [self.tabBar setShadowImage:[UIImage new]];
     
 
}

//颜色转生成图片
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
