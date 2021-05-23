//
//  XMFGuidePageView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGuidePageView.h"

#define XMFHidden_TIME   1.0


//在.m文件中添加
@interface  XMFGuidePageView()

/** 启动图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pageImgView;

/** 启动图片的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageImgViewHeight;




//计时器
@property (nonatomic, strong)NSTimer *timer;

//倒计时秒数
@property (nonatomic, assign)NSInteger downCount;


@end

@implementation XMFGuidePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//自定义方法
+(instancetype)xibLoadViewWithFrame:(CGRect)frame{
    
    XMFGuidePageView *pageView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGuidePageView class]) owner:nil options:nil] firstObject];
    
    pageView.frame = frame;
    
    return pageView;
    
}


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.downCount = 2;
    
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownMethod) userInfo:nil repeats:YES];
    
    
    
}


-(void)setURLStr:(NSString *)URLStr{
    
    _URLStr = URLStr;
    
    
    if (![URLStr nullToString]) {
        
        
        //获取图片尺寸
        CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:URLStr]];
        
        if (banerImgSize.width > 0) {
            
            //防止分母为0
            self.pageImgViewHeight.constant = KScreenW * banerImgSize.height/banerImgSize.width;
        }

    
        [self.pageImgView sd_setImageWithURL:[NSURL URLWithString:URLStr]];


    }else{
        

        [self.pageImgView sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:@"icon_qidongye_bg"]];
    }
    
    
}

/**

 *  根据图片名拼接文件路径

 */

- (NSString*)getFilePathWithImageName:(NSString*)imageName {
 
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}



#pragma mark - ——————— 倒计时方法 ————————
-(void)countDownMethod{
    
    _downCount--;
    
    if (_downCount <= 0) {
        
        [UIView animateWithDuration:XMFHidden_TIME animations:^{
            self.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(XMFHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self removeFromSuperview];
                
            });
        }];
        
        [_timer invalidate];
        
    }
    
}

@end
