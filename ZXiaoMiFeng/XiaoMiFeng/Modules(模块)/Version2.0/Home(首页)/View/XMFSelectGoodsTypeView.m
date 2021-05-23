//
//  XMFSelectGoodsTypeView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSelectGoodsTypeView.h"
#import "XMFSelectGoodsTypeHeaderView.h"//组头
#import "XMFSelectGoodsTypeFooterView.h"//组尾
#import "XMFSelectGoodsTypeCell.h"//规格cell
#import "UICollectionViewLeftAlignedLayout.h"//布局
#import "XMFHomeGoodsPropertyModel.h"//规格总model

#import "XMFGoodsSpecInfoModel.h"//商品规格总model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model






#define NUMBERS @"0123456789"

//在.m文件中添加
@interface  XMFSelectGoodsTypeView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,XMFSelectGoodsTypeCellDelegate,UITextFieldDelegate>

/** 背景view */
@property (weak, nonatomic) IBOutlet UIView *bgView;


/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 库存 */
@property (weak, nonatomic) IBOutlet UILabel *stockLB;


/** 税费 */
@property (weak, nonatomic) IBOutlet UILabel *taxsFeeLB;


/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLB;


/** 规格列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 规格列表的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


/** 减 */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;


/** 加 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


/** 最多购买数的提示语 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


/** 确定 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


/** 记录最终商品的数量*/
@property (nonatomic,assign)NSInteger  goodCout;


/** 选中的商品规格数组 */
@property (nonatomic, strong) NSMutableArray *selectedTypeArr;

/** 选中的商品规格model */
@property (nonatomic, strong) XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel;


/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;



@end

@implementation XMFSelectGoodsTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);

    [self setupUI];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    [self.bgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | CornerDirectionTypeTopRight];
    
    [self.sureBtn cornerWithRadius:5.f];
    

    
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


//布局等
-(void)setupUI{

    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 10, 15);
    self.myCollectionView.collectionViewLayout = layout;
    self.myCollectionView.allowsMultipleSelection = YES;

    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.allowsMultipleSelection = YES;
    [self.myCollectionView registerClass:[XMFSelectGoodsTypeCell class] forCellWithReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeCell class])];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
   
    [self.myCollectionView registerClass:[XMFSelectGoodsTypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeHeaderView class])];
    
     [self.myCollectionView registerClass:[XMFSelectGoodsTypeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeFooterView class])];
    
    
    //设置代理方法
    self.amountTfd.delegate = self;
    
    
    //禁止输入
    self.amountTfd.enabled = NO;
    

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


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//减
            
            
            static NSTimeInterval time = 0.0;
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            
            //限制用户点击按钮的时间间隔大于1秒钟
            
            if (currentTime - time > 0.35) {
                
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
            
            if (currentTime - time > 0.35) {
                
                //大于这个时间间隔就处理
                
                self.goodCout++;
                
                //看看是否大于库存
//                NSInteger goodsCountNum = [self.selectedProductModel.stock integerValue];
                
                NSInteger goodsCountNum = [self.detailModel.stock integerValue];

                
                if (self.goodCout > goodsCountNum){
                    
                    
                    [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"亲,实在不能再多了")];
                    
                    
                }else{
                    
                      [self reduceOrAddGood];
                }
                
              
                
            }
            
            time = currentTime;
            
            
          
            
        }
            break;
            
        case 2:{//确定
            

            
            
            NSString *selectedGoodsKeyStr = [NSString string];
            
            //提示语文本
            NSString *tipsStr = [NSString string];
            
            
            for (int i = 0; i < self.selectedTypeArr.count; ++i) {
                
                NSString *selectedTypeStr = self.selectedTypeArr[i];
                
                if ([selectedTypeStr isEqualToString:@"*"]) {
                    
                    /*
                    [MBProgressHUD showOnlyTextToView:kAppWindow title:[NSString stringWithFormat:@"请选择 %@",self.fastFindNodeModel.fastFindNode[i].specName]];
                    
                    return;
                     */
                    
                    tipsStr = [NSString stringWithFormat:@"%@ %@",tipsStr,self.fastFindNodeModel.fastFindNode[i].specName];
                    
                };
                
                
                
                
                if (i == 0) {
                    
                    selectedGoodsKeyStr = self.selectedTypeArr[i];
                    
                }else{
                    
                    selectedGoodsKeyStr = [NSString stringWithFormat:@"%@,%@",selectedGoodsKeyStr,self.selectedTypeArr[i]];
                }

            }
            
            
            //如果有没有选择的就弹框
            if (tipsStr.length > 0 ) {
                
                [MBProgressHUD showOnlyTextToView:kAppWindow title:[NSString stringWithFormat:@"请选择 %@",tipsStr]];
                
                return;
            }
            
            
            NSString *selectedGoodsValueStr = [NSString stringWithFormat:@"%@",[self.specInfoModel.specInfoToGoodsId objectForKey:selectedGoodsKeyStr]];
            
            
            //block传递
            if (_selectGoodsSpecInfoBlock) {
                
                _selectGoodsSpecInfoBlock(selectedGoodsValueStr,self.amountTfd.text);
                
            }
            
            
            if ([self.delegate respondsToSelector:@selector(buttonsXMFSelectGoodsTypeViewDidClick:productId:selectedGoodCount:)]) {
                
                [self.delegate buttonsXMFSelectGoodsTypeViewDidClick:self productId:self.detailModel.productId selectedGoodCount:self.amountTfd.text];
            }
            
        
            
            
            /*
            //block传递

            if (_selectGoodsTypeBlock) {
                _selectGoodsTypeBlock(self.selectedProductModel,self.amountTfd.text);
            }
            
            if ([self.delegate respondsToSelector:@selector(buttonsXMFSelectGoodsTypeViewDidClick:button:)]) {
                
                [self.delegate buttonsXMFSelectGoodsTypeViewDidClick:self button:sender];
            }*/
            
            
            [self hide];
            
            
            
        }
            break;
            
  
            
        default:
            break;
    }
    
    
    
}

