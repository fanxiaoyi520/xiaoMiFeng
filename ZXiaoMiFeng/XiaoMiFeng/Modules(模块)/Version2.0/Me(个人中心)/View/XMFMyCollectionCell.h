//
//  XMFMyCollectionCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyCollectionSonModel,XMFMyCollectionCell,XMFHomeGoodsCellModel;


@protocol XMFMyCollectionCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFMyCollectionCellDidClick:(XMFMyCollectionCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFMyCollectionCell : UITableViewCell


@property (nonatomic, assign) BOOL isSelected;

//@property (nonatomic, strong) XMFMyCollectionSonModel *sonModel;

@property (nonatomic, weak) id<XMFMyCollectionCellDelegate> delegate;

/** 2.1ๆถ่model */
@property (nonatomic, strong) XMFHomeGoodsCellModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
