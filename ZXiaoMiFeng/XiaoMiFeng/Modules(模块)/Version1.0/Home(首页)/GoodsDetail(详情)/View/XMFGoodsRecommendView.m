//
//  XMFGoodsRecommendView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsRecommendView.h"
#import "XMFGoodsRecommendCell.h"
#import "XMFGoodsRecommendModel.h"


//在.m文件中添加
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
    
    // 水平方向的间距
    _flowLayout.minimumLineSpacing = 10 ;
    
    // 垂直方向的间距
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

//布局

-(void)layoutSubviews{
    
    [super layoutSubviews];

    
}

-(void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    
    _dataSourceArr = dataSourceArr;
    
    [self.myCollectionView reloadData];
    
}

#pragma mark - ——————— collectionView的代理方法和数据源 ————————

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
