//
//  XMFChooseGoodsTypeView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFChooseGoodsTypeView.h"
#import "XMFChooseGoodsTypeCell.h"
#import "XMFChooseGoodsTypeHeaderView.h"//组头
#import "XMFChooseGoodsTypeFooterView.h"//组尾

#import "UICollectionViewLeftAlignedLayout.h"//布局
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDetailSpecificationListModel.h"//商品规格model
#import "XMFGoodsDetailValueListModel.h"//商品规格数据model
#import "XMFGoodsDatailInfoModel.h"//商品信息model
#import "XMFGoodsDatailProductListModel.h"//商品规格总数model



//在.m文件中添加
@interface  XMFChooseGoodsTypeView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,XMFChooseGoodsTypeCellDelegate>


//背景view
@property (weak, nonatomic) IBOutlet UIView *bgView;


//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

//库存
@property (weak, nonatomic) IBOutlet UILabel *reoertoryLB;

//规格
@property (weak, nonatomic) IBOutlet UILabel *typeLB;

//税费
@property (weak, nonatomic) IBOutlet UILabel *taxsLB;


//规格列表
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

//规格列表的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


//减
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;


//加
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


//确定
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//底部View
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//客服
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

//暂无库存按钮
@property (weak, nonatomic) IBOutlet UIButton *noReoertoryBtn;


/** 记录最终商品的数量*/
@property (nonatomic,assign)NSInteger  goodCout;

//选中的商品规格数组
@property (nonatomic, strong) NSMutableArray *selectedTypeArr;



@end

@implementation XMFChooseGoodsTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    [self setupUI];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //当首页选择的时候
    if (self.chooseType == goodsListAddCart) {
        
        [self.serviceBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
        
        [self.collectBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
    }
    
    
    
    //以下三行代码防止图片变形

    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsImgView.autoresizesSubviews = YES;

    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   
}

-(void)setChooseType:(chooseGoodsType)chooseType{
    
    _chooseType = chooseType;
    
    //判断登录状态
    if (UserInfoModel.token.length == 0) {
        
        self.sureBtn.hidden = NO;
        
        [self.sureBtn setTitle:XMFLI(@"立即登录") forState:UIControlStateNormal];
        
        self.sureBtn.backgroundColor = UIColorFromRGB(0xFE9902);
        
        
        return;
        
    }
    
    
    
    switch (chooseType) {
        case goodsListAddCart:{//商品列表加入购物车
           
            self.bottomView.hidden = NO;
            

        }
            break;
        case goodsDetailChooseType:{//商品详情选择规格
            
            self.sureBtn.hidden = NO;
            
            [self.sureBtn setTitle:XMFLI(@"加入购物车") forState:UIControlStateNormal];
            
            self.sureBtn.backgroundColor = UIColorFromRGB(0xFE9902);
            
            
        }
            break;
        case goodsDetailAddCart:{//商品详情加入购物车
            
            self.sureBtn.hidden = NO;
            
            [self.sureBtn setTitle:XMFLI(@"确定") forState:UIControlStateNormal];
            
        }
            break;
            
        case goodsDetailSoonPay:{//商品详情立即支付
            
            self.sureBtn.hidden = NO;
            
            [self.sureBtn setTitle:XMFLI(@"确认购买") forState:UIControlStateNormal];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


//重写set方法
-(void)setModel:(XMFGoodsDatailModel *)model{
    
    _model = model;
    

    //商品各种规格的collectionview高度
    self.myCollectionViewHeight.constant = model.specificationList.count * (34 + 30 + 15);

    
    if ([model.specificationsStr isEqualToString:XMFLI(@"请选择店铺/规格")] || (model.specificationsStr.length == 0)) {
        
        //选中全部的第一个
        for (int i = 0; i < model.specificationList.count; ++i) {
            
            if (model.specificationList[i].valueList.count >0) {
                
                 [self.selectedTypeArr addObject:model.specificationList[i].valueList[0].value];
                
            }
            
        }
        
        
    }else{
        
        //去掉“已选:”
        model.specificationsStr = [model.specificationsStr substringFromIndex:3];
        
        //以@“ ”，如果没有空格就会是整个字符串
        self.selectedTypeArr = [NSMutableArray arrayWithArray:[model.specificationsStr componentsSeparatedByString:@"，"]];
        
        //已经选中的规格
//        [self.selectedTypeArr addObject:model.specificationsStr];
        
    }
    

    
    //从规格数组找到与选中规格相符的数据，给typeView的顶部赋值
    for (int i = 0; i < model.productList.count; ++i) {
        
        
        XMFGoodsDatailProductListModel *productModel = model.productList[i];
        
        //如果两个数组相同
        if ([self array:self.selectedTypeArr isEqualTo:productModel.specifications]) {
            
            //保存选中的产品规格
            self.selectedProductModel = productModel;
            
            
            [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:productModel.url] placeholderImage:[UIImage imageNamed:@"logo"]];
               
            
//            self.priceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:productModel.price]];
            
            
            self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont boldSystemFontOfSize:10.f] lowerStr:[NSString removeSuffix:productModel.price] lowerColor:self.priceLB.textColor lowerFont:[UIFont boldSystemFontOfSize:15.f]];
            
            
            
            self.reoertoryLB.text = [NSString stringWithFormat:@"库存%@%@",productModel.number,[[XMFGlobalManager getGlobalManager] getGoodsUnit:model.info.unit]];
            
            
            //税费
            //taxFlag:是否包税，1包含，0不包含
            if (([productModel.incomeTax floatValue] > 0) && ![productModel.taxFlag boolValue]) {
                
                
                 self.taxsLB.text = [NSString stringWithFormat:@"税费:HK$%@",[NSString removeSuffix:productModel.incomeTax]];
                
                
            }else{
                
                self.taxsLB.text = @"";
                
            }
            
           
 
            
        }
        
        
        //选中的规格内容与存在的规格内容进行对比，然后并把选中的规格选中
        self.typeLB.text = @"已选:";
        
        for (int j = 0; j < self.selectedTypeArr.count; ++j) {
            
            if (j == 0) {
                
                self.typeLB.text = [NSString stringWithFormat:@"%@%@",self.typeLB.text,self.selectedTypeArr[j]];
                
            }else{
                
                self.typeLB.text = [NSString stringWithFormat:@"%@，%@",self.typeLB.text,self.selectedTypeArr[j]];
                
            }
            

            
            
            NSString *selectedTypeStr = self.selectedTypeArr[j];
            
            //获取每组存在的规格
            XMFGoodsDetailSpecificationListModel *specificationListModel = model.specificationList[j];
            
            for (int k = 0; k < specificationListModel.valueList.count; ++k) {
                
                NSString *typeStr = specificationListModel.valueList[k].value;
                
                if ([selectedTypeStr isEqualToString:typeStr]) {
                    
                    //选中被选择的规格
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:k inSection:j] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                        
                    });
                    
                }
                
                
            }

            
        }
        
        
    }

    
    [self.myCollectionView reloadData];
    
    //收藏按钮选中与否
    self.collectBtn.selected = [model.userHasCollect boolValue];
    
}


