//
//  XMFSelectGoodsTypeCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/4.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsPropertySpecificationsValuesModel;

@class XMFSelectGoodsTypeCell;

@class XMFGoodsSpecInfoSpecValuesModel;

@class XMFGoodsSpecInfoFastFindNodeModel;

@protocol XMFSelectGoodsTypeCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFSelectGoodsTypeCellDidClick:(XMFSelectGoodsTypeCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFSelectGoodsTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *standardBtn;

@property (nonatomic, weak) id<XMFSelectGoodsTypeCellDelegate> delegate;

/** ๅๅ่งๆ ผ */
@property (nonatomic, strong) XMFHomeGoodsPropertySpecificationsValuesModel *specivaluewsModel;

/** 2.1ๅๅ่งๆ ผ */
@property (nonatomic, strong) XMFGoodsSpecInfoSpecValuesModel *specValuesModel;

/** 2.1่งๆ ผๅ็งฐ */
@property (nonatomic, strong) XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel;

@end

NS_ASSUME_NONNULL_END
