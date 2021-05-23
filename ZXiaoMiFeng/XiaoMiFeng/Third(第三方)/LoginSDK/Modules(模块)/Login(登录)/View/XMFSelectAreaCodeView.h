//
//  XMFSelectAreaCodeView.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/8.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFAreaCodeModel;

@interface XMFSelectAreaCodeView : UIView


-(void)show;

-(void)hide;

@property (nonatomic, strong) NSArray<XMFAreaCodeModel *> *areaArr;

@property (nonatomic, copy) void (^selectedAreaBlock)(XMFAreaCodeModel *areaModel);

//view显示与否
@property (nonatomic, copy) void (^areaViewStatus)(BOOL isShow);


@end

NS_ASSUME_NONNULL_END
