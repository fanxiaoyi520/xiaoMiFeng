//
//  XMFOrderPayResultController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    payResultJumpFromHomeVc,//来自于首页等页面
    payResultJumpFromOrdersVc,//来自于订单中心
    
} payResultJumpFromType;


@interface XMFOrderPayResultController : XMFBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *sstatusImgView;

//支付状态
@property (weak, nonatomic) IBOutlet UILabel *statusLB;

//支付金额
@property (weak, nonatomic) IBOutlet UILabel *acountLB;

//支付方式
@property (weak, nonatomic) IBOutlet UILabel *payWayLB;

//支付信息字典
@property (nonatomic, strong) NSDictionary *payInfoDic;

//来自于哪里
@property (nonatomic, assign) payResultJumpFromType jumpFromType;


-(instancetype)initWithPayInfoDic:(NSDictionary *)infoDic jumpFromType:(payResultJumpFromType)jumpFromType;


@end

NS_ASSUME_NONNULL_END
