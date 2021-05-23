//
//  XMFHomeAllGoodsCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel;

@class XMFHomeAllGoodsCell;

@protocol XMFHomeAllGoodsCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomeAllGoodsCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *recommendModel;

@property (nonatomic, weak) id<XMFHomeAllGoodsCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
