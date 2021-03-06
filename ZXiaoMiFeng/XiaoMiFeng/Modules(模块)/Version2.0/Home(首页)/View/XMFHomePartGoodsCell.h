//
//  XMFHomePartGoodsCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFHomePartGoodsCell,XMFThemeDetailListModel;

//@class XMFHomePartGoodsCell;

@protocol XMFHomePartGoodsCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomePartGoodsCellDidClick:(XMFHomePartGoodsCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomePartGoodsCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *model;

/** ไธ้ข่ฏฆๆๅ่กจmodel */
@property (nonatomic, strong) XMFThemeDetailListModel *themeListModel;

@property (nonatomic, weak) id<XMFHomePartGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
