//
//  XMFSearchCollectionView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/26.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol historyDelegate <NSObject>
/*! ้ฟๆๅ ้ค */
- (void)delete :(NSString *)text;
/*! ้ไธญๆไธชitem */
- (void)select :(NSString *)text;

@end

@interface XMFSearchCollectionView : UICollectionView

/*! ๅๅงๅ */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout array :(NSMutableArray *)dataArray;
/*! ๆฐๆฎๆบ */
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,weak) id<historyDelegate> historyDelegate;
/*! ๅ ้คๆ้ฎ */
//@property(nonatomic,strong)BigSizeButton *deleteButton;


@end

NS_ASSUME_NONNULL_END