//商品进行加减
-(void)reduceOrAddGood{
    
    self.amountTfd.text = [NSString stringWithFormat:@"%zd",self.goodCout];
    
    if (self.goodCout >= [self.detailModel.stock integerValue]) {
        
        self.tipsLB.text = [NSString stringWithFormat:@"最多购买%@件",self.detailModel.stock];
        
        self.tipsLB.hidden = NO;
        
        self.addBtn.enabled = NO;
        
        
    }else{
        
        self.tipsLB.hidden = YES;
        
        self.addBtn.enabled = YES;

    }
    
}

#pragma mark - ——————— UITextField的代理方法 ————————

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
    //限制只能输入纯数字
    NSCharacterSet*cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    if(!basicTest) {
    
        return NO;
        
    }
    return YES;
}




- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        
        //看看是否大于库存
//        NSInteger goodsCountNum = [self.selectedProductModel.stock integerValue];
        
        NSInteger goodsCountNum = [self.detailModel.stock integerValue];

        
        
        NSInteger inputCount = [textField.text integerValue];
        
        if (inputCount > goodsCountNum){
            
            
            [MBProgressHUD showOnlyTextToView:self title:XMFLI(@"亲,库存不足了")];
            
            //如果输入的数量大于库存数的时候
            textField.text = self.detailModel.stock;
            
            
        }else{
            
            self.goodCout = inputCount;
        }
        
        
        //输入数量大于等于商品数量
        if (inputCount >= goodsCountNum) {
            
            self.tipsLB.text = [NSString stringWithFormat:@"最多购买%@件",self.detailModel.stock];
            
            self.tipsLB.hidden = NO;
            
            self.addBtn.enabled = NO;
            
            
        }else{
            
            self.tipsLB.hidden = YES;
            
            self.addBtn.enabled = YES;

        }
        
          
    }else{
        
        textField.text = @"1";
        
    }
    
  

    
}



#pragma mark - ——————— 规格collectionview ————————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
//    return self.propertyModel.goodsSpecifications.count;
    
    return self.specInfoModel.specs.count;
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    /*
    XMFHomeGoodsPropertySpecificationsModel *speciModel = self.propertyModel.goodsSpecifications[section];
    
    return speciModel.goodsSpecificationValues.count;
    */
    
    
    /*
    XMFGoodsSpecInfoSpecsModel *specsModel = self.specInfoModel.specs[section];
    
    return  specsModel.specValues.count;
     */
    
    
    XMFGoodsSpecInfoSpecsModel *specsModel = self.specInfoModel.specs[section];
    
    
    return specsModel.specValues.count;
   
}



