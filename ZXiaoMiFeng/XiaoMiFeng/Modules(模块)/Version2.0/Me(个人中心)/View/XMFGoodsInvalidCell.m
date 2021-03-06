//
//  XMFGoodsInvalidCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/31.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsInvalidCell.h"
#import "XMFShoppingCartCellModel.h"//è´­ç©è½¦çæ»model
//#import "XMFMyCollectionModel.h"//æ¶èåè¡¨çæ»model
#import "XMFHomeGoodsCellModel.h"//é¦é¡µååmodel


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFGoodsInvalidCell()

/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** åååç§° */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** ååè§æ ¼ */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;

/** ååç¶æ */
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLB;


@end

@implementation XMFGoodsInvalidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsPicImgView.autoresizesSubviews = YES;

    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.cellRow == (self.invalidCount - 1)) {
        
        [self cornerWithRadius:10 direction:CornerDirectionTypeBottom];
    }
    
}

-(void)setCartInvalidModel:(XMFShoppingCartCellGoodsModel *)cartInvalidModel{
    
    _cartInvalidModel = cartInvalidModel;
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:cartInvalidModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodsNameLB.text = cartInvalidModel.goodsName;
    
    
    //éä¸­çååç±»å
    self.goodTypeLB.text = @"";
    for (int i= 0; i < cartInvalidModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,cartInvalidModel.specifications[i]];
        
    }
    
    
    //ååç¶æ
//    self.goodsStatusLB.text = cartInvalidModel.goodsStatus;
    
    /** ååç¶æ 0-å¤±æ 3-ä¸æ¶ 4-ä¸æ¶ 6-ç¼ºè´§ */
    switch ([cartInvalidModel.goodsStatus integerValue]) {
        case 0:{
            
             self.goodsStatusLB.text = XMFLI(@"ååå·²å¤±æ");
            
        }
            break;
            
        case 4:{
            
            self.goodsStatusLB.text = XMFLI(@"ååå·²ä¸æ¶");
            
        }
            break;
            
        case 6:{
            
            self.goodsStatusLB.text = XMFLI(@"åååºå­ä¸è¶³");
            
        }
            break;
            
        default:
            break;
    }
    
    
}


/*
-(void)setCollectionInvalidModel:(XMFMyCollectionSonModel *)collectionInvalidModel{
    
    _collectionInvalidModel = collectionInvalidModel;
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:collectionInvalidModel.goodsPicUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodsNameLB.text = collectionInvalidModel.goodsName;
    
    
   //éä¸­çååç±»å
   self.goodTypeLB.hidden = YES;
    
    
    
    //ååç¶æ

    //ååç¶æ å¤±æç±»å(0=æªå¤±æï¼1=ç¼ºè´§ï¼2=ä¸æ¶)
    switch ([collectionInvalidModel.invalidType integerValue]) {
            
        //case 0:{
            
        //    self.goodsStatusLB.text = XMFLI(@"ååå·²å¤±æ");
            
       // }
          //  break;
             
            
        case 2:{
            
            self.goodsStatusLB.text = XMFLI(@"ååå·²ä¸æ¶");
            
        }
            break;
            
        case 1:{
            
            self.goodsStatusLB.text = XMFLI(@"åååºå­ä¸è¶³");
            
        }
            break;
            
        default:
            break;
    }
    
}*/


//æ¶èåè¡¨çå¤±æåå
-(void)setCollectionInvalidModel:(XMFHomeGoodsCellModel *)collectionInvalidModel{
    
    _collectionInvalidModel = collectionInvalidModel;
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:collectionInvalidModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodsNameLB.text = collectionInvalidModel.goodsName;
    
    
   //éä¸­çååç±»å
   self.goodTypeLB.hidden = YES;
    
    
    //ååç¶æ

    //ååç¶æ å¤±æç±»å(0=æªå¤±æï¼1=ç¼ºè´§ï¼2=ä¸æ¶)
    //ææ¸¸ï¼0-å¤±æ 3-ä¸æ¶ 4-ä¸æ¶ 6-ç¼ºè´§
    switch ([collectionInvalidModel.shelveStatus integerValue]) {
            
        //case 0:{
            
        //    self.goodsStatusLB.text = XMFLI(@"ååå·²å¤±æ");
            
       // }
          //  break;
             
            
        case 4:{
            
            self.goodsStatusLB.text = XMFLI(@"ååå·²ä¸æ¶");
            
        }
            break;
            
        case 6:{
            
            self.goodsStatusLB.text = XMFLI(@"åååºå­ä¸è¶³");
            
        }
            break;
            
        default:
            break;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
