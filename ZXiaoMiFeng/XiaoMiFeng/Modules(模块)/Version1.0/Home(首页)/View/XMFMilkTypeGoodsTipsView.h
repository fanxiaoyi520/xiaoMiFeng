//
//  XMFMilkTypeGoodsTipsView.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/5/29.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMilkTypeGoodsTipsView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

//ζθΏ°Txw
@property (weak, nonatomic) IBOutlet UITextView *descTxw;


-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
