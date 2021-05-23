//
//  XMFGlobalManager.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GlobalManager [XMFGlobalManager getGlobalManager]

#define HistoryStringArray @"historyStringArray"


//登录页面的block
typedef void(^loginVcBackBlock)(void);

//订单状态结构体
struct OrderStatusInfo {
    NSString *statusName;
    int index;
};

typedef struct OrderStatusInfo OrderStatusInfo;



//订单操作名称结构体
struct HandleOptionInfo {
    NSString *handleOptionName;
    int index;
};

typedef struct HandleOptionInfo HandleOptionInfo;



@interface XMFGlobalManager : NSObject

//单例
+ (instancetype)getGlobalManager;

//present跳转方法一
- (void)presentLoginControllerWith:(UIViewController *)controller;


- (void)presentLoginControllerWithBlock:(UIViewController *)controller block:(loginVcBackBlock)backBlock;


//present跳转方法二
- (void)presentBindPhoneControllerWith:(UIViewController *)controller;


//获取当前设备的语言
-(NSString *)getCurrentLanguage;

//设置价格的金额富文本
-(NSMutableAttributedString *)changToAttributedStringUpperStr:(NSString *)upperStr upperColor:(UIColor *)upperColor upperFont:(UIFont *)upperFont lowerStr:(NSString *)lowerStr lowerColor:(UIColor *)lowerColor lowerFont:(UIFont *)lowerFont;

//获取商品单位
-(NSString *)getGoodsUnit:(NSString *)unitStr;

//获取国家编码
-(NSString *)getCountryCodeStr;

//获取购物车控制器的index
-(NSInteger)getShoppingCartIndex;

//文字上加横线
-(NSMutableAttributedString *)textAddLine:(NSString *)string;


/** 保存历史搜索数据 */
- (void)saveSearchHistoryArrayToLocal:(NSMutableArray *)historyStringArray;

/** 获取历史搜索数据 */
- (NSMutableArray *)getSearchHistoryArrayFromLocal;

/** 删除NSUserDefaults某项 */
-(void)removeUserDefaultsObjectForKey:(NSString *)key;


/** 通过key获取订单状态文字 */
-(OrderStatusInfo)getOrderStatusForKey:(NSString *)key;


/** 通过key获取订单按钮操作文字 */
-(HandleOptionInfo)getHandleOptionForKey:(NSString *)key;


// html 颜色值转换 UIColor，比如：#FF9900、0XFF9900 等颜色字符串，以下方法可以将这些字符串转换为 UIColor 对象。
- (UIColor *) colorWithHexString: (NSString *)color;

@end

NS_ASSUME_NONNULL_END
