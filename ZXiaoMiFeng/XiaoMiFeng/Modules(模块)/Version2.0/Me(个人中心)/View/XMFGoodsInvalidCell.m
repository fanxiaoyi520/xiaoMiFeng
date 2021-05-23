//
//  XMFGoodsInvalidCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsInvalidCell.h"
#import "XMFShoppingCartCellModel.h"//购物车的总model
//#import "XMFMyCollectionModel.h"//收藏列表的总model
#import "XMFHomeGoodsCellModel.h"//首页商品model


//在.m文件中添加
@interface  XMFGoodsInvalidCell()

/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 商品规格 */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;

/** 商品状态 */
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLB;


@end

@implementation XMFGoodsInvalidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsPicImgView.autoresizesSubviews = YES;

    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.cellRow == (self.invalidCount - 1)) {
        
        [self cornerWithRadius:10 direction:CornerDirectionTypeBottom];
    }
    
}

-(void)setCartInvalidModel:(XMFShoppingCartCellGoodsModel *)cartInvalidModel{
    
    _cartInvalidModel = cartInvalidModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:cartInvalidModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = cartInvalidModel.goodsName;
    
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < cartInvalidModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,cartInvalidModel.specifications[i]];
        
    }
    
    
    //商品状态
//    self.goodsStatusLB.text = cartInvalidModel.goodsStatus;
    
    /** 商品状态 0-失效 3-上架 4-下架 6-缺货 */
    switch ([cartInvalidModel.goodsStatus integerValue]) {
        case 0:{
            
             self.goodsStatusLB.text = XMFLI(@"商品已失效");
            
        }
            break;
            
        case 4:{
            
            self.goodsStatusLB.text = XMFLI(@"商品已下架");
            
        }
            break;
            
        case 6:{
            
            self.goodsStatusLB.text = XMFLI(@"商品库存不足");
            
        }
            break;
            
        default:
            break;
    }
    
    
}


/*
-(void)setCollectionInvalidModel:(XMFMyCollectionSonModel *)collectionInvalidModel{
    
    _collectionInvalidModel = collectionInvalidModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:collectionInvalidModel.goodsPicUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = collectionInvalidModel.goodsName;
    
    
   //选中的商品类型
   self.goodTypeLB.hidden = YES;
    
    
    
    //商品状态

    //商品状态 失效类型(0=未失效；1=缺货；2=下架)
    switch ([collectionInvalidModel.invalidType integerValue]) {
            
        //case 0:{
            
        //    self.goodsStatusLB.text = XMFLI(@"商品已失效");
            
       // }
          //  break;
             
            
        case 2:{
            
            self.goodsStatusLB.text = XMFLI(@"商品已下架");
            
        }
            break;
            
        case 1:{
            
            self.goodsStatusLB.text = XMFLI(@"商品库存不足");
            
        }
            break;
            
        default:
            break;
    }
    
}*/


//收藏列表的失效商品
-(void)setCollectionInvalidModel:(XMFHomeGoodsCellModel *)collectionInvalidModel{
    
    _collectionInvalidModel = collectionInvalidModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:collectionInvalidModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = collectionInvalidModel.goodsName;
    
    
   //选中的商品类型
   self.goodTypeLB.hidden = YES;
    
    
    //商品状态

    //商品状态 失效类型(0=未失效；1=缺货；2=下架)
    //李游：0-失效 3-上架 4-下架 6-缺货
    switch ([collectionInvalidModel.shelveStatus integerValue]) {
            
        //case 0:{
            
        //    self.goodsStatusLB.text = XMFLI(@"商品已失效");
            
       // }
          //  break;
             
            
        case 4:{
            
            self.goodsStatusLB.text = XMFLI(@"商品已下架");
            
        }
            break;
            
        case 6:{
            
            self.goodsStatusLB.text = XMFLI(@"商品库存不足");
            
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
