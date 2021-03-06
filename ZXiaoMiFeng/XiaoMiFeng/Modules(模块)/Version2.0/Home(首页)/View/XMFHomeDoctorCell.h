//
//  XMFHomeDoctorCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFHomeDoctorCell;

@protocol XMFHomeDoctorCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeDoctorCellDidClick:(XMFHomeDoctorCell *)cell button:(UIButton *)button;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeDoctorCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *model;

@property (nonatomic, weak) id<XMFHomeDoctorCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
