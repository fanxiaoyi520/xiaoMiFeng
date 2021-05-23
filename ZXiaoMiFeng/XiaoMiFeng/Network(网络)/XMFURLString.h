//
//  XMFURLString.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#ifndef XMFURLString_h
#define XMFURLString_h

#define LOCAL_TEST           //本地测试环境-内网
//#define PRODUCTION        //线上生产环境-AppStore版本


/**本地测试环境**/
#if defined(LOCAL_TEST)


//测试环境V2.0

#define XMF_BASE_URL @"http://testhk.qtopay.cn/beemall-services"




//支付SDK测试环境 00正式  01测试
#define ZDPaySDK_URL @"01"


/**线上生产环境**/
#elif defined(PRODUCTION)



//V2版本IP生产地址
#define XMF_BASE_URL @"http://120.236.37.75:8086/beemall-services"


//http://gateway-cmcc.xmfstore.com:8086

//支付SDK测试环境 00正式  01测试
#define ZDPaySDK_URL @"00"

#endif



/*-------------------宏定义分割线----------------*/

#pragma mark - ——————— 以下为2.0版本接口 ————————

#pragma mark - ——————— 商品接口 ————————


/**
 接口名称： 获取广告列表
 请求方式： GET方式
 接口说明： 获取广告列表
 */
#define URL_goods_ad_list @"/goods/ad/list"


/**
 接口名称： 获取商品详情
 请求方式： GET方式
 接口说明： 获取商品详情
 */
#define URL_goods_detail @"/goods/detail"


/**
 接口名称： 首页推荐
 请求方式： POST方式
 接口说明： 首页推荐
 */
#define URL_goods_firstPageRecommend @"/goods/first-page-recommend"


/**
 接口名称： 获取商品货品与规格信息
 请求方式： GET方式
 接口说明： 获取商品货品与规格信息
 */
#define URL_goods_goodsProductSpec @"/goods/goods-product-spec"



/**
 接口名称： 商品搜索
 请求方式： POST方式
 接口说明： 商品搜索
 */
#define URL_goods_search @"/goods/search"



/**
 接口名称： 热门搜索关键字
 请求方式： GET方式
 接口说明： 热门搜索关键字
 */
#define URL_goods_goods_hotSearch @"/goods/goods/hot-search"


/**
 接口名称： 获取评论商品信息
 请求方式： GET方式
 接口说明： 获取评论商品信息
 */
#define URL_goods_goods_commentGoods @"/goods/goods/comment-goods"



/**
 接口名称： 商品评论列表
 请求方式： GET方式
 接口说明： 商品评论列表
 */
#define URL_goods_goods_comment_page @"/goods/goods/comment/page"



/**
 接口名称： 获取购买说明信息
 请求方式： GET方式
 接口说明： 获取购买说明信息
 */
#define URL_goods_detail_purchaseInstructions @"/goods/detail/purchase-instructions"


/**
 接口名称： 获取规格相关信息
 请求方式： GET方式
 接口说明： 获取规格相关信息
 */
#define URL_goods_detail_specInfo @"/goods/detail/spec-info"



/**
 接口名称：统计订单是否存在未上传身份证的订单
 请求方式： GET方式
 接口说明：统计订单是否存在未上传身份证的订单
 */
#define URL_wx_order_checkOrder @"/wx/order/checkOrder"


/**
 接口名称： 热门搜索关键字
 请求方式： GET方式
 接口说明： 热门搜索关键字
 */
#define URL_goods_goods_search_suggest @"/goods/goods/search/suggest"


/**
 接口名称： 商品下单前拆单 
 请求方式： GET方式
 接口说明： 商品下单前拆单
 */
#define URL_goods_splitOrders @"/goods/split-orders"


#pragma mark - ——————— 收藏 ————————

/**
 接口名称： 收藏/取消收藏
 请求方式： POST方式
 接口说明： 收藏/取消收藏
 */
#define URL_wx_collect_addOrDelete @"/wx/collect/add-or-delete"

/**
 接口名称： 我的收藏列表
 请求方式： GET方式
 接口说明： 我的收藏列表
 */
#define URL_wx_collect_list @"/wx/collect/list"


