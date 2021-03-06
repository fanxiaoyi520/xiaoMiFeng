//
//  XMFHomeGoodsFilterPriceCell.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/5.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsFilterSonModel,XMFHomeGoodsFilterPriceCell;

@protocol XMFHomeGoodsFilterPriceCellDelegate<NSObject>

@optional//éæ©å®ç°çæ¹æ³

/** è¾å¥åçæ¹åçæ¶åä»£çæ¹æ³ */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel;

/** è¾å¥ç»æçæ¶åä»£çæ¹æ³ */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellEndInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel;

@required//å¿é¡»å®ç°çæ¹æ³

@end


@interface XMFHomeGoodsFilterPriceCell : UICollectionViewCell

/** å·¦è¾¹Tfd */
@property (weak, nonatomic) IBOutlet UITextField *leftTfd;

/** å³è¾¹Tfd */
@property (weak, nonatomic) IBOutlet UITextField *rightTfd;

/** æ°æ®model */
@property (nonatomic, strong) XMFHomeGoodsFilterSonModel *sonModel;

@property (nonatomic, weak) id<XMFHomeGoodsFilterPriceCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
