//
//  XMFShoppingSplitOrdersCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/27.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingSplitOrdersCell.h"
#import "XMFShoppingSplitOrdersGoodsCell.h"
#import "XMFShoppingSplitOrdersModel.h"


//在.m文件中添加
@interface  XMFShoppingSplitOrdersCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;


@property (weak, nonatomic) IBOutlet UILabel *goodsAcountLB;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end


@implementation XMFShoppingSplitOrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 20, 0);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
     // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    self.myCollectionView.collectionViewLayout = flowLayout;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;

    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFShoppingSplitOrdersGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFShoppingSplitOrdersGoodsCell class])];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingSplitOrdersCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFShoppingSplitOrdersCellDidClick:self button:sender];
    }
    
}


-(void)setSplitOrdersModel:(XMFShoppingSplitOrdersModel *)splitOrdersModel{
    
    _splitOrdersModel = splitOrdersModel;
    
    self.goodsAcountLB.text = [NSString stringWithFormat:@"共%zd件商品",splitOrdersModel.ordersGoods.count];
    
    [self.myCollectionView reloadData];
    
}


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.splitOrdersModel.ordersGoods.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFShoppingSplitOrdersGoodsCell *cell = (XMFShoppingSplitOrdersGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFShoppingSplitOrdersGoodsCell class]) forIndexPath:indexPath];
    
    
    cell.goodsModel = self.splitOrdersModel.ordersGoods[indexPath.item];
    
    return cell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(115, 100);

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
