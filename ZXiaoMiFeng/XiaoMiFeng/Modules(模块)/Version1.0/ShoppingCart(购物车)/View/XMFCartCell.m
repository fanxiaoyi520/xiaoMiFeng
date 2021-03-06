//
//  XMFCartCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/21.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFCartCell.h"
//#import "XMFShoppingCartGoodModel.h"
#import "XMFShopCartModel.h"//è´­ç©è½¦å¤å±çº§model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFCartCell()

//éæ©æé®
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

//ååå°é¢å¾
@property (weak, nonatomic) IBOutlet UIImageView *goodCoverImgView;

//åååç§°
@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;

//ååè§æ ¼
@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodTypeLB;

//ååä»·æ ¼
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLB;

//ååç¨è´¹
@property (weak, nonatomic) IBOutlet UILabel *goodTaxesLB;


//æ°éå
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

//æ°éå 
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

//ååæ°é
@property (weak, nonatomic) IBOutlet UITextField *goodCountTfd;



@end


@implementation XMFCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodCout = 1;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodCoverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodCoverImgView.autoresizesSubviews = YES;

    self.goodCoverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


/*
-(void)setModel:(XMFShoppingCartGoodModel *)model{
    
    _model = model;
    
    [self.goodCoverImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodNameLB.text = model.goodsName;
    
    self.goodPriceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:model.price]];;
    
    self.goodCountTfd.text = model.number;
    
    if (model.specifications.count > 0) {
        
         self.goodTypeLB.text = [NSString stringWithFormat:@"%@",model.specifications[0]];
        
    }
    

    
    self.goodCout = [model.number integerValue];
    
    self.chooseBtn.selected = [model.checked boolValue];
   
    
}*/

-(void)setDetailModel:(XMFShopCartDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    
    [self.goodCoverImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
       
    self.goodNameLB.text = detailModel.goodsName;
       
//       self.goodPriceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:detailModel.price]];
    
      self.goodPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.goodPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:detailModel.price] lowerColor:self.goodPriceLB.textColor lowerFont:self.goodPriceLB.font];
       
       self.goodCountTfd.text = detailModel.number;
       
//       if (detailModel.specifications.count > 0) {
//
//            self.goodTypeLB.text = [NSString stringWithFormat:@"%@",detailModel.specifications[0]];
//
//       }
    
    
        //éä¸­çååç±»å
       self.goodTypeLB.text = @"";
       for (int i= 0; i < detailModel.specifications.count; ++i) {
 
           self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,detailModel.specifications[i]];
       
       }
    
    //taxFlag:æ¯å¦åç¨ï¼1åå«ï¼0ä¸åå«
       if (![detailModel.taxFlag boolValue]) {
    
//    if ([detailModel.taxes doubleValue] > 0) {
        
            
        double taxesNum = [detailModel.taxes doubleValue] * [detailModel.number integerValue];
        
        NSString *sumStr =  [NSString stringWithFormat:@"%f",taxesNum];
        
        self.goodTaxesLB.text = [NSString stringWithFormat:@"ç¨è´¹ï¼HK$%@",[NSString removeSuffix:sumStr]];
        
    }else{
        
        self.goodTaxesLB.text = @"ç¨è´¹ï¼ååå·²åç¨";
    }
      
       
       self.goodCout = [detailModel.number integerValue];
       
       self.chooseBtn.selected = detailModel.isChoose;
    
    
}




//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//éæ©
            
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartCellDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFCartCellDidClick:self button:sender];
            }
            
        }
            break;
            
        case 1:{//å
              
            /*
            self.goodCout--;
               
            if (self.goodCout <= 0){
                
                self.goodCout = 1;
                
                [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"å®å¨ä¸è½åå°å¦")];
                
                return;
            }
            
             [self reduceOrAddGood];
             */
            
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //éå¶ç¨æ·ç¹å»æé®çæ¶é´é´éå¤§äº1ç§é
            
            if (currentTime - time > 0.5) {
                
                //å¤§äºè¿ä¸ªæ¶é´é´éå°±å¤ç
                           
                if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartCellDidClick:button:)]) {
                    
                    [self.delegate buttonsOnXMFCartCellDidClick:self button:sender];
                }
                
                
            }
            
            time = currentTime;
            
            
                
        }
            break;
            
        case 2:{//å 
                    
            /*
            self.goodCout++;
            
            if (self.goodCout > 5){
                
                self.goodCout = 5;
                
                [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"å®å¨ä¸è½åå¤å¦")];
                
                return;
            }
            
            [self reduceOrAddGood];
             */
            


            static NSTimeInterval time = 0.0;
             
             NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
             
             //éå¶ç¨æ·ç¹å»æé®çæ¶é´é´éå¤§äº1ç§é
             
             if (currentTime - time > 0.5) {
                 
                 //å¤§äºè¿ä¸ªæ¶é´é´éå°±å¤ç
                            
             if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartCellDidClick:button:)]) {
                     
                     [self.delegate buttonsOnXMFCartCellDidClick:self button:sender];
                 }
                 
                 
             }
             
             time = currentTime;
                    
        }
            break;
            
        default:
            break;
    }

    
    
}


//ååè¿è¡å å
-(void)reduceOrAddGood{
    
    self.goodCountTfd.text = [NSString stringWithFormat:@"%zd",self.goodCout];
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
