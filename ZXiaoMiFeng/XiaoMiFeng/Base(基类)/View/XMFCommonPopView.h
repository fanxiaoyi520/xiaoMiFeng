//
//  XMFComonPopView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCommonPopView;

@protocol XMFCommonPopViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFCommonPopViewDidClick:(XMFCommonPopView *)popView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end



@interface XMFCommonPopView : UIView


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/** ไปฃ็ๅฑๆง */
@property (nonatomic, weak) id<XMFCommonPopViewDelegate> delegate;

/** ๆ้ฎ็นๅปblock */
@property (nonatomic, copy) void (^commonPopViewBtnsClickBlock)(UIButton *button);


-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
