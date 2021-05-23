//
//  APPDefine.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#ifndef APPDefine_h
#define APPDefine_h

#pragma mark - ——————— 常用 ————————

#define XMFDISSMISSDELAYTIME 1.5 // 提示时间

#define LimitInputKey @"LimitInput" //输入框等位数限制key

#define Associate_domainLinks @"https://www.bmall.com.hk/.well-known/apple-app-site-association"

//支付宝唤起国内还是香港 国内传递ALIAPYCN 香港传递ALIPAYHK
#define AlipayArea @"ALIAPYCN"


#pragma mark - ——————— 通知名称 ————————


/**
 通知方：XMFHomeSonViewController
 接收方：XMFShoppingCartController
 通知内容：刷新购物车
 */

#define KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh  @"HomeSonVc_Notice_ShoppingcartVc_Refresh"


/**
 通知方：订单中心
 接收方：订单中心
 通知内容：是否刷新页面
 */
#define KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh  @"AllOrdersVc_Notice_AllOrdersVc_IsRefresh"



/**
 通知方：登录状态发生改变
 接收方：需要的地方
 通知内容：登录状态发生改变
 */
#define KPost_LoginStatusChange_Notice_NeedLoginStatus_LoginStatusHasChanged  @"LoginStatusChange_Notice_NeedLoginStatus_LoginStatusHasChanged"

/**
 通知方：HomeSonVc
 接收方：HomeSonVc
 通知内容：刷新页面
 */
#define KPost_HomeSonVc_Notice_HomeSonVc_Refresh  @"HomeSonVc_Notice_HomeSonVc_Refresh"

/**
 通知方：购物车
 接收方：首页的子商品列表
 通知内容：刷新页面
 */
#define KPost_CartVc_Notice_HomeSonVc_Refesh  @"CartVc_Notice_HomeSonVc_Refesh"


/**
 通知方：HomeSonVc
 接收方：HomeVc
 通知内容：子控件显示与否
 */
#define KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow  @"HomeSonVc_Notice_HomeVc_SubviewsIsShow"


/**
 通知方：支付结果页
 接收方：我的订单页
 通知内容：选择不同的页面
 */
#define KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex  @"PayResultVc_Notice_MyOrdersVc_SelectIndex"


/****商品详情进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****商品详情离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"



/** ———————————— 以下为2.0版本定义名称 ——————————*/



/**
 通知方：XMFHomeController
 接收方：XMFShoppingCartViewController
 通知内容：刷新购物车
 */

#define KPost_HomeVc_Notice_ShoppingcartVc_Refresh  @"HomeVc_Notice_ShoppingcartVc_Refresh"


/**
 通知方：购物车
 接收方：首页
 通知内容：刷新页面
 */
#define KPost_CartVc_Notice_HomeVc_Refesh  @"CartVc_Notice_HomeVc_Refesh"


/**
 通知方：任意
 接收方：个人中心
 通知内容：刷新页面
 */
#define KPost_Anyone_Notice_MeVc_Refesh  @"Anyone_Notice_MeVc_Refesh"


/**
 通知方：我的订单
 接收方：我的订单
 通知内容：是否刷新页面
 */
#define KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh  @"MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh"


/**
 通知方：我的地址列表
 接收方：订单确认
 通知内容：是否清除地址
 */
#define KPost_MyDeliveryAddressVc_Notice_ConfirmOrderVc_IsRefresh  @"MyDeliveryAddressVc_Notice_ConfirmOrderVc_IsRefresh"


/**
 通知方：首页
 接收方：首页的子页面
 通知内容：刷新页面
 */
#define KPost_HomeSimpleVc_Notice_HomeSonVc_Refresh  @"HomeSimpleVc_Notice_HomeSonVc_Refresh"


#endif /* APPDefine_h */