//布局等
-(void)setupUI{

    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 10, 15);
    self.myCollectionView.collectionViewLayout = layout;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.allowsMultipleSelection = YES;
    [self.myCollectionView registerClass:[XMFChooseGoodsTypeCell class] forCellWithReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeCell class])];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
   
    [self.myCollectionView registerClass:[XMFChooseGoodsTypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeHeaderView class])];
    
     [self.myCollectionView registerClass:[XMFChooseGoodsTypeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeFooterView class])];
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//减
            
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.5) {
                
                //大于这个时间间隔就处理
                
                //防止self.goodCout莫名原因变得很大
                self.goodCout = [self.amountTfd.text integerValue];
                
                self.goodCout--;
                                
                if (self.goodCout <= 0){
                    
                    self.goodCout = 1;
                    
                    [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"亲,实在不能再少了")];
                    
                    
                }else{
                    
                    [self reduceOrAddGood];
                }
                
                
                
            }
            
            time = currentTime;
            
            

            
        }
            break;
            
        case 1:{//加
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.5) {
                
                //大于这个时间间隔就处理
                
                self.goodCout++;
                
                //看看库存是否大于5
                NSInteger goodsCountNum = [self.selectedProductModel.number integerValue] > 5 ? 5 : [self.selectedProductModel.number integerValue];
                
                if (self.goodCout > goodsCountNum){
                    
                    self.goodCout = [self.selectedProductModel.number integerValue];
                    
                    [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"亲,实在不能再多了")];
                    
                    
                }else{
                    
                      [self reduceOrAddGood];
                }
                
              
                
            }
            
            time = currentTime;
            
            
          
            
        }
            break;
            
        case 2:{//确定
            
            //传递选中的商品
            if (_ChooseGoodsTypeBlock) {
                _ChooseGoodsTypeBlock(self.selectedProductModel,self.amountTfd.text);
            }
            
            //执行代理方法
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFChooseGoodsTypeViewDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFChooseGoodsTypeViewDidClick:self button:sender];
            }
            
            [self hide];
            
        }
            break;
            
        case 3://客服
         
        case 4://收藏
         
        case 5://加入购物车
        
        case 6:{//立即购买
            
            //执行代理方法
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFChooseGoodsTypeViewDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFChooseGoodsTypeViewDidClick:self button:sender];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


