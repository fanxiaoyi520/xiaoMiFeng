//
//  XMFHomeGoodsFilterCommonCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsFilterSonModel;

@class XMFHomeGoodsFilterCommonCell;

@protocol XMFHomeGoodsFilterCommonCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeGoodsFilterCommonCellDidClick:(XMFHomeGoodsFilterCommonCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomeGoodsFilterCommonCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *standardBtn;

@property (nonatomic, weak) id<XMFHomeGoodsFilterCommonCellDelegate> delegate;

@property (nonatomic, strong) XMFHomeGoodsFilterSonModel *sonModel;


@end

NS_ASSUME_NONNULL_END
