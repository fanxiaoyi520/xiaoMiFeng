//
//  XMFURLSuffixString.h
//  thirdLgoin
//
//  Created by ðå°èèð on 2020/7/2.
//  Copyright Â© 2020 å°èè. All rights reserved.
//

#ifndef XMFURLSuffixString_h
#define XMFURLSuffixString_h

#define XMFDEBUG           //æ¬å°æµè¯ç¯å¢-åç½
//#define XMFRELEASE        //çº¿ä¸çäº§ç¯å¢-AppStoreçæ¬


/**æ¬å°æµè¯ç¯å¢**/
#if defined(XMFDEBUG)


#define XMF_PREFIX_URL @"http://testhk.qtopay.cn/member-service"




/**çº¿ä¸çäº§ç¯å¢**/
#elif defined(XMFRELEASE)

//V2.0çæ¬å°å
//#define XMF_PREFIX_URL @"https://gateway.xmfstore.com/member-services"

//V2.0çæ¬IPå°å
#define XMF_PREFIX_URL @"http://120.236.37.75:8086/member-services"


//V1.0çæ¬å°å
//#define XMF_PREFIX_URL @"https://common.sinopayonline.com/member-services"



#endif



/*-------------------å®å®ä¹åå²çº¿----------------*/


#pragma mark - âââââââ å¬å±æ°æ®çæ¥å£é ââââââââ
/**
 æ¥å£åç§°ï¼ å½å®¶æå°åºä»£ç 
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ å½å®¶æå°åºä»£ç 
 */
#define URL_comm_country_region_query @"/comm/country/region/query"



#pragma mark - âââââââ æ åç»å½åæ³¨åçæ¥å£é ââââââââ

/**
 æ¥å£åç§°ï¼ åºç¡ç»å½æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ åºç¡ç»å½æ¥å£ï¼ç®åä»ä½¿ç¨äºé®ç®±ç»å½
 */
#define URL_auth_login_basic @"/auth/login/basic"



/**
 æ¥å£åç§°ï¼ ææºç»å½æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ææºç»å½æ¥å£
 */
#define URL_auth_login_mobile @"/auth/login/mobile"



/**
 æ¥å£åç§°ï¼ é®ç®±æ³¨åæ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ é®ç®±æ³¨åæ¥å£
 */
#define URL_auth_register_email @"/auth/register/email"


/**
 æ¥å£åç§°ï¼ ææºæ³¨åæ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ææºæ³¨åæ¥å£
 */
#define URL_auth_register_mobile @"/auth/register/mobile"

/**
 æ¥å£åç§°ï¼ ç»å½é¡µé¢ä¿¡æ¯åæ§å¶
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ç»å½é¡µé¢ä¿¡æ¯åæ§å¶
 */
#define URL_platform_info @"/platform/info"


#pragma mark - âââââââ ç¬¬ä¸æ¹ææç¸å³çæ¥å£é ââââââââ

/**
 æ¥å£åç§°ï¼ ç¬¬ä¸æ¹æææ£æ¥æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ æªææ=ç¶æå¼202ï¼è°ç¨ææçç¸å³æ¥å£ï¼å·²ææ=ç¶æå¼200ä¸è¿åå¯¹åºçTokenå¼ï¼ç¸å½äºç»å½
 */
#define URL_third_check @"/third/check"


/**
 æ¥å£åç§°ï¼ ç¬¬ä¸æ¹ææç»å®æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ç¬¬ä¸æ¹ææç»å®æ¥å£
 */
#define URL_third_bound @"/third/bound"



#pragma mark - âââââââ éè¡è¯ç³»åæä½çæ¥å£é ââââââââ
/**
 æ¥å£åç§°ï¼ éè¡è¯ç»å®é®ç®±æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼åç½®æ¥å£ï¼è·åé®ç®±éªè¯ç æ¥å£ï¼
 */
#define URL_option_bind_mail @"/option/bind/mail"