-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFSelectGoodsTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    
    
    /*
    XMFHomeGoodsPropertySpecificationsModel *speciModel = self.propertyModel.goodsSpecifications[indexPath.section];
    
    cell.specivaluewsModel = speciModel.goodsSpecificationValues[indexPath.item];
    
     */
    
    /*
    XMFGoodsSpecInfoSpecsModel *specsModel = self.specInfoModel.specs[indexPath.section];
    
    cell.specValuesModel = specsModel.specValues[indexPath.item];
    */
    
    
    NSDictionary *dic = [self.fastFindNodeModel yy_modelToJSONObject];
    
    
    DLog(@"数组数组：%@",dic);
    
    //使用下面数据判断按钮能不能点击
    XMFGoodsSpecInfoSpecValuesModel *specValuesModel = self.fastFindNodeModel.fastFindNode[indexPath.section].values[indexPath.item];
    
    cell.specValuesModel = specValuesModel;
    
    
    //使用下面数据给cell赋值
    XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel = self.specInfoModel.specs[indexPath.section].specValues[indexPath.item];
    
    cell.fastFindNodeModel = fastFindNodeModel;
    
    
    return cell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    XMFHomeGoodsPropertySpecificationsModel *speciModel = self.propertyModel.goodsSpecifications[indexPath.section];
    
    XMFHomeGoodsPropertySpecificationsValuesModel *speciValuesModel = speciModel.goodsSpecificationValues[indexPath.item];
 
    return CGSizeMake([NSString SG_widthWithString:speciValuesModel.value font:[UIFont systemFontOfSize:13.f]] + 20, 30);
  */
    
    /*
    XMFGoodsSpecInfoSpecsModel *specsModel = self.specInfoModel.specs[indexPath.section];
    
    XMFGoodsSpecInfoSpecValuesModel *specValuesModel = specsModel.specValues[indexPath.item];
    */
    
//    XMFGoodsSpecInfoSpecValuesModel *specValuesModel = self.fastFindNodeModel.fastFindNode[indexPath.section].values[indexPath.item];
    
    XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel = self.specInfoModel.specs[indexPath.section].specValues[indexPath.item];

    
    return CGSizeMake([NSString SG_widthWithString:fastFindNodeModel.value font:[UIFont systemFontOfSize:13.f]] + 20, 30);
    
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
        
        XMFSelectGoodsTypeHeaderView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeHeaderView class]) forIndexPath:indexPath];
    
        /*
        XMFHomeGoodsPropertySpecificationsModel *speciModel = self.propertyModel.goodsSpecifications[indexPath.section];
        
        headView.standardLB.text = speciModel.name;
        */
        
        
        
        XMFGoodsSpecInfoSpecsModel *specsModel = self.specInfoModel.specs[indexPath.section];
        
        
        /*
        XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = self.fastFindNodeModel.fastFindNode[indexPath.section];
        */
        
        
        headView.standardLB.text = specsModel.specName;
        
                                               
        return headView;
    
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        XMFSelectGoodsTypeFooterView * footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([XMFSelectGoodsTypeFooterView class]) forIndexPath:indexPath];
                                               
        return footView;
        
        
    }else {
        
         return nil;
    }
    
    
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 43);
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 1);
    
   
    
}

