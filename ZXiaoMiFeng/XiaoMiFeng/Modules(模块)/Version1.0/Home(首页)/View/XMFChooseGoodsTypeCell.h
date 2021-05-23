//
//  XMFChooseGoodsTypeCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailValueListModel;

@class XMFChooseGoodsTypeCell;

@protocol XMFChooseGoodsTypeCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFChooseGoodsTypeCellDidClick:(XMFChooseGoodsTypeCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFChooseGoodsTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *standardBtn;

@property (nonatomic, strong) XMFGoodsDetailValueListModel *valueModel;

@property (nonatomic, weak) id<XMFChooseGoodsTypeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
