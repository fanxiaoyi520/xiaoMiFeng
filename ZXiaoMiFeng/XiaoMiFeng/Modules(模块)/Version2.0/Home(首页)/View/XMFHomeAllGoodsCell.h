//
//  XMFHomeAllGoodsCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel;

@class XMFHomeAllGoodsCell;

@protocol XMFHomeAllGoodsCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeAllGoodsCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *recommendModel;

@property (nonatomic, weak) id<XMFHomeAllGoodsCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
