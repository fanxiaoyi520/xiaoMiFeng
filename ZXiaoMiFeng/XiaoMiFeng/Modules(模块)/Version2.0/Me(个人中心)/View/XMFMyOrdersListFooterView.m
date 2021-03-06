//
//  XMFMyOrdersListFooterView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/31.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyOrdersListFooterView.h"
#import "XMFMyOrdersListFooterCell.h"//æä½çcell
#import "XMFMyOrdersListFooterModel.h"//æä½çmodel
#import "XMFMyOrdersListModel.h"//æçè®¢åæ»model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFMyOrdersListFooterView()<UICollectionViewDelegate,UICollectionViewDataSource>

/** éæ¬¾åå  */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UILabel *amountLB;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** è¡¥åèº«ä»½ä¿¡æ¯ */
@property (weak, nonatomic) IBOutlet UIButton *addIdentityBtn;



/** æä½çæ°æ®æ°ç» */
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
      
      // line è·æ»å¨æ¹åç¸åçé´è·
      flowLayout.minimumLineSpacing = 12;
      
       // item è·æ»å¨æ¹ååç´çé´è·
      flowLayout.minimumInteritemSpacing = 0;
      
      
      flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      

      self.myCollectionView.collectionViewLayout = flowLayout;
      
      self.myCollectionView.delegate = self;
      
      self.myCollectionView.dataSource = self;

    
     self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    //ä»å³åå·¦å¯¹é½
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
    
    
    //è¿è´¹
    NSString *freightPriceStr = [NSString string];
    
    if (![[NSString removeSuffix:listModel.freightPrice] isEqualToString:@"0"]) {
        
        freightPriceStr = [NSString stringWithFormat:@" (å«è¿è´¹HK$ %@)",[NSString removeSuffix:listModel.freightPrice]];
        
    }
    
    
    //éæ¬¾åå 
    /*
    if (listModel.remark.length > 0) {
        
        self.tipsLB.text = [NSString stringWithFormat:@"*åå®¶æç»éæ¬¾åå ï¼%@\n",listModel.remark];
        
    }else{
        
        self.tipsLB.text = [NSString stringWithFormat:@"%@\n",@" "];
    }*/
    
    self.tipsLB.text = [NSString stringWithFormat:@"%@\n",@" "];
    
    
    //å®ä»éé¢
    NSString *actPriceStr = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:listModel.actualPrice]];
    
    
    
    NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:actPriceStr upperColor:UIColorFromRGB(0x333333) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16.f] lowerStr:freightPriceStr lowerColor:UIColorFromRGB(0x666666) lowerFont:[UIFont systemFontOfSize:14.f]];
    
    
    NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"å®ä»ï¼"];
    
    [allTotalMoneyStr appendAttributedString:totalMoneyStr];
    
    self.amountLB.attributedText = allTotalMoneyStr;
    
    self.addIdentityBtn.hidden = !listModel.oldFlag;
    
    self.myCollectionView.hidden = listModel.oldFlag;
    
    //åå¤æ­ä¸æ¯èè®¢åï¼æ¯çè¯éè¦æ¾ç¤ºæ·»å èº«ä»½ä¿¡æ¯æé®ï¼ä¸æ¯çè¯æ¾ç¤ºæ­£å¸¸æé®
    if (!listModel.oldFlag) {
        
        [self.dataSourceArr removeAllObjects];
        
        //éåå­å¸
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
                
                
                //å½ä¸ä¸ºå é¤çæ¶åæå å¥æ°ç»
                if (![key isEqualToString:@"delete"] && ![key isEqualToString:@"rebuy"] &&  ![key isEqualToString:@"addCart"]) {
                    
                  [self.dataSourceArr addObject:footerModel];
                    

                }
      
                
            }
            
            
        }
        
        
        
        /**
         
         æè·¯ï¼
         1ãååå»ºä¸ä¸ªç©ºæ°ç»
         2ãæä¸é¢éååºæ¥çæ°ç»åç¨ä¸ä¸ªä¸å¯åæ°ç»æ¥æ¶ï¼å ä¸ºä¸è¾¹éåçæ¶åè¾¹ä¿®æ¹æ°ç»æ¯ä¼æ¥éçï¼
         3ãæ¥çéååºæ¥çæ°ç»ä¸éè¦ç¹å®çæå­å¯¹æ¯ï¼å å¥å°ä¸´æ¶æ°ç»ä¸­ï¼å¹¶å é¤åæ¥æ°ç»ä¸­çåç´ ï¼
         4ãæåæéåå©ä¸çæ°ç»åå®¹å å°ä¸´æ¶æ°ç»ä¸­å»ï¼
         5ãæåæä¸´æ¶æ°ç»ä¸­çæ°æ®èµå¼å°æ°ç»ä¸­å»ã
         æå®ï¼
         
         
         
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

    
   
    
    //ä¿è¯ç¹æ®æé®æå¨æå³è¾¹
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

//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyOrdersListFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFMyOrdersListFooterViewDidClick:self button:sender];
    }
    
}



#pragma mark - âââââââ UICollectionViewDataSource ââââââââ

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


#pragma mark - âââââââ æå è½½ ââââââââ
-(NSMutableArray<XMFMyOrdersListFooterModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

@end
