//
//  XMFSearchCollectionView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchCollectionView.h"
#import "XMFSearchCell.h"
#import "XMFSearchViewModel.h"

static NSString *cellID = @"searchID";


//在.m文件中添加
@interface  XMFSearchCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

/*! viewmodel */
@property(nonatomic,strong)XMFSearchViewModel *searchVM;


@end

@implementation XMFSearchCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout array :(NSMutableArray *)dataArray{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
//self.scrollEnabled = YES;
        _dataArray = [dataArray mutableCopy];
        self.backgroundColor = KWhiteColor;
        [self registerClass:[XMFSearchCell class] forCellWithReuseIdentifier:cellID];
    }
    return self;
}

#pragma mark --- 懒加载

/*
- (BigSizeButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [BigSizeButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectZero;
        [_deleteButton setImage:[UIImage imageNamed:@"Search-Delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}*/

- (XMFSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM =[[XMFSearchViewModel alloc]init];
    }
    return _searchVM;
}

#pragma mark ---UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.searchStr = self.dataArray[indexPath.item];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(removeCell:)];
//    [cell addGestureRecognizer:longPress];
    return cell;
    
}


#pragma mark --- UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMFSearchCell *cell = (XMFSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XMFSearchCell alloc]initWithFrame:CGRectZero];;
    }
    cell.searchStr = self.dataArray[indexPath.item];
    return [cell sizeForCell];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_historyDelegate select :_dataArray[indexPath.item]];
}

#pragma mark --- UILongPressGestureRecognizer

/*
- (void)removeCell:(UILongPressGestureRecognizer *)ges{
    CGPoint touchPoint = [ges locationInView:self];
    XMFSearchCell *cell = (XMFSearchCell *)ges.view;
    NSIndexPath *indexpath = [self indexPathForItemAtPoint:touchPoint];
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSLog(@"第%li个",(long)indexpath.item);
        self.deleteButton.frame = CGRectMake(cell.frame.size.width-20, 3, 20, 20);
//        [cell addSubview:self.deleteButton];
//        [self addShake:cell];
    }
}*/

/*! 添加抖动动画 */

//- (void)addShake : (SearchCollectionViewCell *)cell{
//    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.075 animations:^{
//            cell.transform = CGAffineTransformMakeRotation(-8/ 180.0 * M_PI);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.15 animations:^{
//            cell.transform = CGAffineTransformRotate(cell.transform,16 /180.0 * M_PI);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.1 animations:^{
//            cell.transform = CGAffineTransformRotate(cell.transform, -8 / 180.0 * M_PI);
//        }];
//    } completion:nil];
//}


/*
- (void)deleteData{
    XMFSearchCell *cell = (XMFSearchCell *)_deleteButton.superview;
//    [cell.layer removeAllAnimations];
//    [_deleteButton removeFromSuperview];
    [_historyDelegate delete:cell.wordLabel.text];
}*/

@end
