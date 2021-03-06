//
//  XMFGoodsShareView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/26.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsDetailModel;

@class XMFGoodsShareView;

@protocol XMFGoodsShareViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFGoodsShareViewDidClick:(XMFGoodsShareView *)shareView button:(UIButton *)button;

-(void)viewsOnXMFGoodsShareViewDidLongPress:(XMFGoodsShareView *)shareView;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFGoodsShareView : UIView

-(void)show;

-(void)hide;

@property (nonatomic, weak) id<XMFGoodsShareViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

/** ๆชๅพ้จๅ็view */
@property (weak, nonatomic) IBOutlet UIView *screenshotBgView;

/** ๆ็คบ่ฏญ็ๆๅญ */
@property (nonatomic, copy) NSString *tipsStr;


@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;


@end

NS_ASSUME_NONNULL_END
