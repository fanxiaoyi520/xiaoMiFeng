//
//  XMFHomeGoodsFilterPriceCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsFilterSonModel,XMFHomeGoodsFilterPriceCell;

@protocol XMFHomeGoodsFilterPriceCellDelegate<NSObject>

@optional//选择实现的方法

/** 输入发生改变的时候代理方法 */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel;

/** 输入结束的时候代理方法 */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellEndInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel;

@required//必须实现的方法

@end


@interface XMFHomeGoodsFilterPriceCell : UICollectionViewCell

/** 左边Tfd */
@property (weak, nonatomic) IBOutlet UITextField *leftTfd;

/** 右边Tfd */
@property (weak, nonatomic) IBOutlet UITextField *rightTfd;

/** 数据model */
@property (nonatomic, strong) XMFHomeGoodsFilterSonModel *sonModel;

@property (nonatomic, weak) id<XMFHomeGoodsFilterPriceCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
