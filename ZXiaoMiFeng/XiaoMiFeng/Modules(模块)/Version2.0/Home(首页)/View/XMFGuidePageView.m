//
//  XMFGuidePageView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/1.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGuidePageView.h"

#define XMFHidden_TIME   1.0


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFGuidePageView()

/** å¯å¨å¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *pageImgView;

/** å¯å¨å¾ççé«åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageImgViewHeight;




//è®¡æ¶å¨
@property (nonatomic, strong)NSTimer *timer;

//åè®¡æ¶ç§æ°
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


//èªå®ä¹æ¹æ³
+(instancetype)xibLoadViewWithFrame:(CGRect)frame{
    
    XMFGuidePageView *pageView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGuidePageView class]) owner:nil options:nil] firstObject];
    
    pageView.frame = frame;
    
    return pageView;
    
}


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.downCount = 2;
    
    //åå»ºå®æ¶å¨
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownMethod) userInfo:nil repeats:YES];
    
    
    
}


-(void)setURLStr:(NSString *)URLStr{
    
    _URLStr = URLStr;
    
    
    if (![URLStr nullToString]) {
        
        
        //è·åå¾çå°ºå¯¸
        CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:URLStr]];
        
        if (banerImgSize.width > 0) {
            
            //é²æ­¢åæ¯ä¸º0
            self.pageImgViewHeight.constant = KScreenW * banerImgSize.height/banerImgSize.width;
        }

    
        [self.pageImgView sd_setImageWithURL:[NSURL URLWithString:URLStr]];


    }else{
        

        [self.pageImgView sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:@"icon_qidongye_bg"]];
    }
    
    
}

/**

Â *Â  æ ¹æ®å¾çåæ¼æ¥æä»¶è·¯å¾

Â */

- (NSString*)getFilePathWithImageName:(NSString*)imageName {
 
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}



#pragma mark - âââââââ åè®¡æ¶æ¹æ³ ââââââââ
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