/**
 接口名称：删除指定收藏
 请求方式： POST方式
 接口说明：删除指定收藏
 */
#define URL_wx_collect_batchDelete @"/wx/collect/batch-delete"



/**
 接口名称： 清空失效收藏
 请求方式： GET方式
 接口说明： 清空失效收藏
 */
#define URL_wx_collect_clean @"/wx/collect/clean"




#pragma mark - ——————— 购物车接口 ————————
/**
 接口名称： 添加购物车
 请求方式： POST方式
 接口说明： 添加购物车
 */
#define URL_cart_add @"/cart/add"


/**
 接口名称： 选中购物车操作
 请求方式： POST方式
 接口说明： 选中购物车操作
 */
#define URL_cart_check @"/cart/check"


/**
 接口名称： 根据购物车id列表删除购物车商品
 请求方式： POST方式
 接口说明： 根据购物车id列表删除购物车商品
 */
#define URL_cart_clean @"/cart/clean"


/**
 接口名称： 购买添加购物车
 请求方式： POST方式
 接口说明： 购买添加购物车
 */
#define URL_cart_fastAdd @"/cart/fast-add"


/**
 接口名称： 获取当前登录用户购物车信息
 请求方式： GET方式
 接口说明： 获取当前登录用户购物车信息
 */
#define URL_cart_info @"/cart/info"


/**
 接口名称： 获取用户购物车货品数量
 请求方式： GET方式
 接口说明： 获取用户购物车货品数量
 */
#define URL_cart_num @"/cart/num"


/**
 接口名称： 提交购物车校验库存
 请求方式： GET方式
 接口说明： 提交购物车校验库存
 */
#define URL_cart_checkStock @"/cart/check-stock"



/**
 接口名称： 删除购物车加入收藏
 请求方式： POST方式
 接口说明： 删除购物车加入收藏
 */
#define URL_cart_deleteCartAndAddCollect @"/cart/delete-cart-and-add-collect"


/**
 接口名称： 拆分订单
 请求方式： POST方式
 接口说明： 拆分订单
 */
#define URL_cart_splitOrders @"/cart/split-orders"


#pragma mark - ——————— 专题相关接口 ————————


/**
 接口名称： 获取专题列表
 请求方式： GET方式
 接口说明： 获取专题列表
 */
#define URL_topic_list @"/topic/list"


/**
 接口名称： 获取专题信息
 请求方式： GET方式
 接口说明： 获取专题信息
 */
#define URL_topic_info @"/topic/info"


#pragma mark - ——————— 用户登录和授权的接口 ————————

/**
 接口名称： 获取用户基本信息接口
 请求方式： GET方式
 接口说明： 获取用户基本信息接口
 */
#define URL_wx_auth_user_info @"/wx/auth/user/info"


/**
 接口名称： 用户退出登录接口 
 请求方式： GET方式
 接口说明： 用户退出登录接口
 */
#define URL_wx_auth_dropout @"/wx/auth/dropout"


/**
 接口名称： 用户信息修改
 请求方式： POST方式
 接口说明： 用户信息修改
 */
#define URL_wx_auth_user_update @"/wx/auth/user/update"



/**
 
 注意：特别提醒该接口是会员系统接口和项目中的地址是不一样的
 
 接口名称： 通行证密码修改接口
 请求方式： POST方式
 接口说明： 通行证密码修改接口
 */
#define URL_option_password_modify @"/option/password/modify"


/**
 接口名称： 帐号绑定发送短信接口
 请求方式： POST方式
 接口说明： 帐号绑定发送短信接口
 */
#define URL_wx_auth_bind_captcha @"/wx/auth/bind/captcha"


/**
 接口名称： 帐号绑定手机号码接口
 请求方式： POST方式
 接口说明： 帐号绑定手机号码接口
 */
#define URL_wx_auth_bind_phone @"/wx/auth/bind/phone"


/**
 接口名称： 已认证身份列表
 请求方式： GET方式
 接口说明： 已认证身份列表
 */
#define URL_wx_auth_ocr_autherized_list @"/wx/auth/ocr/autherized/list"



/**
 接口名称： 身份证OCR认证（反面）
 请求方式： POST方式
 接口说明： 身份证OCR认证（反面）
 */
