//
//  XMFGlobalManager.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGlobalManager.h"
#import "XMFBaseNavigationController.h"
//#import "XMFLoginViewController.h"
#import "XMFLoginController.h"
#import "XMFBindPhoneController.h"//绑定手机



//在.m文件中添加
@interface  XMFGlobalManager()

@property (nonatomic, strong) XMFBaseNavigationController *nav;


/** 订单状态数组 */
@property (nonatomic, strong) NSArray *orderStatusArr;


/** 订单按钮操作对应的数组 */
@property (nonatomic, strong) NSArray *handleOptionNameArr;

@end

@implementation XMFGlobalManager


+(instancetype)getGlobalManager{
    
    static dispatch_once_t onceToken;
    
    static XMFGlobalManager *instance = nil;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[XMFGlobalManager alloc]init];
        
    });
    
    return instance;
    
}


//present跳转方法一
-(void)presentLoginControllerWith:(UIViewController *)controller{
    
    controller.navigationController.navigationBar.barTintColor = KWhiteColor;
    
//       XMFLoginViewController *loginVC = [[XMFLoginViewController alloc] init];
    
    
    NSString *MD5KeyStr;
    
    #if defined(XMFDEBUG)
        
        //测试环境
        MD5KeyStr = @"N5vtLiwyEetpvitXXapwhIa6hYsu4WQ4";
        
        
    #elif defined(XMFRELEASE)
        
        //正式环境
        MD5KeyStr = @"GTYDS60PMKSLUOYJZPGDTTRROJA4PNII";
        
    #endif
    
    
    
    NSDictionary *dic = @{
        
        @"platformCode":@"XMFDS",
        @"accountType":@"CRPM",
        
        @"MD5Key":MD5KeyStr

        //测试环境MD5的Key
//                        @"MD5Key":@"N5vtLiwyEetpvitXXapwhIa6hYsu4WQ4"
        //生产环境MD5的Key
//                @"MD5Key":@"GTYDS60PMKSLUOYJZPGDTTRROJA4PNII"
        
        
        
    };
    
    
    XMFLoginController  *loginVC = [[XMFLoginController alloc]initWithDic:dic];
      
    
    XMFBaseNavigationController *nav = [[XMFBaseNavigationController alloc] initWithRootViewController:loginVC];
    
       _nav = nav;
       
       //模态的方式铺满全屏
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
   
    [controller presentViewController:nav animated:YES completion:nil];
    
    
}


-(void)presentLoginControllerWithBlock:(UIViewController *)controller block:(loginVcBackBlock)backBlock{
    
    controller.navigationController.navigationBar.barTintColor = KWhiteColor;
    
//       XMFLoginViewController *loginVC = [[XMFLoginViewController alloc] init];
    
    
    NSString *MD5KeyStr;
    
    #if defined(XMFDEBUG)
        
        //测试环境
        MD5KeyStr = @"N5vtLiwyEetpvitXXapwhIa6hYsu4WQ4";
        
        
    #elif defined(XMFRELEASE)
        
        //正式环境
        MD5KeyStr = @"GTYDS60PMKSLUOYJZPGDTTRROJA4PNII";
        
    #endif
    
    
    
    NSDictionary *dic = @{
        
        @"platformCode":@"XMFDS",
        @"accountType":@"CRPM",
        
        @"MD5Key":MD5KeyStr

        //测试环境MD5的Key
//                        @"MD5Key":@"N5vtLiwyEetpvitXXapwhIa6hYsu4WQ4"
        //生产环境MD5的Key
//                @"MD5Key":@"GTYDS60PMKSLUOYJZPGDTTRROJA4PNII"
        
        
        
    };
    
    
    XMFLoginController  *loginVC = [[XMFLoginController alloc]initWithDic:dic];
    
    loginVC.backBlock = ^{
        
        backBlock();
        
    };
      
    
    XMFBaseNavigationController *nav = [[XMFBaseNavigationController alloc] initWithRootViewController:loginVC];
    
       _nav = nav;
       
       //模态的方式铺满全屏
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
   
    [controller presentViewController:nav animated:YES completion:nil];
    
    
}


