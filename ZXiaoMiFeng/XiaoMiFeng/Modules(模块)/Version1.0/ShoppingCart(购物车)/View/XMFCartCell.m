//
//  XMFCartCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFCartCell.h"
//#import "XMFShoppingCartGoodModel.h"
#import "XMFShopCartModel.h"//购物车多层级model


//在.m文件中添加
@interface  XMFCartCell()

//选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

//商品封面图
@property (weak, nonatomic) IBOutlet UIImageView *goodCoverImgView;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;

//商品规格
@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodTypeLB;

//商品价格
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLB;

//商品税费
@property (weak, nonatomic) IBOutlet UILabel *goodTaxesLB;


//数量减
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

//数量加
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

//商品数量
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
    
    //以下三行代码防止图片变形
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
    
    
        //选中的商品类型
       self.goodTypeLB.text = @"";
       for (int i= 0; i < detailModel.specifications.count; ++i) {
 
           self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,detailModel.specifications[i]];
       
       }
    
    //taxFlag:是否包税，1包含，0不包含
       if (![detailModel.taxFlag boolValue]) {
    
//    if ([detailModel.taxes doubleValue] > 0) {
        
            
        double taxesNum = [detailModel.taxes doubleValue] * [detailModel.number integerValue];
        
        NSString *sumStr =  [NSString stringWithFormat:@"%f",taxesNum];
        
        self.goodTaxesLB.text = [NSString stringWithFormat:@"税费：HK$%@",[NSString removeSuffix:sumStr]];
        
    }else{
        
        self.goodTaxesLB.text = @"税费：商品已包税";
    }
      
       
       self.goodCout = [detailModel.number integerValue];
       
       self.chooseBtn.selected = detailModel.isChoose;
    
    
}




//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//选择
            
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartCellDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFCartCellDidClick:self button:sender];
            }
            
        }
            break;
            
        case 1:{//减
              
            /*
            self.goodCout--;
               
            if (self.goodCout <= 0){
                
                self.goodCout = 1;
                
                [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"实在不能再少啦")];
                
                return;
            }
            
             [self reduceOrAddGood];
             */
            
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.5) {
                
                //大于这个时间间隔就处理
                           
                if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartCellDidClick:button:)]) {
                    
                    [self.delegate buttonsOnXMFCartCellDidClick:self button:sender];
                }
                
                
            }
            
            time = currentTime;
            
            
                
        }
            break;
            
        case 2:{//加
                    
            /*
            self.goodCout++;
            
            if (self.goodCout > 5){
                
                self.goodCout = 5;
                
                [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"实在不能再多啦")];
                
                return;
            }
            
            [self reduceOrAddGood];
             */
            


            static NSTimeInterval time = 0.0;
             
             NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
             
             //限制用户点击按钮的时间间隔大于1秒钟
             
             if (currentTime - time > 0.5) {
                 
                 //大于这个时间间隔就处理
                            
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


//商品进行加减
-(void)reduceOrAddGood{
    
    self.goodCountTfd.text = [NSString stringWithFormat:@"%zd",self.goodCout];
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
