//
//  XMFMyOrdersListHeaderView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/31.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyOrdersListHeaderView.h"
#import "XMFMyOrdersListModel.h"//æçè®¢åæ»model
#import "XMFMyOrdersListFooterModel.h"//æä½çmodel


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFMyOrdersListHeaderView()


@property (weak, nonatomic) IBOutlet UIView *orderStatusBgView;

/** ååæ¥æºçå¾æ  */
@property (weak, nonatomic) IBOutlet UIImageView *goodsResourceImgView;


@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn;

/** æ¯å¦æ¯å é¤ */
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
        //å½ç¶æä¸ºå é¤çæ¶åæåæé®
        [self.orderStatusBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:8.f];
    }
    
}

//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (self.isDelete) {
        
        if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyOrdersListHeaderViewDidClick:button:)]) {
            
            [self.delegate buttonsOnXMFMyOrdersListHeaderViewDidClick:self button:sender];
        }
    }
    
    
}

-(void)setListModel:(XMFMyOrdersListModel *)listModel{
    
    _listModel = listModel;
    
    /** è®¢åç±»å 1âbc 2âcc */
    if ([listModel.orderType isEqualToString:@"2"]) {
        
        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_haitao_60x17"];
        
    }else{
        
        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_guoji_60x17"];
    }
    
    
    OrderStatusInfo statusInfo = [GlobalManager getOrderStatusForKey:listModel.orderStatus];
    
    
    [self.orderStatusBtn setTitle:statusInfo.statusName forState:UIControlStateNormal];
    
    
    
    /**è®¢åç¶æï¼101: 'æªä»æ¬¾â,102: 'ç¨æ·åæ¶â,103: 'ç³»ç»åæ¶â,109: 'ä»æ¬¾å¤±è´¥â,201: 'å·²ä»æ¬¾â, 202: 'ç³è¯·éæ¬¾â, 203: 'å·²éæ¬¾â, 204: 'å·²ä»æ¬¾ï¼éæ¬¾å¤±è´¥ï¼â, 209: 'éæ¬¾ä¸­â,301: 'å·²åè´§â,401: 'ç¨æ·æ¶è´§â, 402: âç³»ç»æ¶è´§â 409: 'å¾è¯ä»·âï¼*/
    switch ([listModel.orderStatus integerValue]) {
            //ç­å¾ä»æ¬¾
        case 101:
        
            //ç³è¯·éæ¬¾
        case 202:
        
            //å¾è¯ä»·
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
        
        //å½ä¸ºå é¤çæ¶å
        [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        
    }else{
        
        [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    
    
    /*
    //éåå­å¸
    NSArray<NSString *> *allKeysArr = [listModel.handleOption allKeys];
    
    for (int i = 0; i < allKeysArr.count; ++i) {
        
        NSString *key = allKeysArr[i];
        
        BOOL value = [[listModel.handleOption objectForKey:allKeysArr[i]] boolValue];

        
        if (value) {
            
            
            if ([key isEqualToString:@"delete"]) {
                //å½ä¸ºå é¤æ¶
                self.isDelete = value;
                
                [self.orderStatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];

                [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
                
            }
            
            
            if ([key isEqualToString:@"pay"] || [key isEqualToString:@"cancelRefund"]) {
                //å½ä¸ºå¾ä»æ¬¾æ¶
                
                [self.orderStatusBtn setTitleColor:UIColorFromRGB(0xFFBC0B) forState:UIControlStateNormal];
                
                [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                
            }
            
            
            
        }else{
            
            [self.orderStatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            
             [self.orderStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        
    }

    
    if (self.isDelete) {
        //å½ä¸ºå é¤çæ¶å
        [self.orderStatusBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];

    }
    */
}



@end