#define URL_wx_auth_idcard_back @"/wx/auth/ocr/id-card/back"


/**
 接口名称： 身份证OCR认证（正面）
 请求方式： POST方式
 接口说明： 身份证OCR认证（正面）
 */
#define URL_wx_auth_idcard_front @"/wx/auth/ocr/id-card/front"


/**
 接口名称：身份证OCR认证保存
 请求方式： POST方式
 接口说明：身份证OCR认证保存
 */
#define URL_wx_auth_ocr_idcard_save @"/wx/auth/ocr/id-card/save"


#pragma mark - ——————— 商品分类接口 ————————

/**
 接口名称： 商品分类列表
 请求方式： GET方式
 接口说明： 商品分类列表
 */
#define URL_classify_enable_list @"/classify/enable/list"



#pragma mark - ——————— 客户端订单接口管理 ————————

/**
 接口名称： 用户取消订单
 请求方式： GET方式
 接口说明： 用户取消订单
 */
#define URL_wx_order_cancel @"/wx/order/cancel"


/**
 接口名称： 用户取消退款
 请求方式： GET方式
 接口说明： 用户取消退款
 */
#define URL_wx_order_cancelRefund @"/wx/order/cancelRefund"


/**
 接口名称： APP订单提交
 请求方式： POST方式
 接口说明： APP订单提交
 */
#define URL_wx_order_commitApp @"/wx/order/commitApp"


/**
 接口名称： 订单确认收货
 请求方式： POST方式
 接口说明： 订单确认收货
 */
#define URL_wx_order_confirm @"/wx/order/confirm"


/**
 接口名称： 用户删除订单
 请求方式： GET方式
 接口说明： 用户删除订单
 */
#define URL_wx_order_deleteOrder @"/wx/order/deleteOrder"


/**
 接口名称： 查询订单详情
 请求方式： GET方式
 接口说明： 查询订单详情
 */
#define URL_wx_order_detail @"/wx/order/detail"


/**
 接口名称： 用户延长收货时间
 请求方式： GET方式
 接口说明： 用户延长收货时间
 */
#define URL_wx_order_extendConfirm @"/wx/order/extendConfirm"


/**
 接口名称： 我的订单列表
 请求方式： GET方式
 接口说明： 我的订单列表
 */
#define URL_wx_order_list @"/wx/order/list"


/**
 接口名称： 用户订单统计
 请求方式： GET方式
 接口说明： 用户订单统计
 */
#define URL_wx_order_orderCount @"/wx/order/orderCount"


/**
 接口名称： 订单确认去付款
 请求方式： POST方式
 接口说明： 订单确认去付款
 */
#define URL_wx_order_orderSubmitApp @"/wx/order/orderSubmitApp"



/**
 接口名称： 物流追踪
 请求方式： POST方式
 接口说明： 物流追踪
 */
#define URL_wx_order_queryTrack @"/wx/order/queryTrack"


/**
 接口名称： 用户发起退款申请
 请求方式： POST方式
 接口说明： 用户发起退款申请
 */
#define URL_wx_order_refund @"/wx/order/refund"



/**
 接口名称： 用户提醒发货
 请求方式： GET方式
 接口说明： 用户提醒发货
 */
#define URL_wx_order_remain @"/wx/order/remain"


/**
 接口名称： 修改收货地址
 请求方式： POST方式
 接口说明： 修改收货地址
 */
#define URL_wx_order_updateOrderAddress @"/wx/order/updateOrderAddress"



/**
 接口名称： 立即下单
 请求方式： POST方式
 接口说明： 立即下单
 */
#define URL_wx_order_fastAddOrder @"/wx/order/fastAddOrder"

/**
 接口名称： 主动查询支付结果
 请求方式： GET方式
 接口说明： 主动查询支付结果
 */
#define URL_wx_order_queryOrderStatus @"/wx/order/queryOrderStatus"


/**
 接口名称： 订单地址列表
 请求方式： GET方式
 接口说明： 订单地址列表
 */
#define URL_wx_order_addresses @"/wx/order/addresses"


#pragma mark - ——————— 我的收货地址相关接口 ————————

/**
 接口名称： 删除收货地址
 请求方式： GET方式
 接口说明： 删除收货地址
 */
#define URL_wx_address_delete @"/wx/address/delete"


