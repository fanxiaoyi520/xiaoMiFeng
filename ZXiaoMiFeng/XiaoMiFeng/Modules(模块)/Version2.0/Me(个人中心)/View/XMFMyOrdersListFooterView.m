//
//  XMFMyOrdersListFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListFooterView.h"
#import "XMFMyOrdersListFooterCell.h"//操作的cell
#import "XMFMyOrdersListFooterModel.h"//操作的model
#import "XMFMyOrdersListModel.h"//我的订单总model


//在.m文件中添加
@interface  XMFMyOrdersListFooterView()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 退款原因 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UILabel *amountLB;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 补充身份信息 */
@property (weak, nonatomic) IBOutlet UIButton *addIdentityBtn;



/** 操作的数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFMyOrdersListFooterModel *> *dataSourceArr;




@end

@implementation XMFMyOrdersListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
      
      flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
      
      // line 跟滚动方向相同的间距
      flowLayout.minimumLineSpacing = 12;
      
       // item 跟滚动方向垂直的间距
      flowLayout.minimumInteritemSpacing = 0;
      
      
      flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      

      self.myCollectionView.collectionViewLayout = flowLayout;
      
      self.myCollectionView.delegate = self;
      
      self.myCollectionView.dataSource = self;

    
     self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    //从右向左对齐
    self.myCollectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
      [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFMyOrdersListFooterCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFMyOrdersListFooterCell class])];
    
    
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self cornerWithRadius:10.f direction:CornerDirectionTypeBottomLeft | CornerDirectionTypeBottomRight];
    
    
    
    /*
    CGFloat radius = 4.f;
    
    
    [self.firstBtn cornerWithRadius:radius];
    
    
    [self.secondBtn xw_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:self.backgroundColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0x333333) borderWidth:1.f];
    
    [self.thirdBtn xw_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:self.backgroundColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0x333333) borderWidth:1.f];
    */
        

    
}