//商品进行加减
-(void)reduceOrAddGood{
    
    self.amountTfd.text = [NSString stringWithFormat:@"%zd",self.goodCout];
    
}


//点击手势
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
         [self hide];
        
    }
    

   
}


//显示在整个界面上
-(void)show{
    
    //可以底部弹出
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



#pragma mark - ——————— 规格collectionview ————————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.model.specificationList.count;
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    XMFGoodsDetailSpecificationListModel *specificationListModel = [self.model.specificationList objectAtIndex:section];
    
    return specificationListModel.valueList.count;
    
   
}



-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFChooseGoodsTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    
    XMFGoodsDetailSpecificationListModel *specificationListModel = [self.model.specificationList objectAtIndex:indexPath.section];

    
    cell.valueModel = specificationListModel.valueList[indexPath.item];
    
    /*
    //默认选中第一个
    if (indexPath.item == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
              [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
        });
        
        
    }*/
    
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFGoodsDetailSpecificationListModel *specificationListModel = [self.model.specificationList objectAtIndex:indexPath.section];

    XMFGoodsDetailValueListModel *valueModel = specificationListModel.valueList[indexPath.item];
  
    return CGSizeMake([NSString SG_widthWithString:valueModel.value font:[UIFont systemFontOfSize:13.f]] + 20, 30);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //因为cell的空间是button，所以这里不执行
    /*
    //根据数据 把所有的都遍历一次 如果是当前点的cell 选中她 如果不是 就不选中她喽
    
    XMFGoodsDetailSpecificationListModel *specificationListModel = [self.model.specificationList objectAtIndex:indexPath.section];
    kWeakSelf(self)
    
    for (NSInteger i = 0; i < specificationListModel.valueList.count;i++) {
        
        if (i == indexPath.item) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                  [weakself.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                
            });
            
          
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [weakself.myCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES];
                
            });
            
           
        }
        
    }*/
    
    
    
//    [UIView performWithoutAnimation:^{
//        //刷新界面
//        [self.myCollectionView reloadData];
//    }];
//
   
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   //如果点击了当前已经选中的cell  忽略她~
    [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        XMFChooseGoodsTypeHeaderView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeHeaderView class]) forIndexPath:indexPath];
        
        XMFGoodsDetailSpecificationListModel *specificationModel = self.model.specificationList[indexPath.section];
        
        
        headView.standardLB.text = specificationModel.name;
        
                                               
        return headView;
    
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && self.model.specificationList.count > 1){
        
        XMFChooseGoodsTypeFooterView * footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([XMFChooseGoodsTypeFooterView class]) forIndexPath:indexPath];
                                               
        return footView;
        
        
    }else {
        
         return nil;
    }
    
    
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 34);
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (self.model.specificationList.count > 1) {
        
         return CGSizeMake(KScreenWidth, 1);
        
    }else{
        
        return CGSizeMake(KScreenWidth, 0);
        
        
    }
    
   
    
}