#pragma mark - ——————— XMFSelectGoodsTypeCell的代理方法 ————————
- (void)buttonsOnXMFSelectGoodsTypeCellDidClick:(XMFSelectGoodsTypeCell *)cell button:(UIButton *)button{
    
    kWeakSelf(self)

    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    
    XMFGoodsSpecInfoFastFindNodeModel *tempFastFindNodeModel = self.fastFindNodeModel;
    

    
    if (!cell.specValuesModel.isSelected) {//按钮如果是没选中的
        
        
        for (int i = 0; i < tempFastFindNodeModel.fastFindNode.count; ++i) {
            
            XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = tempFastFindNodeModel.fastFindNode[i];
            
            if (i == indexPath.section) {//先找出点击的同一组
                
                for (int j = 0; j < fastFindNodeValuesModel.values.count; ++j) {
                    
                    XMFGoodsSpecInfoSpecValuesModel *valueModel = fastFindNodeValuesModel.values[j];
                    
                    if (j == indexPath.item) {//和点击的一样就选中
                        
                        valueModel.isSelected = YES;

                    }else{//和点击的不一样就不选中
                        
                        valueModel.isSelected = NO;

                    }
 
                }
                
            }
            
        }
        

        
        //根据数据 把所有的都遍历一次 如果是当前点的cell 选中它 如果不是 就不选中它喽
        
        XMFGoodsSpecInfoSpecsModel *specsModel = [self.specInfoModel.specs objectAtIndex:indexPath.section];
        
        XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel = specsModel.specValues[indexPath.item];
        
        NSDictionary  *dic0 = [fastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"取出来的数据：%@",dic0);
        
        
        XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = fastFindNodeModel.fastFindNode[indexPath.section];
        
        //替换选中的内容

        XMFGoodsSpecInfoSpecValuesModel *specValuesModel = fastFindNodeValuesModel.values[indexPath.item];
        
        [self.selectedTypeArr replaceObjectAtIndex:indexPath.section withObject:specValuesModel.specValue];
        
        

        //把即将选中的数据赋值为选中状态
        
        for (int k = 0; k < fastFindNodeModel.fastFindNode.count; ++k) {
            
            XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = fastFindNodeModel.fastFindNode[k];
            
            XMFGoodsSpecInfoFastFindNodeValuesModel *tempFastFindNodeValuesModel = tempFastFindNodeModel.fastFindNode[k];
            
            for (int l = 0; l < fastFindNodeValuesModel.values.count; ++l) {
                
                XMFGoodsSpecInfoSpecValuesModel *specValuesModel = fastFindNodeValuesModel.values[l];
                
                XMFGoodsSpecInfoSpecValuesModel *tempSpecValuesModel = tempFastFindNodeValuesModel.values[l];
                
                
                //把上一个的选中状态赋值给新的
                specValuesModel.isSelected = tempSpecValuesModel.isSelected;
                
                
                //把同组的可选和不可选与上一次的一样
                if (k == indexPath.section) {
                    
                    specValuesModel.enable = tempSpecValuesModel.enable;
                    
                    
                }
                
                
                DLog(@"%d - %zd",k,indexPath.section);
    
                //当原来有的规格是选中且不可选的时候，把选中数组的规格替换为*
                if (!specValuesModel.enable && specValuesModel.isSelected && k != indexPath.section) {
                    
                    //用*替换取消选中的规格
                    [self.selectedTypeArr replaceObjectAtIndex:k withObject:@"*"];
                }
                
                
            }
            
        }
        
    
        
        NSDictionary  *dic = [fastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"最后的数据字典：%@",dic);
        
        
        self.fastFindNodeModel = fastFindNodeModel;

    
        NSDictionary  *dic2 = [self.fastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"最后的数据字典2：%@",dic2);
        
        
        /*
        //把原来选中的数据复原
        for (XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel in tempFastFindNodeModel.fastFindNode) {
            
            
            for (XMFGoodsSpecInfoSpecValuesModel *valueModel in fastFindNodeValuesModel.values) {
                
                valueModel.isSelected = NO;
                
            }
            
            
        }*/
        
        
        NSDictionary  *dic1 = [self.fastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"最后的数据字典1：%@",dic1);
    
        
//            [self.myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        
    

 

        
        //获取选中的商品id
        NSString *selectedGoodsKeyStr = @"";
        
        //判断是否有空白没有选中的规格
        BOOL isBlankType = NO;
        
        for (int i = 0; i < self.selectedTypeArr.count; ++i) {
            
            NSString *selectedStr =  [NSString stringWithFormat:@"%@",self.selectedTypeArr[i]];
            
            if ([selectedStr isEqualToString:@"*"]) {
                
                isBlankType = YES;
            }
            
            if (i == 0) {
                
                selectedGoodsKeyStr = self.selectedTypeArr[i];
                
            }else{
                
                selectedGoodsKeyStr = [NSString stringWithFormat:@"%@,%@",selectedGoodsKeyStr,self.selectedTypeArr[i]];
            }
            
        }
        
        
        NSString *selectedGoodsValueStr = [NSString stringWithFormat:@"%@",[self.specInfoModel.specInfoToGoodsId objectForKey:selectedGoodsKeyStr]];
        
        
        if (!isBlankType) {//如果有规格没选中就不执行代理方法
            
            //代理
            if ([self.delegate respondsToSelector:@selector(selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:goodsId:)]) {
                
                [self.delegate selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:self goodsId:selectedGoodsValueStr];
            }
            
        }
        
        NSDictionary  *dic3 = [self.fastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"最后的数据字典3：%@",dic3);
        
        NSDictionary  *dic4 = [tempFastFindNodeModel yy_modelToJSONObject];
        
        DLog(@"最后的数据字典4：%@",dic4);
        
        
        [self.myCollectionView reloadData];

        
    }else{//选中同一个按钮:反选
        
        //用*替换取消选中的规格
        [self.selectedTypeArr replaceObjectAtIndex:indexPath.section withObject:@"*"];
        
        //只有反选的按钮，说明规格就没选全,这个最多购买数量的规格就要不显示
        self.tipsLB.hidden = YES;
        
        
        //判断是否有空白没有选中的规格
        BOOL isBlankType = NO;
        
        //剩下选中的规格字符串
        NSString *remainSelectedStr = @"";
        
        NSInteger remainSection = 0;
        
        for (int i = 0; i < self.selectedTypeArr.count; ++i) {
            
            NSString *selectedStr =  [NSString stringWithFormat:@"%@",self.selectedTypeArr[i]];
            
            if ([selectedStr isEqualToString:@"*"]) {
                
                isBlankType = YES;
                
            }else{
                
                remainSelectedStr = selectedStr;
                
                remainSection = i;
            }
            
            
        }
        

        
        //把选中数据里变为取消选中
        for (int i = 0; i < tempFastFindNodeModel.fastFindNode.count; ++i) {
            
            XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = tempFastFindNodeModel.fastFindNode[i];
            
            if (i == indexPath.section) {//先找出点击的同一组
                
                for (int j = 0; j < fastFindNodeValuesModel.values.count; ++j) {
                    
                    XMFGoodsSpecInfoSpecValuesModel *valueModel = fastFindNodeValuesModel.values[j];
                    
                    if (j == indexPath.item) {//和点击的一样就选中
                        
                        valueModel.isSelected = NO;
                        

                    }
 
                }
                
            }
            
            
            if (remainSelectedStr.length == 0) {//如果已经全部取消选中了，把所有限制都取消掉
                
                for (XMFGoodsSpecInfoSpecValuesModel *valueModel in fastFindNodeValuesModel.values) {
                    
                    valueModel.isSelected = NO;
                    
                    valueModel.enable = YES;
                }
                

            }
            
        }
        
        
        
        if (remainSelectedStr.length != 0) {//当还有选中的数据时候
            
            XMFGoodsSpecInfoSpecsModel *specsModel = [self.specInfoModel.specs objectAtIndex:remainSection];
    
            
            for (XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel in specsModel.specValues) {
                
                //如果剩下的规格和数据里面的一致
                if ([remainSelectedStr  isEqualToString:fastFindNodeModel.value]) {
                    
                    
                    for (int i = 0; i < fastFindNodeModel.fastFindNode.count; ++i) {
                        
                        XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = fastFindNodeModel.fastFindNode[i];
                        
                        XMFGoodsSpecInfoFastFindNodeValuesModel *tempFastFindNodeValuesModel = tempFastFindNodeModel.fastFindNode[i];
                        
                        for (int j = 0; j < fastFindNodeValuesModel.values.count; ++j) {
                            
                            
                            XMFGoodsSpecInfoSpecValuesModel *valuesModel = fastFindNodeValuesModel.values[j];
                            
                            XMFGoodsSpecInfoSpecValuesModel *tempSpecValuesModel = tempFastFindNodeValuesModel.values[j];
                            
                            //把上一个的选中状态赋值给新的
                            valuesModel.isSelected = tempSpecValuesModel.isSelected;
                            
                        }
                        
                    }
                    
                    
                    self.fastFindNodeModel = fastFindNodeModel;

                    
                }
                
                
                
            }
            
            
            
            
           
            
        }
        
        
        
 /*
        //把即将选中的数据赋值为选中状态
        for (XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel in self.fastFindNodeModel.fastFindNode) {
            
            
            for (int i = 0; i < fastFindNodeValuesModel.values.count; ++i) {
                
                XMFGoodsSpecInfoSpecValuesModel *specValuesModel = fastFindNodeValuesModel.values[i];
                
                if (indexPath.item == i) {
                    
                    specValuesModel.isSelected = NO;
                }
                
            }
            
            
        }*/
        
        
        
        [self.myCollectionView reloadData];
        
        
        
        
    }
    

    
    

    
    /*
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    
    //根据数据 把所有的都遍历一次 如果是当前点的cell 选中它 如果不是 就不选中它喽
    
    XMFGoodsSpecInfoSpecsModel *specsModel = [self.specInfoModel.specs objectAtIndex:indexPath.section];
    
    XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel = specsModel.specValues[indexPath.item];
    
    
    XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = fastFindNodeModel.fastFindNode[indexPath.section];
    
    
    
    kWeakSelf(self)
    
    for (NSInteger i = 0; i < fastFindNodeValuesModel.values.count;i++) {
        
        if (i == indexPath.item) {//如果是选中同一个
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                  [weakself.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                
            });
            
            
        }else {//选中的不是同一个
            
            
            self.fastFindNodeModel = fastFindNodeModel;
            
            
            [self.myCollectionView reloadData];
            
            
//            [self.myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            
        
            //替换选中的内容
    
            XMFGoodsSpecInfoSpecValuesModel *specValuesModel = fastFindNodeValuesModel.values[indexPath.item];
            
            [self.selectedTypeArr replaceObjectAtIndex:indexPath.section withObject:specValuesModel.specValue];
     
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [weakself.myCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES];
                
            });
            
            
            //获取选中的商品id
            NSString *selectedGoodsKeyStr = [NSString string];
            
            for (int i = 0; i < self.selectedTypeArr.count; ++i) {
                
                if (i == 0) {
                    
                    selectedGoodsKeyStr = self.selectedTypeArr[i];
                    
                }else{
                    
                    selectedGoodsKeyStr = [NSString stringWithFormat:@"%@,%@",selectedGoodsKeyStr,self.selectedTypeArr[i]];
                }
                
            }
            
            
            NSString *selectedGoodsValueStr = [NSString stringWithFormat:@"%@",[self.specInfoModel.specInfoToGoodsId objectForKey:selectedGoodsKeyStr]];
            
            
            //代理
            if ([self.delegate respondsToSelector:@selector(selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:goodsId:)]) {
                
                [self.delegate selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:self goodsId:selectedGoodsValueStr];
            }

            
           
        }
        
    }*/
    
    
    
    
    /*
    XMFHomeGoodsPropertySpecificationsModel *specificationListModel = [self.propertyModel.goodsSpecifications objectAtIndex:indexPath.section];
    
    kWeakSelf(self)
    
    for (NSInteger i = 0; i < specificationListModel.goodsSpecificationValues.count;i++) {
        
        if (i == indexPath.item) {//如果是选中同一个
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                  [weakself.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                
            });
            
          
            
        }else {//选中的不是同一个
            
        
            //替换选中的内容
            XMFHomeGoodsPropertySpecificationsValuesModel *valueModel = specificationListModel.goodsSpecificationValues[indexPath.item];
            
            [self.selectedTypeArr replaceObjectAtIndex:indexPath.section withObject:valueModel.value];
            
            
            //从规格数组找到与选中的规格相符的数据
            for (int i = 0; i < self.propertyModel.goodsProducts.count; ++i) {
                
                
                XMFHomeGoodsPropertyProductsModel *productModel = self.propertyModel.goodsProducts[i];
                
                //如果两个数组相同
                if ([self array:self.selectedTypeArr isEqualTo:productModel.specifications]) {
                    
                    
                    //保存选中的产品规格
                    self.selectedProductModel = productModel;
                    
                    //商品图片
                    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:productModel.url] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
                    
                    //库存
                    self.stockLB.text = [NSString stringWithFormat:@"库存 %@",productModel.stock];
                    
                    //价格
                    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont boldSystemFontOfSize:10.f] lowerStr:[NSString removeSuffix:productModel.price] lowerColor:self.priceLB.textColor lowerFont:[UIFont boldSystemFontOfSize:15.f]];
                    
                    //税费
                    //taxFlag:是否包税，1包含，0不包含
                    if (([productModel.incomeTax floatValue] > 0) && ![productModel.taxFlag boolValue]) {
                        
                        
                        self.taxsFeeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:productModel.incomeTax]];
                        
                        
                    }else{
                        
                        self.taxsFeeLB.text = @"";
                        
                    }
  
                }
                
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [weakself.myCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section] animated:YES];
                
            });
            
           
        }
        
    }*/
    
    
    
}


