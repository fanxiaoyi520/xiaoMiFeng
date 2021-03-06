//
//  XMFGoodsRecommendView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/9.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFGoodsRecommendView.h"
#import "XMFGoodsRecommendCell.h"
#import "XMFGoodsRecommendModel.h"


//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFGoodsRecommendView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@end

@implementation XMFGoodsRecommendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    // ๆฐดๅนณๆนๅ็้ด่ท
    _flowLayout.minimumLineSpacing = 10 ;
    
    // ๅ็ดๆนๅ็้ด่ท
    _flowLayout.minimumInteritemSpacing = 10;
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    if (@available (iOS 11.0,*)) {
        
        _myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _myCollectionView.delegate = self;
    
    _myCollectionView.dataSource = self;
    
//    _myCollectionView.pagingEnabled = YES;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsRecommendCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class])];
    
}

//ๅธๅฑ

-(void)layoutSubviews{
    
    [super layoutSubviews];

    
}

-(void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    
    _dataSourceArr = dataSourceArr;
    
    [self.myCollectionView reloadData];
    
}

#pragma mark - โโโโโโโ collectionView็ไปฃ็ๆนๆณๅๆฐๆฎๆบ โโโโโโโโ

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataSourceArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFGoodsRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class]) forIndexPath:indexPath];
    
    cell.model = self.dataSourceArr[indexPath.item];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 2.0, KScaleWidth(260));
     
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFGoodsRecommendModel *model = self.dataSourceArr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:recommendModel:)]) {
        
        [self.delegate goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:self recommendModel:model];
    }
    
    
}


@end
