//
//  XMFSearchCollectionView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol historyDelegate <NSObject>
/*! 长按删除 */
- (void)delete :(NSString *)text;
/*! 选中某个item */
- (void)select :(NSString *)text;

@end

@interface XMFSearchCollectionView : UICollectionView

/*! 初始化 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout array :(NSMutableArray *)dataArray;
/*! 数据源 */
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,weak) id<historyDelegate> historyDelegate;
/*! 删除按钮 */
//@property(nonatomic,strong)BigSizeButton *deleteButton;


@end

NS_ASSUME_NONNULL_END