#pragma mark - ——————— XMFChooseGoodsTypeCell的代理方法 ————————
-(void)buttonsOnXMFChooseGoodsTypeCellDidClick:(XMFChooseGoodsTypeCell *)cell button:(UIButton *)button{
    
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    
    //根据数据 把所有的都遍历一次 如果是当前点的cell 选中她 如果不是 就不选中她喽
    
    XMFGoodsDetailSpecificationListModel *specificationListModel = [self.model.specificationList objectAtIndex:indexPath.section];
    
    kWeakSelf(self)
    
    for (NSInteger i = 0; i < specificationListModel.valueList.count;i++) {
        
        if (i == indexPath.item) {//如果是选中同一个
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                  [weakself.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                
            });
            
          
            
        }else {//选中的不是同一个
            
            
            
            //替换选中的内容
            XMFGoodsDetailValueListModel *valueModel = specificationListModel.valueList[indexPath.item];
            
            [self.selectedTypeArr replaceObjectAtIndex:indexPath.section withObject:valueModel.value];
            
            
            //从规格数组找到与选中的规格相符的数据
            for (int i = 0; i < self.model.productList.count; ++i) {
                
                
                XMFGoodsDatailProductListModel *productModel = self.model.productList[i];
                
                //如果两个数组相同
                if ([self array:self.selectedTypeArr isEqualTo:productModel.specifications]) {
                    
                    
                    //保存选中的产品规格
                    self.selectedProductModel = productModel;
                    
                    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:productModel.url] placeholderImage:[UIImage imageNamed:@"logo"]];
                    
                    
                    //                    self.priceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:productModel.price]];
                    
                    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont boldSystemFontOfSize:10.f] lowerStr:[NSString removeSuffix:productModel.price] lowerColor:self.priceLB.textColor lowerFont:[UIFont boldSystemFontOfSize:15.f]];
                    
                    
                    self.reoertoryLB.text = [NSString stringWithFormat:@"库存%@%@",productModel.number,[[XMFGlobalManager getGlobalManager] getGoodsUnit:self.model.info.unit]];
                    
                    
                    self.typeLB.text = @"已选:";
                    
                    for (int i = 0; i < self.selectedTypeArr.count; ++i) {
                        
                        //区分第一个和不是第一个
                        if (i == 0) {
                            
                            self.typeLB.text = [NSString stringWithFormat:@"%@%@",self.typeLB.text,self.selectedTypeArr[i]];
                            
                        }else{
                            
                            self.typeLB.text = [NSString stringWithFormat:@"%@，%@",self.typeLB.text,self.selectedTypeArr[i]];
                            
                        }
                        
                        
                    }
                    
                    //税费
                    //taxFlag:是否包税，1包含，0不包含
                    if (([productModel.incomeTax floatValue] > 0) && ![productModel.taxFlag boolValue]) {
                        
                        
                        self.taxsLB.text = [NSString stringWithFormat:@"税费:HK$%@",[NSString removeSuffix:productModel.incomeTax]];
                        
                        
                    }else{
                        
                        self.taxsLB.text = @"";
                        
                    }
                    

                    //只有当在登录状态下才变换按钮样式
                    if (UserInfoModel.token.length > 0 ) {
                        //根据库存设置确定按钮
                        switch (self.chooseType)
                        {
                            case goodsListAddCart:{
                                
                                if ([productModel.number integerValue] > 0) {
                                    
                                    self.noReoertoryBtn.hidden = YES;
                                    
                                }else{
                                    
                                    self.noReoertoryBtn.hidden = NO;
                                }
                                
                                
                            }
                                break;
                            case goodsDetailChooseType:{
                                
                                if ([productModel.number integerValue] > 0) {
                                    
                                    [self.sureBtn setTitle:XMFLI(@"加入购物车") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xFE9902);
                                    
                                    [self.sureBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = YES;
                                    
                                    
                                }else{
                                    
                                    [self.sureBtn setTitle:XMFLI(@"暂无库存") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xE5E5E5);
                                    
                                    [self.sureBtn setTitleColor:UIColorFromRGB(0x9A9A9A) forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = NO;
                                }
                                
                                
                            }
                                break;
                            case goodsDetailAddCart:{
                                
                                if ([productModel.number integerValue] > 0) {
                                    
                                    [self.sureBtn setTitle:XMFLI(@"确定") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xFB4D44);
                                    
                                    [self.sureBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = YES;
                                    
                                }else{
                                    
                                    [self.sureBtn setTitle:XMFLI(@"暂无库存") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xE5E5E5);
                                    
                                    [self.sureBtn setTitleColor:UIColorFromRGB(0x9A9A9A) forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = NO;
                                    
                                }
                                
                                
                            }
                                break;
                            case goodsDetailSoonPay:{
                                
                                if ([productModel.number integerValue] > 0) {
                                    [self.sureBtn setTitle:XMFLI(@"确认购买") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xFB4D44);
                                    
                                    [self.sureBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = YES;
                                    
                                    
                                }else{
                                    
                                    [self.sureBtn setTitle:XMFLI(@"暂无库存") forState:UIControlStateNormal];
                                    
                                    self.sureBtn.backgroundColor = UIColorFromRGB(0xE5E5E5);
                                    
                                    [self.sureBtn setTitleColor:UIColorFromRGB(0x9A9A9A) forState:UIControlStateNormal];
                                    
                                    self.sureBtn.enabled = NO;
                                    
                                }
                                
                                
                            }
                                break;
                                
                                
                            default:
                                break;
                        }
                    }
                    
                    
                  
                    
                    
                    
                    
                }
                
                
            }
            

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [weakself.myCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES];
                
            });
            
           
        }
        
    }
    
    
    
}

#pragma mark - ——————— 判断两个数组是否相同 ————————

- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
    
}




#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray *)selectedTypeArr{
    
    if (_selectedTypeArr == nil) {
        _selectedTypeArr = [[NSMutableArray alloc] init];
    }
    return _selectedTypeArr;
    
    
}


@end