//刷新页面数量显示效果
-(void)refreshViews:(XMFHomeGoodsDetailModel *)detailModel{
    
    NSString *selectedGoodsKeyStr = [NSString string];
    
    //提示语文本
    NSString *tipsStr = [NSString string];
    
    //每次切换规格数据复位
    self.amountTfd.text = @"1";
    
    self.goodCout = 1;
    
    
    for (int i = 0; i < self.selectedTypeArr.count; ++i) {
        
        NSString *selectedTypeStr = self.selectedTypeArr[i];
        
        if ([selectedTypeStr isEqualToString:@"*"]) {
    
            tipsStr = [NSString stringWithFormat:@"%@ %@",tipsStr,self.fastFindNodeModel.fastFindNode[i].specName];
        };

        if (i == 0) {
            
            selectedGoodsKeyStr = self.selectedTypeArr[i];
            
        }else{
            
            selectedGoodsKeyStr = [NSString stringWithFormat:@"%@,%@",selectedGoodsKeyStr,self.selectedTypeArr[i]];
        }

    }
    
    
    //如果有没有选择的就弹框
    if (tipsStr.length > 0 ) {
        
        //说明没选全

        self.tipsLB.hidden = YES;
        
        self.addBtn.enabled = YES;
    

    }else{
        
        //说明已经选择好了
        
        
        //判断库存数量和选择数量
        if ([detailModel.stock integerValue] <= [self.amountTfd.text integerValue]) {
            
            self.tipsLB.text = [NSString stringWithFormat:@"最多购买%@件",self.detailModel.stock];
            
            self.tipsLB.hidden = NO;
            
            self.addBtn.enabled = NO;
            
        }else{
            
            self.tipsLB.hidden = YES;
            
            self.addBtn.enabled = YES;
            
        }
    }
    

    
}

