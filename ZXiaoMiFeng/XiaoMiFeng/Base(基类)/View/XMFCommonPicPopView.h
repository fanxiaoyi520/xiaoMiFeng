//
//  XMFCommonPicPopView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2021/1/28.
//  Copyright ยฉ 2021 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCommonPicPopView;

@protocol XMFCommonPicPopViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFCommonPicPopViewDidClick:(XMFCommonPicPopView *)popView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFCommonPicPopView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *tipsImgView;


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (nonatomic, weak) id<XMFCommonPicPopViewDelegate> delegate;

/** ๆ้ฎ็นๅปblock */
@property (nonatomic, copy) void (^popViewBtnsClickBlock)(UIButton *button);

-(void)show;

-(void)hide;


@end

NS_ASSUME_NONNULL_END