-(void)setListModel:(XMFMyOrdersListModel *)listModel{
    
    _listModel = listModel;
    
    
    //运费
    NSString *freightPriceStr = [NSString string];
    
    if (![[NSString removeSuffix:listModel.freightPrice] isEqualToString:@"0"]) {
        
        freightPriceStr = [NSString stringWithFormat:@" (含运费HK$ %@)",[NSString removeSuffix:listModel.freightPrice]];
        
    }
    
    
    //退款原因
    /*
    if (listModel.remark.length > 0) {
        
        self.tipsLB.text = [NSString stringWithFormat:@"*卖家拒绝退款原因：%@\n",listModel.remark];
        
    }else{
        
        self.tipsLB.text = [NSString stringWithFormat:@"%@\n",@" "];
    }*/
    
    self.tipsLB.text = [NSString stringWithFormat:@"%@\n",@" "];
    
    
    //实付金额
    NSString *actPriceStr = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:listModel.actualPrice]];
    
    
    
    NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:actPriceStr upperColor:UIColorFromRGB(0x333333) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16.f] lowerStr:freightPriceStr lowerColor:UIColorFromRGB(0x666666) lowerFont:[UIFont systemFontOfSize:14.f]];
    
    
    NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"实付："];
    
    [allTotalMoneyStr appendAttributedString:totalMoneyStr];
    
    self.amountLB.attributedText = allTotalMoneyStr;
    
    self.addIdentityBtn.hidden = !listModel.oldFlag;
    
    self.myCollectionView.hidden = listModel.oldFlag;
    
    //先判断不是老订单，是的话需要显示添加身份信息按钮，不是的话显示正常按钮
    if (!listModel.oldFlag) {
        
        [self.dataSourceArr removeAllObjects];
        
        //遍历字典
        NSMutableArray<NSString *> *allKeysArr = [NSMutableArray arrayWithArray:[listModel.handleOption allKeys]];


        
        for (int i = 0; i < allKeysArr.count; ++i) {
            
            BOOL value = [[listModel.handleOption objectForKey:allKeysArr[i]] boolValue];
            
            if (value) {
                
                NSString *key = allKeysArr[i];

                
                XMFMyOrdersListFooterModel *footerModel = [[XMFMyOrdersListFooterModel alloc]init];
                
                
                footerModel.handleOption = key;
                
                HandleOptionInfo handleInfo = [GlobalManager getHandleOptionForKey:key];
                
                footerModel.name = handleInfo.handleOptionName;
                
                footerModel.handleOptionNum = handleInfo.index;
                
                
                //当不为删除的时候才加入数组
                if (![key isEqualToString:@"delete"] && ![key isEqualToString:@"rebuy"] &&  ![key isEqualToString:@"addCart"]) {
                    
                  [self.dataSourceArr addObject:footerModel];
                    

                }
      
                
            }
            
            
        }
        
        
        
        /**
         
         思路：
         1、先创建一个空数组
         2、把上面遍历出来的数组再用一个不可变数组接收，因为一边遍历的时候边修改数组是会报错的；
         3、查看遍历出来的数组与需要特定的文字对比，加入到临时数组中，并删除原来数组中的元素；
         4、最后把遍历剩下的数组内容加到临时数组中去；
         5、最后把临时数组中的数据赋值到数组中去。
         搞定！
         
         
         
         */

        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        
        NSArray *dataSourceTempArr = [NSArray arrayWithArray:self.dataSourceArr];
        
        for (XMFMyOrdersListFooterModel *footerModel in dataSourceTempArr) {
            
           if ([footerModel.handleOption isEqualToString:@"confirm"] || [footerModel.handleOption isEqualToString:@"comment"] || [footerModel.handleOption isEqualToString:@"cancelRefund"] || [footerModel.handleOption isEqualToString:@"remind"] || [footerModel.handleOption isEqualToString:@"pay"] || [footerModel.handleOption isEqualToString:@"appendComment"]) {
               
               [tempArr addObject:footerModel];
               
               [self.dataSourceArr removeObject:footerModel];
               
               
           }
            
            
        }
        
        
        [tempArr addObjectsFromArray:self.dataSourceArr];
        
       
        self.dataSourceArr = tempArr;
        
        
        [self.myCollectionView reloadData];

    }

    
   
    
    //保证特殊按钮排在最右边
    /*
    if (self.dataSourceArr.count > 2){
        
        for (XMFMyOrdersListFooterModel *footerModel in self.dataSourceArr) {
            
            if ([footerModel.handleOption isEqualToString:@"confirm"] || [footerModel.handleOption isEqualToString:@"comment"] || [footerModel.handleOption isEqualToString:@"cancelRefund"] || [footerModel.handleOption isEqualToString:@"remind"] || [footerModel.handleOption isEqualToString:@"pay"] || [footerModel.handleOption isEqualToString:@"addCart"]) {
                
                NSInteger index = [self.dataSourceArr indexOfObject:footerModel];
                
        
                [self.dataSourceArr removeObject:footerModel];
                
                [self.dataSourceArr insertObject:footerModel atIndex:0];
                
                
            }
            
            
        }
        
    }*/
        
    
    /*
   static int i = 0;
    
    [listModel.handleOption enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
        if ([obj boolValue]) {
            
            XMFMyOrdersListFooterModel *footerModel = [[XMFMyOrdersListFooterModel alloc]init];
            
        
            footerModel.handleOption = key;
            
            footerModel.name = [self.handleOptionNameDic objectForKey:key];
            
            footerModel.handleOptionNum = i;
            
            [self.dataSourceArr addObject:footerModel];
            
            
        }
        
        DLog(@"key:%@\nobj:%@\ni:%d",key,obj,i)
        
        i++;
    }];*/
    
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyOrdersListFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFMyOrdersListFooterViewDidClick:self button:sender];
    }
    
}



#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFMyOrdersListFooterCell *footerCell = (XMFMyOrdersListFooterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFMyOrdersListFooterCell class]) forIndexPath:indexPath];

    footerCell.footerModel = self.dataSourceArr[indexPath.item];
    
    return footerCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    XMFMyOrdersListFooterCell *footerCell = (XMFMyOrdersListFooterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(cellOnXMFMyOrdersListFooterViewDidSelected:cell:)]) {
        
        [self.delegate cellOnXMFMyOrdersListFooterViewDidSelected:self cell:footerCell];
    }
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScaleWidth(85), self.myCollectionView.height);

}


#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray<XMFMyOrdersListFooterModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

@end
