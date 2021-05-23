//
//  XMFMyOrdersDetailHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersDetailHeaderView.h"
//#import "XMFMyOrdersDetailModel.h"//订单详情总model
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFOrdersLogisticsModel.h"//物流信息model


//在.m文件中添加
@interface  XMFMyOrdersDetailHeaderView()

/** 订单状态 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLB;

/** 订单状态提示的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTipsLBHeight;



/** 收件人信息背景view */
@property (weak, nonatomic) IBOutlet UIView *consigneeInfoBgView;

/** 物流状态的背景view */
@property (weak, nonatomic) IBOutlet UIView *logisticsBgView;

/** 物流状态的背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logisticsBgViewHeight;


/** 物流状态 */
@property (weak, nonatomic) IBOutlet UILabel *logisticsStatusLB;

/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLB;


/** 收件人 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;

/** 收件地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLB;


/** 仓库 */

@property (weak, nonatomic) IBOutlet UIView *warehouseBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warehouseBgViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *warehouseBtn;


@end

@implementation XMFMyOrdersDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    //物流信息添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.logisticsBgView addGestureRecognizer:tap];
    
    
    
    
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.consigneeInfoBgView cornerWithRadius:10.f];
    
}


-(void)setDetailModel:(XMFMyOrdersListModel *)detailModel{
    
    
    _detailModel = detailModel;
    
    
    OrderStatusInfo statusInfo = [GlobalManager getOrderStatusForKey:detailModel.orderStatus];

    if ([detailModel.orderStatus isEqualToString:@"104"]) {//订单处理中
        
        self.orderStatusLB.text = XMFLI(@"订单处理中，请稍等");
        
    }else{
        
        self.orderStatusLB.text = statusInfo.statusName;
        
    }

    
    
    NSMutableAttributedString *consigneeInfoStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:XMFLI(@"收件人：") upperColor:UIColorFromRGB(0x333333) upperFont:[UIFont systemFontOfSize:14.f] lowerStr:[NSString stringWithFormat:@"%@ %@",detailModel.consignee,detailModel.mobile] lowerColor:UIColorFromRGB(0x333333) lowerFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.f]];
        
    self.consigneeLB.attributedText = consigneeInfoStr;
    
    self.addressLB.text = detailModel.address;
    
    
       /**
     订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’）
     */
    
    
    //是否升级过地址
    if (!detailModel.isUpdateAddress) {
        
        switch ([detailModel.orderStatus integerValue]) {
                
            case 101://未付款
            case 104://订单处理中
                {
                    
                    
                    
                }
                break;
                
            case 201:{//已付款，待发货
                
               
                /** 拣货状态 1待拣货 2已拣货 */
                
                NSString *tipsStr = @" ";
                
                switch ([detailModel.allocateCargoStatus integerValue]) {
                    case 1:{//
                        
                        tipsStr = XMFLI(@"买家已付款，等待卖家发货");
                        
                    }
                        break;
                        
                    case 2:{//
                        
                        tipsStr = XMFLI(@"卖家已拣货");

                    }
                        break;
                        
                    default:
                        break;
                }
                
                
                if (detailModel.remark.length > 0) {
                    
                    //当有缺货说明的时候就要三行
                    self.orderTipsLB.numberOfLines = 3;
                    
                    tipsStr = [NSString stringWithFormat:@"%@\n平台拒绝退款原因：%@",tipsStr,detailModel.remark];
                    

                }
                
                
                if ([detailModel.outOfStock boolValue]) {
                    
                    tipsStr = XMFLI(@"有商品缺货了，再等等吧");
                }
                
                
                self.orderTipsLB.text = tipsStr;
            
                
//                self.orderTipsLB.text = XMFLI(@"买家已付款，等待卖家发货");

                
                
            }
                break;
                
            case 301:{//已发货，待收货
                
                //先确认已收货
                if ([detailModel.receipt boolValue]) {
                    
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    [formater setDateFormat:@"yyyy-MM-dd"];
                    
                    //当前时间的NSDate
                    NSDate* currentDate = [NSDate date];
                    
                    NSString *currentTimeString = [formater stringFromDate:currentDate];
                    
                    
                    NSInteger afterDay = [DateUtils compareBeginTime:currentTimeString endTime:detailModel.autoConfirmTime];
                    
                    
                    if (afterDay > 0) {
                        
                        self.orderTipsLB.text = [NSString stringWithFormat:@"剩余%zd天自动确认收货",afterDay];
                        
                    }else{
                        
                        self.orderTipsLB.hidden = YES;

                    }

                    
                    
                }else{
                    
                    self.orderTipsLB.hidden = YES;
                    
                    self.orderTipsLBHeight.constant = 0.f;
                    
                    //更新View的frame值才有效，使用layoutSubviews无效
                    
                    CGRect tempFrame = self.frame;
                    
                    tempFrame.size.height -= 60;
                    
                    self.frame = tempFrame;
                    
                }
                
                
            }
                break;
                
            default:{
                
                self.orderTipsLB.hidden = YES;
                
                self.orderTipsLBHeight.constant = 0.f;
                
                //更新View的frame值才有效，使用layoutSubviews无效
                
                CGRect tempFrame = self.frame;
                
                tempFrame.size.height -= 60;
                
                self.frame = tempFrame;
                
            }
                break;
        }
    }
    
    //重置一下，防止其他更改了头部数据不能
    detailModel.isUpdateAddress = NO;
    
    
    //仓库名称
    if (detailModel.warehouseName.length > 0) {
        
        [self.warehouseBtn setTitle:[NSString stringWithFormat:@"  %@",detailModel.warehouseName] forState:UIControlStateNormal];
        
        self.warehouseBgView.hidden = NO;
        
        
    }else{
        
        self.warehouseBgView.hidden = YES;
        
        self.warehouseBgViewHeight.constant = 0;
        
        //更新View的frame值才有效，使用layoutSubviews无效
        
        CGRect tempFrame = self.frame;

        tempFrame.size.height -= 27;

        self.frame = tempFrame;

    }
    
    
    
}