#pragma mark - ——————— 重写set方法 ————————
-(void)setPropertyModel:(XMFHomeGoodsPropertyModel *)propertyModel{
    
    _propertyModel = propertyModel;
    
    //商品名称
    self.goodsNameLB.text = propertyModel.goodsName;
    
    //商品各种规格的collectionview高度
    self.myCollectionViewHeight.constant = propertyModel.goodsSpecifications.count * (43 + 30 + 15 + 15);
    
    
    //选中全部的第一个
    for (int i = 0; i < propertyModel.goodsSpecifications.count; ++i) {
        
        if (propertyModel.goodsSpecifications[i].goodsSpecificationValues.count > 0) {
            
            [self.selectedTypeArr addObject:propertyModel.goodsSpecifications[i].goodsSpecificationValues[0].value];
            
        }
        
    }
    
    
    
    
    

        
    //从规格数组找到与选中规格相符的数据，给typeView的顶部赋值
    for (int i = 0; i < propertyModel.goodsProducts.count; ++i) {
        
        
        XMFHomeGoodsPropertyProductsModel *productModel = propertyModel.goodsProducts[i];
        
        //如果两个数组相同
        if ([self array:self.selectedTypeArr isEqualTo:productModel.specifications]) {
            
            //保存选中的产品规格
            self.selectedProductModel = productModel;
            
            //商品图片
            [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:productModel.url] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
            
            //库存
            self.stockLB.text = [NSString stringWithFormat:@"库存 %@",productModel.stock];
            
    
            //价格
            self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont boldSystemFontOfSize:10.f] lowerStr:[NSString removeSuffix:productModel.price] lowerColor:self.priceLB.textColor lowerFont:[UIFont boldSystemFontOfSize:15.f]];
            

            
            //税费
            //taxFlag:是否包税，1包含，0不包含
            if (([productModel.incomeTax floatValue] > 0) && ![productModel.taxFlag boolValue]) {
                
                
                self.taxsFeeLB.text = [NSString stringWithFormat:@"税费 HK$%@",[NSString removeSuffix:productModel.incomeTax]];
                
                
            }else{
                
                self.taxsFeeLB.text = @"";
                
            }
            
            
            
            
        }
        
        
        //选中的规格内容与存在的规格内容进行对比，然后并把选中的规格选中
        
        for (int j = 0; j < self.selectedTypeArr.count; ++j) {
            

            NSString *selectedTypeStr = self.selectedTypeArr[j];
            
            //获取每组存在的规格
            XMFHomeGoodsPropertySpecificationsModel *specificationListModel = propertyModel.goodsSpecifications[j];
            
            for (int k = 0; k < specificationListModel.goodsSpecificationValues.count; ++k) {
                
                NSString *typeStr = specificationListModel.goodsSpecificationValues[k].value;
                
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

    
}

//2.1版本规格
-(void)setSpecInfoModel:(XMFGoodsSpecInfoModel *)specInfoModel{
    
    _specInfoModel = specInfoModel;
    
    
    //商品各种规格的collectionview高度
    self.myCollectionViewHeight.constant = specInfoModel.specs.count * (43 + 30 + 15 + 15);
    
    
    /*
   static NSString *selectedGoodsIdKeyStr;
    
    
    //查找出商品id对应的key值
    [specInfoModel.specInfoToGoodsId enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        
        DLog(@"key = %@ and obj = %@", key, obj);
        
        NSString *objStr = [NSString stringWithFormat:@"%@",obj];
        
        if ([objStr isEqualToString:specInfoModel.goodsId]){
            
            selectedGoodsIdKeyStr = [NSString stringWithFormat:@"%@",key];
            
            DLog(@"----------%@",selectedGoodsIdKeyStr);
            
            //判断key值是否包含逗号,
            if ([selectedGoodsIdKeyStr containsString:@","]) {
                
                self.selectedTypeArr = [NSMutableArray arrayWithArray:[selectedGoodsIdKeyStr componentsSeparatedByString:@","]];
                
            }else{
                
                [self.selectedTypeArr addObject:selectedGoodsIdKeyStr];
            }
            
        }
        
    }];*/
    
    

    [self.selectedTypeArr removeAllObjects];
    
    NSString *selectedGoodsIdValueStr = [NSString string];
    

    // 将所有的key取出放入数组arr中
    NSArray *allkeysArr = [specInfoModel.specInfoToGoodsId allKeys];
    // 遍历arr 取出对应的key以及key对应的value
    for (NSInteger i = 0; i < allkeysArr.count; i++) {
               
        selectedGoodsIdValueStr = [NSString stringWithFormat:@"%@",[specInfoModel.specInfoToGoodsId objectForKey:allkeysArr[i]]];
        
        if ([selectedGoodsIdValueStr isEqualToString:specInfoModel.goodsId]) {
            
            
            //判断key值是否包含逗号,
            if ([allkeysArr[i] containsString:@","]) {
                
                self.selectedTypeArr = [NSMutableArray arrayWithArray:[allkeysArr[i] componentsSeparatedByString:@","]];
                
            }else{
                
                
                [self.selectedTypeArr addObject:allkeysArr[i]];
                
            }
            
            //结束for循环继续下面的操作
            break;
            
        }
        
        
        
    }
    
    
    
    //先取任意一个数据，以便有规格名称数据等
    XMFGoodsSpecInfoSpecsModel *specsModel = [specInfoModel.specs firstObject];

//    self.fastFindNodeModel = [specsModel.specValues firstObject];
    
    
    for (XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel in specsModel.specValues) {
        
        if ([fastFindNodeModel.value isEqualToString:[self.selectedTypeArr firstObject]]) {
            
            self.fastFindNodeModel = fastFindNodeModel;
        }
        
    }
    
    
    
    
    //选中的规格内容与存在的规格内容进行对比，然后并把选中的规格选

    for (int i = 0; i < self.selectedTypeArr.count; ++i) {
        
        NSString *selectedTypeStr = self.selectedTypeArr[i];
        

        XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = self.fastFindNodeModel.fastFindNode[i];
        
    
        for (XMFGoodsSpecInfoSpecValuesModel *valuesModel in fastFindNodeValuesModel.values) {
            
            if ([selectedTypeStr isEqualToString:valuesModel.specValue]) {
                
                valuesModel.isSelected = YES;
            }
            
        }


        [self.myCollectionView reloadData];
        
        /*
        XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel = [specsModel.specValues firstObject];
        
        self.fastFindNodeModel = fastFindNodeModel;
        
        
//        XMFGoodsSpecInfoSpecsModel *specsModel = specInfoModel.specs[i];
        
        XMFGoodsSpecInfoFastFindNodeValuesModel *fastFindNodeValuesModel = fastFindNodeModel.fastFindNode[i];
        
        for (int j = 0; j < fastFindNodeValuesModel.values.count; ++j) {
            
            NSString *typeStr = fastFindNodeValuesModel.values[j].specValue;
            
            if ([selectedTypeStr isEqualToString:typeStr]) {
                
                //选中被选择的规格
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    
                });
                
            }
            
            
        }*/
        
    }
    
    
}


-(void)setDetailModel:(XMFHomeGoodsDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    //商品名称
    self.goodsNameLB.text = detailModel.goodsName;
    
    //商品图片
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //库存
    self.stockLB.text = [NSString stringWithFormat:@"库存 %@",[NSString returnNonemptyString:detailModel.stock]];
    
    
    //价格
    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont boldSystemFontOfSize:10.f] lowerStr:[NSString removeSuffix:detailModel.retailPrice] lowerColor:self.priceLB.textColor lowerFont:[UIFont boldSystemFontOfSize:15.f]];
    
    //税费
    //taxFlag:是否包税，1包含，0不包含
    if (([detailModel.incomeTax floatValue] > 0) && ![detailModel.taxFlag boolValue]) {
        
        
        self.taxsFeeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:detailModel.incomeTax]];
        
        
    }else{
        
        self.taxsFeeLB.text = @"";
        
    }
    
    
    //刷新页面数据
    
    [self refreshViews:detailModel];
    
    
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