//present跳转方法二
- (void)presentBindPhoneControllerWith:(UIViewController *)controller{
    
       controller.navigationController.navigationBar.barTintColor = KWhiteColor;
        
       XMFBindPhoneController  *VCtrl = [[XMFBindPhoneController alloc]init];
    
        XMFBaseNavigationController *nav = [[XMFBaseNavigationController alloc] initWithRootViewController:VCtrl];
        
        _nav = nav;
           
           //模态的方式铺满全屏
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
       
        [controller presentViewController:nav animated:YES completion:nil];
 
    
}



//获取当前设备的语言
-(NSString *)getCurrentLanguage{
    
    // iOS 获取设备当前语言和地区的代码
    NSString *currentLanguageRegion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
    
    NSString *currentLanguageStr;
    
    if ([currentLanguageRegion containsString:@"zh-Hans"]) {
        //zh-Hans-CN: 简体（改变）
        //zh-Hant-CN: 繁体（改变）
        currentLanguageStr = @"zh_CN";
        
    }else if ([currentLanguageRegion containsString:@"zh-Hant"]){
        
        currentLanguageStr = @"zh_HK";
        
    }else{
        
        currentLanguageStr = @"en_US";
    }
    
    
    //目前只有简体中文，所以全部传简体中文不随着系统改变
     return  @"zh_CN";
    
//    return currentLanguageStr;
    
}


//获取购物车控制器的index
-(NSInteger)getShoppingCartIndex{
    
    
    //获取购物车控制器
    XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
    
    //防止tabbar位置变动，遍历子控制器并选中
    for (int i = 0; i < tabBarVc.viewControllers.count; ++i) {
        
        //导航控制器
        XMFBaseNavigationController *navVc = tabBarVc.viewControllers[i];
        
        //导航控制器的根控制器
        UIViewController *firstVc = [navVc.viewControllers firstObject];
        
        if ([firstVc  isKindOfClass:[XMFShoppingCartViewController class]]) {
            
            
            return i;
            
            
        }
        
        
        
    }
    
    return 1;

}

#pragma mark - ——————— 设置富文本 ————————
-(NSMutableAttributedString *)changToAttributedStringUpperStr:(NSString *)upperStr upperColor:(UIColor *)upperColor upperFont:(UIFont *)upperFont lowerStr:(NSString *)lowerStr lowerColor:(UIColor *)lowerColor lowerFont:(UIFont *)lowerFont{
    
  
    //上半部分
    NSMutableAttributedString *upperAttriStr = [[NSMutableAttributedString alloc]initWithString:upperStr];
    
    [upperAttriStr addAttribute:NSFontAttributeName value:upperFont range:NSMakeRange(0, upperStr.length)];
    [upperAttriStr addAttribute:NSForegroundColorAttributeName value:upperColor range:NSMakeRange(0, upperStr.length)];
    
    
    
    //下半部分
    NSMutableAttributedString *lowerAttriStr = [[NSMutableAttributedString alloc]initWithString:lowerStr];
    
    [lowerAttriStr addAttribute:NSFontAttributeName value:lowerFont range:NSMakeRange(0, lowerStr.length)];
    
    [lowerAttriStr addAttribute:NSForegroundColorAttributeName value:lowerColor range:NSMakeRange(0, lowerStr.length)];
    
    
    //合并一起
    [upperAttriStr appendAttributedString:lowerAttriStr];
    

    
    return upperAttriStr;
    
}


//获取商品单位
-(NSString *)getGoodsUnit:(NSString *)unitStr{
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"unit" ofType:@"json"];
    
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    // 对数据进行JSON格式化并返回字典形式
//    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //遍历json数据
    for (NSDictionary *dic in result) {
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",dic[@"code"]];
        
        if ([codeStr isEqualToString:unitStr]) {
          
          NSString *nameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            
            return nameStr;
        }
        
    }
    
    
    return @"件";

    
}

//获取国家编码
-(NSString *)getCountryCodeStr{
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    return countryCode;
    
}

//文字上加横线
-(NSMutableAttributedString *)textAddLine:(NSString *)string{
    
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:string];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    
    return newPrice;
}

