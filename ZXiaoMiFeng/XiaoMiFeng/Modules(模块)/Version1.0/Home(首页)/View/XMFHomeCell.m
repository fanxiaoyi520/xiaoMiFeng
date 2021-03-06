//
//  XMFHomeCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/16.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHomeCell.h"
#import "XMFGoodsListModel.h"


//åš.mæä»¶äž­æ·»å 
@interface  XMFHomeCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;


@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@property (weak, nonatomic) IBOutlet UIButton *minusBtn;


@property (weak, nonatomic) IBOutlet UIButton *amountBtn;

/** è®°åœæç»ååçæ°é*/
@property (nonatomic,assign)NSInteger  goodCout;


@end

@implementation XMFHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥äžäžè¡ä»£ç é²æ­¢åŸçååœ¢
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsImgView.autoresizesSubviews = YES;

    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setModel:(XMFGoodsListModel *)model{
    
    _model = model;
    
    self.nameLB.text = model.name;
    
    
    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f] lowerStr:[NSString removeSuffix:model.retailPrice] lowerColor:self.priceLB.textColor lowerFont:self.priceLB.font];
    
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeSqua"]];
    
    
    if (model.number.length == 0) {
        //é²æ­¢åå§çæ¶åæ²¡ææ°æ®
        
         [self.amountBtn setTitle:@"0" forState:UIControlStateNormal];
        
    }else{
        
         [self.amountBtn setTitle:model.number forState:UIControlStateNormal];
        
    }

}


//é¡µé¢äžçæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //éå¶çšæ·ç¹å»æé®çæ¶éŽéŽéå€§äº1ç§é
    
    if (currentTime - time > 0.5) {
        
        //å€§äºè¿äžªæ¶éŽéŽéå°±å€ç
        if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeCellDidClick:button:)]) {
               
               [self.delegate buttonsOnXMFHomeCellDidClick:self button:sender];
        }
        
        
    }
    
    time = currentTime;
               
    
    
    
    /*
    switch (sender.tag) {
        case 0:{//å
            
            self.goodCout--;
                          
            if (self.goodCout <= 0){
                           
                self.goodCout = 0;
            }
                       
            [self reduceOrAddGood];
            
        }
            break;
            
        case 1:{//å 
             
            self.goodCout++;
                       
            [self reduceOrAddGood];
                
        }
            break;
            
        default:
            break;
    }*/
    
    
}


//ååè¿è¡å å
-(void)reduceOrAddGood{
    
    [self.amountBtn setTitle:[NSString stringWithFormat:@" %zd",self.goodCout] forState:UIControlStateNormal];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