/**
 接口名称： 获取我的收货地址明细
 请求方式： GET方式
 接口说明： 获取我的收货地址明细
 */
#define URL_wx_address_detail @"/wx/address/detail"



/**
 接口名称： 获取我的收货地址列表
 请求方式： GET方式
 接口说明： 获取我的收货地址列表
 */
#define URL_wx_address_list @"/wx/address/list"


/**
 接口名称： 新增/编辑我的收货地址
 请求方式： POST方式
 接口说明： 新增/编辑我的收货地址
 */
#define URL_wx_address_save @"/wx/address/save"




#pragma mark - ——————— 行政区划相关接口 ————————
/**
 接口名称： 获取列表结构的所有区划
 请求方式： GET方式
 接口说明： 获取列表结构的所有区划
 */
#define URL_wx_region_list @"/wx/region/list"




#pragma mark - ——————— 支付模块相关接口 ————————
/**
 接口名称： App提交支付(国外)
 请求方式： POST方式
 接口说明： App提交支付(国外)
 */
#define URL_wx_order_prepayapp @"/wx/order/prepay-app"





#pragma mark - ——————— 图片上传 ————————
/**
 接口名称： 图片上传管理
 请求方式： POST方式
 接口说明： 图片上传管理
 */
#define URL_uploadPic @"/uploadPic"



#pragma mark - ——————— 客户端订单评价管理 ————————
/**
 接口名称： 订单商品评价
 请求方式： POST方式
 接口说明： 订单商品评价
 */
#define URL_wx_comment_addComment @"/wx/comment/addComment"

/**
 接口名称： 订单商品追加评价
 请求方式： POST方式
 接口说明： 订单商品追加评价
 */
#define URL_wx_comment_appendComment @"/wx/comment/appendComment"



#pragma mark - ——————— 应用管理 ————————

/**
 接口名称： 应用更新管理
 请求方式： POST方式
 接口说明： 应用更新管理

 */
#define URL_upgrade @"/upgrade"


#pragma mark - ——————— 启动页相关接口 ————————
/**
 接口名称： 获取生效启动页
 请求方式： GET方式
 接口说明： 获取生效启动页
 */
#define URL_startPage_getStartPage @"/startPage/getStartPage"



#pragma mark - ——————— 以下为1.0版本接口 ————————

/*-------------------以下为1.0版本接口----------------*/

#pragma mark - ——————— 登录注册 ————————

/**
 接口名称： 获取图片验证码
 请求方式： GET方式
 接口说明： 获取图片验证码
 */
#define URL_wx_auth_getCode @"/wx/auth/getCode"

/**
 接口名称： 用户登录
 请求方式： POST方式
 接口说明： 用户登录
 */
#define URL_wx_auth_login @"/wx/auth/login"


/**
 接口名称： 获取国际手机号区号
 请求方式： POST方式
 接口说明： 获取国际手机号区号
 */
#define URL_wx_auth_phoneAreaCode @"/wx/auth/phoneAreaCode"

/**
 接口名称： 获取验证码
 请求方式： POST方式
 接口说明： 获取验证码
 */
#define URL_wx_auth_regCaptcha @"/wx/auth/regCaptcha"


/**
 接口名称： 手机验证码校验
 请求方式： POST方式
 接口说明： 手机验证码校验
 */
#define URL_wx_auth_authPhoneCode @"/wx/auth/authPhoneCode"


/**
 接口名称： 注册用户
 请求方式： POST方式
 接口说明： 注册用户
 */
#define URL_wx_auth_register @"/wx/auth/register"


/**
 接口名称： 忘记密码获取验证码
 请求方式： POST方式
 接口说明： 忘记密码获取验证码
 */
#define URL_wx_auth_fpCaptcha @"/wx/auth/fpCaptcha"


/**
 接口名称： 验证码验证（验证后验证码不删除）
 请求方式： POST方式
 接口说明： 验证码验证（验证后验证码不删除）
 */
#define URL_wx_auth_checkCode @"/wx/auth/checkCode"



/**
 接口名称： 忘记密码时重置密码
 请求方式： POST方式
 接口说明： 忘记密码时重置密码
 */
#define URL_wx_auth_forgetPassword @"/wx/auth/forgetPassword"

