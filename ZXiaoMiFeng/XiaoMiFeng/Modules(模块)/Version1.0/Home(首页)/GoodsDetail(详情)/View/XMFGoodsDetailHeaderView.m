//
//  XMFGoodsDetailHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailHeaderView.h"
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品信息model
#import "XMFGoodsDatailProductListModel.h"//商品规格信息model


//在.m文件中添加
@interface  XMFGoodsDetailHeaderView()<SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLB;



//商品规格
@property (weak, nonatomic) IBOutlet UIView *goodsTypeBgView;


//购买说明
@property (weak, nonatomic) IBOutlet UIView *goodsGuideBgView;

//图片数组
@property (nonatomic, strong) NSMutableArray *imagesArr;


@end

@implementation XMFGoodsDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //规格选择添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.goodsTypeBgView addGestureRecognizer:tap];
    
    
    //购买说明添加手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.goodsGuideBgView addGestureRecognizer:tap1];
    
    
    self.bannerView.delegate = self;
    
    
    self.bannerView.backgroundColor = KClearColor;
    
    self.bannerView.placeholderImage = [UIImage imageNamed:@"icon_common_placeRect"];
    
    self.bannerView.autoScrollTimeInterval = 5.f;
    
//    self.bannerView.bannerImageViewContentMode =  UIViewContentModeScaleAspectFit;
    
}


-(void)setDetailModel:(XMFGoodsDatailModel *)detailModel{
    
    _detailModel = detailModel;
    
    
    self.goodsNameLB.text = detailModel.info.name;
    
    
//    self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:[detailModel.productList firstObject].price]];
    
    self.goodsPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.goodsPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f] lowerStr:[NSString removeSuffix:[detailModel.productList firstObject].price] lowerColor:self.goodsPriceLB.textColor lowerFont:self.goodsPriceLB.font];
    
    //税费
    //taxFlag:是否包税，1包含，0不包含
    if (![[detailModel.productList firstObject].taxFlag boolValue]) {
        
      self.goodsTaxsLB.text = [NSString stringWithFormat:@"税费:HK$%@",[NSString removeSuffix:[detailModel.productList firstObject].incomeTax]];
        
        
    }else{
        
        self.goodsTaxsLB.text = @"";
        
    }
    
   
//    self.bannerView.imageURLStringsGroup = @[detailModel.info.picUrl];
    
    /*
    NSMutableArray *imageURLArr = [[NSMutableArray alloc]init];
    
    for (NSString *imageStr in detailModel.info.gallery) {
        
        //字符串转字典
        NSData *jsonData = [imageStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
        NSString *imageURL = [NSString stringWithFormat:@"%@",dic[@"image"]];
        
        [imageURLArr addObject:imageURL];
        
        
    }
    
    self.bannerView.imageURLStringsGroup = imageURLArr;
    */
    
    self.bannerView.imageURLStringsGroup = self.detailModel.galleryURLArr;
    
    
    //获取图片尺寸
    CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:[self.detailModel.galleryURLArr firstObject]]];
    
    //防止被除数为0导致闪退
    if (banerImgSize.width > 0) {
        
        
        self.bannerViewHeight.constant = banerImgSize.height/banerImgSize.width * KScreenWidth;
    }
    

    
    
    //默认选中第一个
    for (int i = 0; i < [detailModel.productList firstObject].specifications.count; ++i) {
        
        if (i == 0) {
           
            self.goodsTypeLB.text = [NSString stringWithFormat:@"已选:%@",[detailModel.productList firstObject].specifications[i]];
            
        }else{
            
            
            self.goodsTypeLB.text = [NSString stringWithFormat:@"%@，%@",self.goodsTypeLB.text,[detailModel.productList firstObject].specifications[i]];
        }
        
        
    }
    

    
    
}


-(void)setProductListModel:(XMFGoodsDatailProductListModel *)productListModel{
    
    _productListModel = productListModel;
    
    self.goodsPriceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:productListModel.price]];
    
    
    
    
//    self.goodsTypeLB.text = [NSString stringWithFormat:@"已选:%@",[productListModel.specifications lastObject]];
    
    
    //循环遍历数据给规格赋值
    for (int i = 0; i < productListModel.specifications.count; ++i) {
        
        if (i == 0) {
           
            self.goodsTypeLB.text = [NSString stringWithFormat:@"已选:%@",productListModel.specifications[i]];
            
        }else{
            
            
            self.goodsTypeLB.text = [NSString stringWithFormat:@"%@，%@",self.goodsTypeLB.text,productListModel.specifications[i]];
        }
        
        
    }
    
    
}



//手势绑定方法
-(void)tapAction:(UIGestureRecognizer *)gesture{
    
   
    
    UIView *tapView = (UIView *)gesture.view;
    
    
    if ([self.delegate respondsToSelector:@selector(viewsOnXMFGoodsDetailHeaderViewDidTap:view:)]) {
        
        [self.delegate viewsOnXMFGoodsDetailHeaderViewDidTap:self view:tapView];
    }
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsDetailHeaderViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsDetailHeaderViewDidClick:self button:sender];
    }
    
    
}

#pragma mark - SDCycleScrollViewDelegate 点击banner
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    DLog(@"%zd", index);
    
    if ([self.delegate respondsToSelector:@selector(imageViewOnXMFGoodsDetailHeaderView:didSelectItemAtIndex:)]) {
        
        [self.delegate imageViewOnXMFGoodsDetailHeaderView:self didSelectItemAtIndex:index];
    }
    
    
   
}

#pragma mark - ——————— 懒加载 ————————

-(NSMutableArray *)imagesArr{
    
    if (_imagesArr == nil) {
        _imagesArr = [[NSMutableArray alloc] init];
    }
    return _imagesArr;
    
    
}




@end
