//
//  XMFBaseNavigationController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseNavigationController.h"

@interface XMFBaseNavigationController ()

@end

@implementation XMFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// 禁止旋转
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}

#pragma mark - 方法
+ (void)initialize
{
    // 设置所有的NavigationBar的title字体属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

// 设置顶部状态栏
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

/**
 拦截push操作

 @param viewController 将要push入栈的控制器
 @param animated 是否动画入栈
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        // 当前导航栏, 只有第一个viewController push的时候设置隐藏
        if (self.viewControllers.count == 1) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
//        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backBeforeVC) image:@"icon_common_return" highlightedImage:@"icon_common_return"];
    } else {
        // 设置透明颜色才一致
        self.navigationBar.translucent = NO;
        
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:YES];
}


#pragma mark -- 点击方法
- (void)backBeforeVC
{
    [self popViewControllerAnimated:YES];
    DLog(@"返回上一个VC");
}


@end