/** 保存历史搜索数据 */
- (void)saveSearchHistoryArrayToLocal:(NSArray *)historyStringArray {
    
    [[NSUserDefaults standardUserDefaults] setObject:historyStringArray forKey:HistoryStringArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


/** 获取历史搜索数据 */
- (NSMutableArray *)getSearchHistoryArrayFromLocal{
    NSMutableArray *historyStringArray = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryStringArray];
    historyStringArray = [NSMutableArray arrayWithArray:historyStringArray];
    return historyStringArray;
}

/** 删除NSUserDefaults某项 */
-(void)removeUserDefaultsObjectForKey:(NSString *)key{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];//快速保存
    
    
}


/** 通过key获取订单状态文字 */
-(OrderStatusInfo)getOrderStatusForKey:(NSString *)key{
    
    
    OrderStatusInfo statusInfo;
    
    NSString *statusNameStr = [NSString string];
    
    int index = 0;
    
    for (int i = 0; i < self.orderStatusArr.count; ++i) {
        
        NSDictionary *dic = self.orderStatusArr[i];
        
        if ([[dic allKeys] containsObject:key]) {
            
            
            statusNameStr = [dic objectForKey:key];
            
            index = i;
            
            
        }
        
    }
    
    
    statusInfo.statusName = statusNameStr;
    
    statusInfo.index = index;

    
    return statusInfo;
    
}

/** 通过key获取订单按钮操作文字 */
-(HandleOptionInfo)getHandleOptionForKey:(NSString *)key{
    
//    NSString *handleStr = [self.handleOptionNameDic objectForKey:key];
    
    HandleOptionInfo handleInfo;
    
    NSString *handleStr = [NSString string];
    
    int index = 0;
    
    for (int i = 0; i < self.handleOptionNameArr.count; ++i) {
        
        NSDictionary *dic = self.handleOptionNameArr[i];
        
        if ([[dic allKeys] containsObject:key]) {
            
            
            handleStr = [dic objectForKey:key];
            
            index = i;
            
        
        }
        
    }
    
    
    handleInfo.handleOptionName = handleStr;
    
    handleInfo.index = index;

     
    return handleInfo;
    

}

#pragma mark - ——————— 懒加载 ————————

-(NSArray *)orderStatusArr{
    
    if (_orderStatusArr == nil) {
        _orderStatusArr = @[
        
            @{@"101":XMFLI(@"待付款")},
            @{@"102":XMFLI(@"用户取消")},
            @{@"103":XMFLI(@"系统取消")},
            @{@"104":XMFLI(@"订单处理中")},
            @{@"109":XMFLI(@"待付款")},
            @{@"201":XMFLI(@"待发货")},
            @{@"202":XMFLI(@"申请退款")},
            @{@"203":XMFLI(@"已退款")},
            @{@"204":XMFLI(@"退款失败")},
            @{@"209":XMFLI(@"退款中")},
            @{@"301":XMFLI(@"待收货")},
            @{@"401":XMFLI(@"已完成")},
            @{@"402":XMFLI(@"已完成")},
            @{@"409":XMFLI(@"已完成")},

        
        ];
    }
    return _orderStatusArr;
}

-(NSArray *)handleOptionNameArr{
    
    if (_handleOptionNameArr == nil) {
        _handleOptionNameArr = @[
        
            @{@"confirm":@"确认收货"},
            @{@"queryTrack":@"查看物流"},
            @{@"cancel":@"取消订单"},
            @{@"remind":@"提醒发货"},
            @{@"comment":@"立即评价"},
            @{@"delete":@"删除"},
            @{@"pay":@"付款"},
            @{@"updateAddress":@"修改地址"},
            @{@"extendConfirm":@"延长收货"},
            @{@"rebuy":@"再次购买"},
            @{@"appendComment":@"追加评价"},
            @{@"refund":@"申请退款"},
            @{@"cancelRefund":@"取消退款"},
            @{@"addCart":@"加入购物车"},
            @{@"contact":@"联系客服"},

            
            
        ];
    }
    return _handleOptionNameArr;
}



// html 颜色值转换 UIColor，比如：#FF9900、0XFF9900 等颜色字符串，以下方法可以将这些字符串转换为 UIColor 对象。
- (UIColor *) colorWithHexString: (NSString *)color{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
