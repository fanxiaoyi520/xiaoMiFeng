//
//  XMFBaseUseingTabarController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseUseingTabarController.h"
#import "XMFBaseNavigationController.h"//导航控制器
#import "XMFHomeSimpleController.h"//VIP尊享版首页
#import "XMFHomeController.h"//标准版首页
#import "XMFShoppingCartViewController.h"//购物车
#import "XMFMeViewController.h"//我的
#import "XMFThemeController.h"//专题



@interface XMFBaseUseingTabarController ()<AxcAE_TabBarDelegate>

@end

@implementation XMFBaseUseingTabarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //添加登录状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
    // 添加子VC
    [self addChildViewControllers];
    

    
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    
    BOOL loginSuccess = [notification.object boolValue];
    
    NSDictionary  *responseObjectDic = notification.userInfo;
    
    
    if (loginSuccess) {
        
        
        NSDictionary *userInfoDic = responseObjectDic[@"data"][@"userInfoBaseVo"];
        
        //保存用户信息
        [UserInfoManager updateUserInfo:userInfoDic];
        
        //单独保存token
        [UserInfoManager updateValue:responseObjectDic[@"data"][@"token"] forKey:@"token"];
        
        //单独保存tokenExpire
        [UserInfoManager updateValue:responseObjectDic[@"tokenExpire"] forKey:@"tokenExpire"];
        
        
//        self.selectedIndex = 0;
        
        
//        [self.view makeToastOnCenter:@"登录成功"];

        
    }else{
        
//        [self.view makeToastOnCenter:@"登录失败"];
        
    }
    
    
}


- (void)addChildViewControllers{
    // 创建选项卡的数据 想怎么写看自己，这块我就写笨点了
    
    NSDictionary *homeDic;
    
    if (UserInfoModel.skinType == simple) {
        
        //简易版
        homeDic = @{@"vc":[XMFHomeSimpleController new],@"normalImg":@"icon_home_line",@"selectImg":@"icon_home_fill",@"itemTitle":@"首页"};
        
//        homeDic = @{@"vc":[XMFHomeSimpleController new],@"normalImg":@"icon_wushi",@"selectImg":@"icon_wushi_s",@"itemTitle":@"首页"};
        
    }else{
        
        //标准版
        homeDic = @{@"vc":[XMFHomeController new],@"normalImg":@"icon_home_line",@"selectImg":@"icon_home_fill",@"itemTitle":@"首页"};
        
//        homeDic = @{@"vc":[XMFHomeController new],@"normalImg":@"icon_wushi",@"selectImg":@"icon_wushi_s",@"itemTitle":@"首页"};
    }
    
    
    
    
    NSArray <NSDictionary *>*VCArray =
    @[
    
        homeDic,
        
        
        @{@"vc":[XMFThemeController new],@"normalImg":@"icon_zhuanti",@"selectImg":@"icon_zhuanti_fill",@"itemTitle":@"专题"},
        
        
        @{@"vc":[XMFShoppingCartViewController new],@"normalImg":@"icon_gouwuche_line",@"selectImg":@"icon_gouwuche_fill",@"itemTitle":@"购物车"},
        
        
        @{@"vc":[XMFMeViewController new],@"normalImg":@"icon_gr",@"selectImg":@"icon_gr_fill",@"itemTitle":@"个人中心"}
         
        
        /*
        @{@"vc":[XMFThemeController new],@"normalImg":@"icon_denglong",@"selectImg":@"icon_denglong_s",@"itemTitle":@"专题"},
        
        
        @{@"vc":[XMFShoppingCartViewController new],@"normalImg":@"icon_fuzi",@"selectImg":@"icon_fuzi_s",@"itemTitle":@"购物车"},
        
        
        @{@"vc":[XMFMeViewController new],@"normalImg":@"icon_mifeng",@"selectImg":@"icon_mifeng_s",@"itemTitle":@"个人中心"}
        */
        
    
    ];
    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.根据集合来创建TabBar构造器
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        // 3.item基础数据三连
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        // 4.设置单个选中和不选中item标题状态下的颜色
        model.normalColor = UIColorFromRGB(0x666666);
        model.selectColor = UIColorFromRGB(0x333333);
//        model.isRepeatClick = YES;
        // 大小
//        model.itemSize = CGSizeMake(KScaleWidth(75), 49);
        model.itemSize = CGSizeMake(KScreenW/4.0, 49);
        model.automaticHidden = YES;
        
        // 备注 如果一步设置的VC的背景颜色，VC就会提前绘制驻留，优化这方面的话最好不要这么写
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        
        // 用自定义的导航控制器包装tabBarController每一个子控制器
        XMFBaseNavigationController *navi = [[XMFBaseNavigationController alloc] initWithRootViewController:vc];

        // 5.将VC添加到系统控制组
        [tabBarVCs addObject:navi];
        // 5.1添加构造Model到集合
        [tabBarConfs addObject:model];
    }];
    // 5.2 设置VCs -----
    // 一定要先设置这一步，然后再进行后边的顺序，因为系统只有在setViewControllers函数后才不会再次创建UIBarButtonItem，以免造成遮挡
    // 大意就是一定要让自定义TabBar遮挡住系统的TabBar
    self.viewControllers = tabBarVCs;
    //////////////////////////////////////////////////////////////////////////
    // 注：这里方便阅读就将AE_TabBar放在这里实例化了 使用懒加载也行
    // 6.将自定义的覆盖到原来的tabBar上面
    // 这里有两种实例化方案：
    // 6.1 使用重载构造函数方式：
