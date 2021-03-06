//
//  XMFCommonCustomPopView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/11/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCommonCustomPopView;


@protocol XMFCommonCustomPopViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFCommonCustomPopViewDidClick:(XMFCommonCustomPopView *)popView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFCommonCustomPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/** ไปฃ็ๅฑๆง */
@property (nonatomic, weak) id<XMFCommonCustomPopViewDelegate> delegate;

/** ๆ้ฎ็นๅปblock */
@property (nonatomic, copy) void (^commonCustomPopViewBtnsClickBlock)(XMFCommonCustomPopView *popView,UIButton *button);

-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