/**
 接口名称： 修改密码
 请求方式： POST方式
 接口说明： 修改密码
 */
#define URL_wx_auth_modifyPassword @"/wx/auth/modifyPassword"


/**
 接口名称： 绑定手机号
 请求方式： POST方式
 接口说明： headers{X-Litemall-Token=token}  body{phone=手机号, areaCode=区号, code=验证码}
 */
#define URL_wx_auth_wxBindPhone @"/wx/auth/wxBindPhone"



#pragma mark - ——————— 首页 ————————

/**
 接口名称： 所有分类列表
 请求方式： GET方式
 接口说明： 所有分类列表
 */
#define URL_wx_classify_all @"/wx/classify/all"


/**
 接口名称： 首页
 请求方式： GET方式
 接口说明： 首页
 */
#define URL_wx_home_index @"/wx/home/index"


/**
 接口名称： 商品列表
 请求方式： GET方式
 接口说明： 商品列表
 */
#define URL_wx_goods_list @"/wx/goods/list"


/**
 接口名称： 加入购物车
 请求方式： POST方式
 接口说明： 加入购物车
 */
#define URL_wx_cart_add @"/wx/cart/add"

/**
 接口名称： 修改购物车商品
 请求方式： POST方式
 接口说明： 修改购物车商品
 */
#define URL_wx_cart_update @"/wx/cart/update"

/**
 接口名称： 商品详情
 请求方式： GET方式
 接口说明： 商品详情
 */
#define URL_wx_goods_detail @"/wx/goods/detail"

/**
 接口名称： 收藏或者取消收藏商品
 请求方式： POST方式
 接口说明： 收藏或者取消收藏商品
 */
#define URL_wx_collect_addordelete @"/wx/collect/addordelete"

/**
 接口名称： 商品评论
 请求方式： GET方式
 接口说明： 商品评论
 */
#define URL_wx_goods_commentList @"/wx/goods/commentList"


/**
 接口名称： 我的足迹列表
 请求方式： GET方式
 接口说明： 我的足迹列表
 */
#define URL_wx_footprint_list @"/wx/footprint/list"


/**
 接口名称： App订单下单接口
 请求方式： POST方式
 接口说明： App订单下单接口
 */
#define URL_wx_order_submitApp @"/wx/order/submitApp"


/**
 接口名称： 立即购买
 请求方式： POST方式
 接口说明： 立即购买
 */
#define URL_wx_cart_fastadd @"/wx/cart/fastadd"


#pragma mark - ——————— 购物车 ————————
/**
 接口名称： 购物车商品总数
 请求方式： GET方式
 接口说明： 购物车商品总数
 */
#define URL_wx_cart_goodscount @"/wx/cart/goodscount"


/**
 接口名称： 购物车查询
 请求方式： GET方式
 接口说明： 购物车查询
 */
#define URL_wx_cart_index @"/wx/cart/index"



/**
 接口名称： 选中/取消选中购物清单
 请求方式： POST方式
 接口说明： 选中/取消选中购物清单
 */
#define URL_wx_cart_checked @"/wx/cart/checked"


/**
 接口名称： 删除购物车商品
 请求方式： POST方式
 接口说明： 删除购物车商品
 */
#define URL_wx_cart_delete @"/wx/cart/delete"


/**
 接口名称： 确认付款信息
 请求方式： GET方式
 接口说明： 确认付款信息
 */
#define URL_wx_cart_checkout @"/wx/cart/checkout"


/**
 接口名称： 收货地址列表
 请求方式： GET方式
 接口说明： 收货地址列表
 */
#define URL_wx_address_list @"/wx/address/list"

/**
 接口名称： 收货地址详情
 请求方式： GET方式
 接口说明： 收货地址详情
 */
#define URL_wx_address_detail @"/wx/address/detail"


/**
 接口名称： 删除收货地址
 请求方式： POST方式
 接口说明： 删除收货地址
 */
#define URL_wx_address_delete @"/wx/address/delete"


/**
 接口名称： 新增收货地址
 请求方式： POST方式
 接口说明： 新增收货地址
 */
#define URL_wx_address_save @"/wx/address/save"