-(void)setLogisticsModel:(XMFOrdersLogisticsModel *)logisticsModel{
    
    _logisticsModel = logisticsModel;
    
    
    if (logisticsModel.tracks.count > 0) {
        
        XMFOrdersLogisticsTracksModel *tracksModel = [logisticsModel.tracks firstObject];
        

        NSMutableAttributedString *consigneeInfoStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:[NSString stringWithFormat:@"%@：",self.detailModel.shipChannel] upperColor:UIColorFromRGB(0x333333) upperFont:[UIFont systemFontOfSize:14.f] lowerStr:tracksModel.context lowerColor:UIColorFromRGB(0x333333) lowerFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.f]];
            
        self.logisticsStatusLB.attributedText = consigneeInfoStr;
        
        NSArray *timeStrArr = [tracksModel.time componentsSeparatedByString:@" "];
        
        self.timeLB.text = [NSString stringWithFormat:@"%@ %@",timeStrArr[0],timeStrArr[1]];
        
        self.logisticsBgView.hidden = NO;
        
        self.logisticsBgViewHeight.constant = 84.f;
        
    }else{
        
        self.logisticsBgView.hidden = YES;
        
        self.logisticsBgViewHeight.constant = 0.f;
        
        //更新View的frame值才有效，使用layoutSubviews无效
        
        CGRect tempFrame = self.frame;
        
        tempFrame.size.height -= 84;
        
        self.frame = tempFrame;
    }
    
    
}


//手势绑定方法
-(void)tapAction:(UIGestureRecognizer *)gesture{
    
    UIView *tapView = (UIView *)gesture.view;
    
    
    if ([self.delegate respondsToSelector:@selector(viewsOnXMFGoodsDetailHeaderViewDidTap:tapView:)]) {
        
        [self.delegate viewsOnXMFGoodsDetailHeaderViewDidTap:self tapView:tapView];
    }
    
}

@end