//    self.axcTabBar = [[AxcAE_TabBar alloc] initWithTabBarConfig:tabBarConfs];
    // 6.2 使用Set方式：
    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.backgroundColor = KWhiteColor;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.设置委托
    self.axcTabBar.delegate = self;
    // 8.添加覆盖到上边
    [self.tabBar addSubview:self.axcTabBar];
    [self addLayoutTabBar]; // 10.添加适配
}
// 9.实现代理，如下：
- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    

    if (index == 10) {
        
        self.axcTabBar.currentSelectItem.selected = YES;
        
        // 不带图片
        PopoverAction *action1 = [PopoverAction actionWithTitle:@"小蜜蜂餐饮" handler:^(PopoverAction *action) {
            
            // 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
            
            //小蜜蜂产品
            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            
            productVC.urlStr = @"https://dc.xmfstore.com/dingzuo-h5/#/home";
            
            XMFBaseNavigationController *productNaviVc = [[XMFBaseNavigationController alloc]initWithRootViewController:productVC];
            
            //模态的方式铺满全屏
            productNaviVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:productNaviVc animated:YES completion:nil];
            
            
            
        }];
        
        /*
         PopoverAction *action2 = [PopoverAction actionWithTitle:@"送电BeeBee" handler:^(PopoverAction *action) {
         
         
         [MBProgressHUD showOnlyTextToView:kAppWindow title:@"等待配置网址"];
         
         
         }];*/
        
        
        
        PopoverView *popoverView = [PopoverView popoverView];
        popoverView.showShade = YES;
        popoverView.style = PopoverViewStyleDark;
       // 点击外部时允许隐藏
        popoverView.hideAfterTouchOutside = YES;
        
        CGPoint thirdTabbarItemPoint = CGPointMake(self.view.frame.size.width * 5 / 8.0, self.tabBar.frame.origin.y);
        
        
        [popoverView showToPoint:thirdTabbarItemPoint withActions:@[action1]];
        
        
    
        
    }else{
        
        // 通知 切换视图控制器
         [self setSelectedIndex:index];
    }
    
 
    // 自定义的AE_TabBar回调点击事件给TabBarVC，TabBarVC用父类的TabBarController函数完成切换
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
        
    }
}

// 10.添加适配
- (void)addLayoutTabBar{
    // 使用重载viewDidLayoutSubviews实时计算坐标 （下边的 -viewDidLayoutSubviews 函数）
    // 能兼容转屏时的自动布局
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.axcTabBar.frame = self.tabBar.bounds;
    [self.axcTabBar viewDidLayoutItems];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
