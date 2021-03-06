//
//  XMFBaseUseingTabarController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/6/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseUseingTabarController.h"
#import "XMFBaseNavigationController.h"//å¯¼èªæ§å¶å¨
#import "XMFHomeSimpleController.h"//VIPå°äº«çé¦é¡µ
#import "XMFHomeController.h"//æ åçé¦é¡µ
#import "XMFShoppingCartViewController.h"//è´­ç©è½¦
#import "XMFMeViewController.h"//æç
#import "XMFThemeController.h"//ä¸é¢



@interface XMFBaseUseingTabarController ()<AxcAE_TabBarDelegate>

@end

@implementation XMFBaseUseingTabarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //æ·»å ç»å½ç¶æçéç¥
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
    // æ·»å å­VC
    [self addChildViewControllers];
    

    
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark âââââ ç»å½ç¶æå¤ç âââââ
- (void)loginStateChange:(NSNotification *)notification{
    
    
    BOOL loginSuccess = [notification.object boolValue];
    
    NSDictionary  *responseObjectDic = notification.userInfo;
    
    
    if (loginSuccess) {
        
        
        NSDictionary *userInfoDic = responseObjectDic[@"data"][@"userInfoBaseVo"];
        
        //ä¿å­ç¨æ·ä¿¡æ¯
        [UserInfoManager updateUserInfo:userInfoDic];
        
        //åç¬ä¿å­token
        [UserInfoManager updateValue:responseObjectDic[@"data"][@"token"] forKey:@"token"];
        
        //åç¬ä¿å­tokenExpire
        [UserInfoManager updateValue:responseObjectDic[@"tokenExpire"] forKey:@"tokenExpire"];
        
        
//        self.selectedIndex = 0;
        
        
//        [self.view makeToastOnCenter:@"ç»å½æå"];

        
    }else{
        
//        [self.view makeToastOnCenter:@"ç»å½å¤±è´¥"];
        
    }
    
    
}


- (void)addChildViewControllers{
    // åå»ºéé¡¹å¡çæ°æ® æ³æä¹åçèªå·±ï¼è¿åæå°±åç¬¨ç¹äº
    
    NSDictionary *homeDic;
    
    if (UserInfoModel.skinType == simple) {
        
        //ç®æç
        homeDic = @{@"vc":[XMFHomeSimpleController new],@"normalImg":@"icon_home_line",@"selectImg":@"icon_home_fill",@"itemTitle":@"é¦é¡µ"};
        
//        homeDic = @{@"vc":[XMFHomeSimpleController new],@"normalImg":@"icon_wushi",@"selectImg":@"icon_wushi_s",@"itemTitle":@"é¦é¡µ"};
        
    }else{
        
        //æ åç
        homeDic = @{@"vc":[XMFHomeController new],@"normalImg":@"icon_home_line",@"selectImg":@"icon_home_fill",@"itemTitle":@"é¦é¡µ"};
        
//        homeDic = @{@"vc":[XMFHomeController new],@"normalImg":@"icon_wushi",@"selectImg":@"icon_wushi_s",@"itemTitle":@"é¦é¡µ"};
    }
    
    
    
    
    NSArray <NSDictionary *>*VCArray =
    @[
    
        homeDic,
        
        
        @{@"vc":[XMFThemeController new],@"normalImg":@"icon_zhuanti",@"selectImg":@"icon_zhuanti_fill",@"itemTitle":@"ä¸é¢"},
        
        
        @{@"vc":[XMFShoppingCartViewController new],@"normalImg":@"icon_gouwuche_line",@"selectImg":@"icon_gouwuche_fill",@"itemTitle":@"è´­ç©è½¦"},
        
        
        @{@"vc":[XMFMeViewController new],@"normalImg":@"icon_gr",@"selectImg":@"icon_gr_fill",@"itemTitle":@"ä¸ªäººä¸­å¿"}
         
        
        /*
        @{@"vc":[XMFThemeController new],@"normalImg":@"icon_denglong",@"selectImg":@"icon_denglong_s",@"itemTitle":@"ä¸é¢"},
        
        
        @{@"vc":[XMFShoppingCartViewController new],@"normalImg":@"icon_fuzi",@"selectImg":@"icon_fuzi_s",@"itemTitle":@"è´­ç©è½¦"},
        
        
        @{@"vc":[XMFMeViewController new],@"normalImg":@"icon_mifeng",@"selectImg":@"icon_mifeng_s",@"itemTitle":@"ä¸ªäººä¸­å¿"}
        */
        
    
    ];
    // 1.éåè¿ä¸ªéå
    // 1.1 è®¾ç½®ä¸ä¸ªä¿å­æé å¨çæ°ç»
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 è®¾ç½®ä¸ä¸ªä¿å­VCçæ°ç»
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.æ ¹æ®éåæ¥åå»ºTabBaræé å¨
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        // 3.itemåºç¡æ°æ®ä¸è¿
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        // 4.è®¾ç½®åä¸ªéä¸­åä¸éä¸­itemæ é¢ç¶æä¸çé¢è²
        model.normalColor = UIColorFromRGB(0x666666);
        model.selectColor = UIColorFromRGB(0x333333);
//        model.isRepeatClick = YES;
        // å¤§å°
//        model.itemSize = CGSizeMake(KScaleWidth(75), 49);
        model.itemSize = CGSizeMake(KScreenW/4.0, 49);
        model.automaticHidden = YES;
        
        // å¤æ³¨ å¦æä¸æ­¥è®¾ç½®çVCçèæ¯é¢è²ï¼VCå°±ä¼æåç»å¶é©»çï¼ä¼åè¿æ¹é¢çè¯æå¥½ä¸è¦è¿ä¹å
        // ç¤ºä¾ä¸­ä¸ºäºæ¹ä¾¿å°±å¨è¿åäº
        UIViewController *vc = [obj objectForKey:@"vc"];
        
        // ç¨èªå®ä¹çå¯¼èªæ§å¶å¨åè£tabBarControlleræ¯ä¸ä¸ªå­æ§å¶å¨
        XMFBaseNavigationController *navi = [[XMFBaseNavigationController alloc] initWithRootViewController:vc];

        // 5.å°VCæ·»å å°ç³»ç»æ§å¶ç»
        [tabBarVCs addObject:navi];
        // 5.1æ·»å æé Modelå°éå
        [tabBarConfs addObject:model];
    }];
    // 5.2 è®¾ç½®VCs -----
    // ä¸å®è¦åè®¾ç½®è¿ä¸æ­¥ï¼ç¶ååè¿è¡åè¾¹çé¡ºåºï¼å ä¸ºç³»ç»åªæå¨setViewControllerså½æ°åæä¸ä¼åæ¬¡åå»ºUIBarButtonItemï¼ä»¥åé æé®æ¡
    // å¤§æå°±æ¯ä¸å®è¦è®©èªå®ä¹TabBaré®æ¡ä½ç³»ç»çTabBar
    self.viewControllers = tabBarVCs;
    //////////////////////////////////////////////////////////////////////////
    // æ³¨ï¼è¿éæ¹ä¾¿éè¯»å°±å°AE_TabBaræ¾å¨è¿éå®ä¾åäº ä½¿ç¨æå è½½ä¹è¡
    // 6.å°èªå®ä¹çè¦çå°åæ¥çtabBarä¸é¢
    // è¿éæä¸¤ç§å®ä¾åæ¹æ¡ï¼
    // 6.1 ä½¿ç¨éè½½æé å½æ°æ¹å¼ï¼
