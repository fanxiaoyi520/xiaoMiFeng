//
//  XMFPurchaseTipsView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/25.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsDetailModel;

@class XMFHomeGoodsDetailPurchaseInstructionsModel;


@interface XMFPurchaseTipsView : UIView

-(void)show;

-(void)hide;

//ๅๅฎนๆๅญ
@property (nonatomic, copy) NSString *contentStr;


@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** ่ดญ็ฉ่ฏดๆmodelๆฐ็ป */
@property (nonatomic, strong) NSArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> *instructionsModelArr;

@end

NS_ASSUME_NONNULL_END