/**
 æ¥å£åç§°ï¼ éè¡è¯ç»å®ææºæ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼åç½®æ¥å£ï¼è·åç­ä¿¡éªè¯ç æ¥å£ï¼
 */
#define URL_option_bind_mobile @"/option/bind/mobile"



/**
 æ¥å£åç§°ï¼
 åºäºé®ç®±çéè¡è¯å¯ç éç½®æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼åç½®æ¥å£ï¼è·åé®ç®±éªè¯ç æ¥å£ï¼
 */
#define URL_option_password_reset_mail @"/option/password/reset/mail"

/**
 æ¥å£åç§°ï¼ åºäºææºçéè¡è¯å¯ç éç½®æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼åç½®æ¥å£ï¼è·åç­ä¿¡éªè¯ç æ¥å£ï¼
 */
#define URL_option_password_reset_sms @"/option/password/reset/sms"


#pragma mark - âââââââ éªè¯ç åéåæ ¡éªçæ¥å£é ââââââââ

/**
 æ¥å£åç§°ï¼
 æ ¡éªç»å®è´¦æ·çé®ç®±éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼
 ï¼éç¨äºç¬¬ä¸æ¹ææç»å®ï¼è¿åå®å¨éªè¯ç´¢å¼åæ¯å¦ç»å®æ è¯ï¼
 */
#define URL_verify_mail_oauth_check @"/verify/mail/oauth/check"


/**
 æ¥å£åç§°ï¼ è·åé®ç®±éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ è·åç»å®é®ç®±éªè¯ç æ¥å£ï¼éç¨äºç¬¬ä¸æ¹ææç»å®ï¼ä¸å¤æ­æ¯å¦ç»å®ï¼ç±æ ¡éªæ¥å£è¿åå¤æ­ï¼
 */
#define URL_verify_mail_oauth_send @"/verify/mail/oauth/send"



/**
 æ¥å£åç§°ï¼ è·åç»å½é®ç®±éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºç»å½/éç½®ï¼æ ¡éªæ¯å¦ç»å®ï¼æªç»å®ä¸åéï¼
 */
#define URL_verify_mail_onex_send @"/verify/mail/onex/send"


/**
 æ¥å£åç§°ï¼ è·åæ´æ°ç­ä¿¡éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºæ³¨å/ç»å®ï¼æ ¡éªæ¯å¦ç»å®ï¼å·²ç»å®ä¸åéï¼
 */
#define URL_verify_mail_unex_send @"/verify/mail/unex/send"



/**
 æ¥å£åç§°ï¼ æ ¡éªææç»å®ç­ä¿¡éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºç¬¬ä¸æ¹ææç»å®ï¼è¿åå®å¨éªè¯ç´¢å¼åæ¯å¦ç»å®æ è¯ï¼
 */
#define URL_verify_sms_oauth_check @"/verify/sms/oauth/check"


/**
 æ¥å£åç§°ï¼ è·åææç»å®ç­ä¿¡éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºç¬¬ä¸æ¹ææç»å®ï¼ä¸å¤æ­æ¯å¦ç»å®ï¼ç±æ ¡éªæ¥å£è¿åå¤æ­ï¼
 */
#define URL_verify_sms_oauth_send @"/verify/sms/oauth/send"


/**
 æ¥å£åç§°ï¼ è·åç­ä¿¡éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºç»å½/éç½®ï¼æ ¡éªæ¯å¦ç»å®ï¼æªç»å®ä¸åéï¼
 */
#define URL_verify_sms_onex_send @"/verify/sms/onex/send"

/**
 æ¥å£åç§°ï¼ è·åç­ä¿¡éªè¯ç æ¥å£
 è¯·æ±æ¹å¼ï¼ POSTæ¹å¼
 æ¥å£è¯´æï¼ ï¼éç¨äºæ³¨å/ç»å®ï¼æ ¡éªæ¯å¦ç»å®ï¼å·²ç»å®ä¸åéï¼
 */
#define URL_verify_sms_unex_send @"/verify/sms/unex/send"


#endif /* XMFURLSuffixString_h */
