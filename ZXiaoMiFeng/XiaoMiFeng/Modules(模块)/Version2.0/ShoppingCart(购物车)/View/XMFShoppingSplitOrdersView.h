//
//  XMFShoppingSplitOrdersView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2021/1/27.
//  Copyright ยฉ 2021 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingSplitOrdersModel,XMFShoppingSplitOrdersView;

@protocol XMFShoppingSplitOrdersViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFShoppingSplitOrdersViewDidClick:(XMFShoppingSplitOrdersView *)splitOrdersView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFShoppingSplitOrdersView : UIView

-(void)show;

-(void)hide;

/** ้่ฆๆๅ็ๅๅๆฐๆฎๆฐ็ป */
@property (nonatomic, strong) NSArray<XMFShoppingSplitOrdersModel *> *dataSourceArr;


/**
 *  ๆ้ฎ้ไธญ,ไธญ้ดๅผ
 */
@property (nonatomic,strong) UIButton *selectedBtn;

/** ้ๆฉ็row */
@property (nonatomic, assign) NSInteger selectedIndexPathRow;


@property (nonatomic, weak) id<XMFShoppingSplitOrdersViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