//    self.axcTabBar = [[AxcAE_TabBar alloc] initWithTabBarConfig:tabBarConfs];
    // 6.2 ä½¿ç¨Setæ¹å¼ï¼
    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.backgroundColor = KWhiteColor;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.è®¾ç½®å§æ
    self.axcTabBar.delegate = self;
    // 8.æ·»å è¦çå°ä¸è¾¹
    [self.tabBar addSubview:self.axcTabBar];
    [self addLayoutTabBar]; // 10.æ·»å éé
}
// 9.å®ç°ä»£çï¼å¦ä¸ï¼
- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    

    if (index == 10) {
        
        self.axcTabBar.currentSelectItem.selected = YES;
        
        // ä¸å¸¦å¾ç
        PopoverAction *action1 = [PopoverAction actionWithTitle:@"å°èèé¤é¥®" handler:^(PopoverAction *action) {
            
            // è¯¥Blockä¸ä¼å¯¼è´åå­æ³é², Blockåä»£ç æ éå»æå»è®¾ç½®å¼±å¼ç¨.
            
            //å°èèäº§å
            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            
            productVC.urlStr = @"https://dc.xmfstore.com/dingzuo-h5/#/home";
            
            XMFBaseNavigationController *productNaviVc = [[XMFBaseNavigationController alloc]initWithRootViewController:productVC];
            
            //æ¨¡æçæ¹å¼éºæ»¡å¨å±
            productNaviVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:productNaviVc animated:YES completion:nil];
            
            
            
        }];
        
        /*
         PopoverAction *action2 = [PopoverAction actionWithTitle:@"éçµBeeBee" handler:^(PopoverAction *action) {
         
         
         [MBProgressHUD showOnlyTextToView:kAppWindow title:@"ç­å¾éç½®ç½å"];
         
         
         }];*/
        
        
        
        PopoverView *popoverView = [PopoverView popoverView];
        popoverView.showShade = YES;
        popoverView.style = PopoverViewStyleDark;
       // ç¹å»å¤é¨æ¶åè®¸éè
        popoverView.hideAfterTouchOutside = YES;
        
        CGPoint thirdTabbarItemPoint = CGPointMake(self.view.frame.size.width * 5 / 8.0, self.tabBar.frame.origin.y);
        
        
        [popoverView showToPoint:thirdTabbarItemPoint withActions:@[action1]];
        
        
    
        
    }else{
        
        // éç¥ åæ¢è§å¾æ§å¶å¨
         [self setSelectedIndex:index];
    }
    
 
    // èªå®ä¹çAE_TabBaråè°ç¹å»äºä»¶ç»TabBarVCï¼TabBarVCç¨ç¶ç±»çTabBarControllerå½æ°å®æåæ¢
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
        
    }
}

// 10.æ·»å éé
- (void)addLayoutTabBar{
    // ä½¿ç¨éè½½viewDidLayoutSubviewså®æ¶è®¡ç®åæ  ï¼ä¸è¾¹ç -viewDidLayoutSubviews å½æ°ï¼
    // è½å¼å®¹è½¬å±æ¶çèªå¨å¸å±
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
