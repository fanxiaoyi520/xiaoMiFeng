//
//  XMFMyOrdersPopView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/9.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersPopView;

@protocol XMFMyOrdersPopViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFMyOrdersPopViewDidClick:(XMFMyOrdersPopView *)popView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFMyOrdersPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


-(void)show;

-(void)hide;


@property (nonatomic, weak) id<XMFMyOrdersPopViewDelegate> delegate;

/** ๆ้ฎ็นๅปblock */
@property (nonatomic, copy) void (^popViewBtnsClickBlock)(UIButton *button);

@end

NS_ASSUME_NONNULL_END
