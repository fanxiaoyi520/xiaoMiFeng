//
//  XMFMyOrdersListHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListHeaderView.h"
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFMyOrdersListFooterModel.h"//操作的model


//在.m文件中添加
@interface  XMFMyOrdersListHeaderView()


@property (weak, nonatomic) IBOutlet UIView *orderStatusBgView;

/** 商品来源的图标 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsResourceImgView;


@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn;

/** 是否是删除 */
@property (nonatomic, assign) BOOL isDelete;


@end


@implementation XMFMyOrdersListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.orderStatusBgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | CornerDirectionTypeTopRight];
    
    if (self.isDelete) {
        //当状态为删除的时候排列按钮
        [self.orderStatusBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:8.f];
    }
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (self.isDelete) {
        
        if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyOrdersListHeaderViewDidClick:button:)]) {
            
            [self.delegate buttonsOnXMFMyOrdersListHeaderViewDidClick:self button:sender];
        }
    }
    
    
}

-(void)setListModel:(XMFMyOrdersListModel *)listModel{
    
    _listModel = listModel;
    
    /** 订单类型 1–bc 2–cc */
    if ([listModel.orderType isEqualToString:@"2"]) {
        
        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_haitao_60x17"];
        
    }else{
        
        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_guoji_60x17"];
    }
    
    
    OrderStatusInfo statusInfo = [GlobalManager getOrderStatusForKey:listModel.orderStatus];
    
    
    [self.orderStatusBtn setTitle:statusInfo.statusName forState:UIControlStateNormal];
    
    
    
    /**订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’）*/
    switch ([listModel.orderStatus integerValue]) {
            //等待付款
        case 101:
        
            //申请退款
        case 202:
        
            //待评价
        case 409:
        {
            
            [self.orderStatusBtn setTitleColor:UIColorFromRGB(0xFFBC0B) forState:UIControlStateNormal];
                        
        }
            break;
            
        default:{
            
            [self.orderStatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        }
            break;
    }
    
    
    BOOL value = [[listModel.handleOption objectForKey:@"delete"] boolValue];
    
    if (value) {
        
        self.isDelete = value;
        
        //当为删除的时候
        [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        
    }else{
        
        [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    
    
    /*
    //遍历字典
    NSArray<NSString *> *allKeysArr = [listModel.handleOption allKeys];
    
    for (int i = 0; i < allKeysArr.count; ++i) {
        
        NSString *key = allKeysArr[i];
        
        BOOL value = [[listModel.handleOption objectForKey:allKeysArr[i]] boolValue];

        
        if (value) {
            
            
            if ([key isEqualToString:@"delete"]) {
                //当为删除时
                self.isDelete = value;
                
                [self.orderStatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];

                [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
                
            }
            
            
            if ([key isEqualToString:@"pay"] || [key isEqualToString:@"cancelRefund"]) {
                //当为待付款时
                
                [self.orderStatusBtn setTitleColor:UIColorFromRGB(0xFFBC0B) forState:UIControlStateNormal];
                
                [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                
            }
            
            
            
        }else{
            
            [self.orderStatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            
             [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        
    }

    
    if (self.isDelete) {
        //当为删除的时候
        [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];

    }
    */
}



@end
