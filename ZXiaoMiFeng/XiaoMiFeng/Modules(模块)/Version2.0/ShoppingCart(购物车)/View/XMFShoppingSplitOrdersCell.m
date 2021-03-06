//
//  XMFShoppingSplitOrdersCell.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2021/1/27.
//  Copyright ยฉ 2021 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFShoppingSplitOrdersCell.h"
#import "XMFShoppingSplitOrdersGoodsCell.h"
#import "XMFShoppingSplitOrdersModel.h"


//ๅจ.mๆไปถไธญๆทปๅ 
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
    
    // line ่ทๆปๅจๆนๅ็ธๅ็้ด่ท
    flowLayout.minimumLineSpacing = 10;
    
     // item ่ทๆปๅจๆนๅๅ็ด็้ด่ท
    flowLayout.minimumInteritemSpacing = 0;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    self.myCollectionView.collectionViewLayout = flowLayout;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;

    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFShoppingSplitOrdersGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFShoppingSplitOrdersGoodsCell class])];
    
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingSplitOrdersCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFShoppingSplitOrdersCellDidClick:self button:sender];
    }
    
}


-(void)setSplitOrdersModel:(XMFShoppingSplitOrdersModel *)splitOrdersModel{
    
    _splitOrdersModel = splitOrdersModel;
    
    self.goodsAcountLB.text = [NSString stringWithFormat:@"ๅฑ%zdไปถๅๅ",splitOrdersModel.ordersGoods.count];
    
    [self.myCollectionView reloadData];
    
}


#pragma mark - โโโโโโโ UICollectionViewDataSource โโโโโโโโ

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