/**
 接口名称： 获取行政区域
 请求方式： GET方式
 接口说明： 获取行政区域
 */
#define URL_wx_region_tree @"/wx/region/tree"


/**
 接口名称： 添加购物车，直接设置购物车数量
 请求方式： POST方式
 接口说明： 添加购物车，直接设置购物车数量
 */
#define URL_cart_add_set @"/cart/add/set"


#pragma mark - ——————— 个人中心 ————————
/**
 接口名称： 用户信息
 请求方式： GET方式
 接口说明： 用户信息
 */
#define URL_wx_oauth_mallUserInfo @"/wx/oauth/mallUserInfo"

/**
 接口名称： 注销退出登录
 请求方式： POST方式
 接口说明： 注销退出登录
 */
#define URL_wx_auth_drop_out @"/wx/auth/drop_out"

/**
 接口名称： base64编码图片保存
 请求方式： POST方式
 接口说明： base64编码图片保存
 */
#define URL_wx_storage_saveimg @"/wx/storage/save-img"

/**
 接口名称： 获取个人资料
 请求方式： GET方式
 接口说明： 获取个人资料
 */
#define URL_wx_oauth_mallUserInfo @"/wx/oauth/mallUserInfo"


/**
 接口名称： 修改个人资料
 请求方式： POST方式
 接口说明： 修改个人资料
 */
#define URL_wx_oauth_modifyUserInfo @"/wx/oauth/modifyUserInfo"


/**
 接口名称： 我的收藏分页查询
 请求方式： GET方式
 接口说明： 我的收藏分页查询
 */
#define URL_wx_collect_list @"/wx/collect/list"

/**
 接口名称： 我的足迹删除
 请求方式： POST方式
 接口说明： 我的足迹删除
 */
#define URL_wx_footprint_delete @"/wx/footprint/delete"


/**
 接口名称： 订单查询
 请求方式： GET方式
 接口说明： 订单查询
 
 0     | 全部订单| 默认值
 1     | 待付款
 2     | 待发货
 3     | 待收货
 4     | 待评价
 */
#define URL_wx_order_list @"/wx/order/list"



/**
 接口名称： 订单退款申请
 请求方式： POST方式
 接口说明： 订单退款申请
 */
#define URL_wx_order_refund @"/wx/order/refund"

/**
 接口名称： 订单取消
 请求方式： POST方式
 接口说明： 订单取消
 */
#define URL_wx_order_cancel @"/wx/order/cancel"



/**
 接口名称： 确认收货
 请求方式： POST方式
 接口说明： 确认收货
 */
#define URL_wx_order_confirm @"/wx/order/confirm"



/**
 接口名称： 订单详情
 请求方式： GET方式
 接口说明： 订单详情
 */
#define URL_wx_order_detail @"/wx/order/detail"


/**
 接口名称： 物流轨迹(快递100)
 请求方式： POST方式
 接口说明： 物流轨迹(快递100)
 */
#define URL_wx_order_queryTrack @"/wx/order/queryTrack"



/**
 接口名称： 订单货品评价
 请求方式： POST方式
 接口说明： 订单货品评价
 */
#define URL_wx_comment_addComment @"/wx/comment/addComment"


/**
 接口名称：App列表支付接口: 订单中心订单列表 - 订单付款
 请求方式： POST方式
 接口说明： 订单中心订单列表 - 订单付款
 */
#define URL_wx_order_prepayApp @"/wx/order/prepayApp"


/**
 接口名称： App订单下单接口
 请求方式： POST方式
 接口说明： App订单下单接口
 */
#define URL_wx_order_submitApp @"/wx/order/submitApp"



/**
 接口名称： 钱包接口的基础信息
 请求方式： POST方式
 接口说明： 钱包接口的基础信息
 */
#define URL_wx_wallet_sdkwalletinfo @"/wx/wallet/sdk-wallet-info"


/**
 接口名称： 版本更新
 请求方式： POST方式
 接口说明： 版本更新
 */
#define URL_wx_apps_upgrade @"/wx/apps/upgrade"


/**
 接口名称： 评论详情
 请求方式： GET方式
 接口说明： 评论详情
 */
#define URL_wx_comment_orderDetail @"/wx/comment/orderDetail"


#endif /* XMFURLString_h */
