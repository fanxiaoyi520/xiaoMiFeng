//
//  XMFGoodsRecommendCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsRecommendModel;
@class XMFGoodsRecommendCell;

@protocol XMFGoodsRecommendCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFGoodsRecommendCellDidClick:(XMFGoodsRecommendCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end




@interface XMFGoodsRecommendCell : UICollectionViewCell

@property (nonatomic, weak) id<XMFGoodsRecommendCellDelegate> delegate;


//ๅๅ่ฏฆๆ้้ข็ไธบไฝ ๆจ่
@property (nonatomic, strong) XMFGoodsRecommendModel *model;

//ไธชไบบไธญๅฟ้้ข็ๆ็่ถณ่ฟน
@property (nonatomic, strong) XMFGoodsRecommendModel *footprintModel;

//ไธชไบบไธญๅฟ้้ข็ๆ็ๆถ่
@property (nonatomic, strong) XMFGoodsRecommendModel *collectionModel;

@end

NS_ASSUME_NONNULL_END
