//
//  XMFHomeCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeCell.h"
#import "XMFGoodsListModel.h"


//在.m文件中添加
@interface  XMFHomeCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;


@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@property (weak, nonatomic) IBOutlet UIButton *minusBtn;


@property (weak, nonatomic) IBOutlet UIButton *amountBtn;

/** 记录最终商品的数量*/
@property (nonatomic,assign)NSInteger  goodCout;


@end

@implementation XMFHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
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
        //防止初始的时候没有数据
        
         [self.amountBtn setTitle:@"0" forState:UIControlStateNormal];
        
    }else{
        
         [self.amountBtn setTitle:model.number forState:UIControlStateNormal];
        
    }

}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time > 0.5) {
        
        //大于这个时间间隔就处理
        if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeCellDidClick:button:)]) {
               
               [self.delegate buttonsOnXMFHomeCellDidClick:self button:sender];
        }
        
        
    }
    
    time = currentTime;
               
    
    
    
    /*
    switch (sender.tag) {
        case 0:{//减
            
            self.goodCout--;
                          
            if (self.goodCout <= 0){
                           
                self.goodCout = 0;
            }
                       
            [self reduceOrAddGood];
            
        }
            break;
            
        case 1:{//加
             
            self.goodCout++;
                       
            [self reduceOrAddGood];
                
        }
            break;
            
        default:
            break;
    }*/
    
    
}


//商品进行加减
-(void)reduceOrAddGood{
    
    [self.amountBtn setTitle:[NSString stringWithFormat:@" %zd",self.goodCout] forState:UIControlStateNormal];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
