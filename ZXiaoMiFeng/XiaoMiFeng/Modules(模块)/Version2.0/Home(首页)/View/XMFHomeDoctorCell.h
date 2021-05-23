//
//  XMFHomeDoctorCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFHomeDoctorCell;

@protocol XMFHomeDoctorCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeDoctorCellDidClick:(XMFHomeDoctorCell *)cell button:(UIButton *)button;


@required//必须实现的方法

@end

@interface XMFHomeDoctorCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *model;

@property (nonatomic, weak) id<XMFHomeDoctorCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
