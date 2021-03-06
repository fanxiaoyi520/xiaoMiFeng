//
//  XMFOrdersLogisticsFirstCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/11.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrdersLogisticsFirstCell.h"
#import "UILabel+TextAlign.h"
#import "XMFOrdersLogisticsModel.h"
#import "DashLineView.h"//ç«èçº¿view


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFOrdersLogisticsFirstCell()


@property (weak, nonatomic) IBOutlet UIView *lineBgView;


@property (weak, nonatomic) IBOutlet UILabel *addressLB;


@property (weak, nonatomic) IBOutlet UILabel *timeLB;


@property (weak, nonatomic) IBOutlet UILabel *statusLB;


@property (weak, nonatomic) IBOutlet UILabel *contextLB;


@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;




@end

@implementation XMFOrdersLogisticsFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //ç«åçèçº¿
    DashLineView *verticalDashLine = [[DashLineView alloc] initWithFrame:CGRectMake(10, 0, 1, 25) withLineLength:3 withLineSpacing:3 withLineColor:UIColorFromRGB(0xD8D8D8)];
    
    [self.lineBgView addSubview:verticalDashLine];
    
}


-(void)setLogisticsModel:(XMFOrdersLogisticsModel *)logisticsModel{
    
    _logisticsModel = logisticsModel;
    
    self.addressLB.text = logisticsModel.address;
    
//    [self.addressLB topAlignment];
    
     if (logisticsModel.tracks.count == 0) {
           
            //YYYY-MM-dd HH:mm:ss
            //HH:mm:ss YYYY-MM-dd
    //        self.timeLB.text = [DateUtils getCurrentDateWithFormat:@"HH:mm:ss YYYY-MM-dd"];
            
            //2020.05.05 05:37:30
            
            NSArray *timeStrArr = [[DateUtils getCurrentDateWithFormat:@"YYYY-MM-dd HH:mm:ss"] componentsSeparatedByString:@" "];
            
            self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
            
            
            self.contextLB.text = XMFLI(@"å¯¹ä¸èµ·ï¼ææ ç©æµä¿¡æ¯");
            
    //        self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            
            
        }else{
            
            
            self.contextLB.text = logisticsModel.tracks[0].context;
            
            
            //2020.05.05 05:37:30
            
            NSArray *timeStrArr = [logisticsModel.tracks[0].time componentsSeparatedByString:@" "];
            
            self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
            

            
        }
        
         [self.contextLB topAlignment];
    
    //ç©æµç¶æï¼0=æªæ½æ¶ï¼1=å·²æ½æ¶ï¼2=è¿è¾ä¸­ï¼3=æ´¾ä»¶ä¸­ï¼4=å·²ç­¾æ¶ï¼11ï¼æ¸å³ä¸­ï¼81ï¼éåä»¶ï¼91ï¼é®é¢ä»¶ï¼
    switch ([logisticsModel.status integerValue]) {
        case 0:{//æªæ½æ¶
            
            if ([logisticsModel.result isEqualToString:@"0"]) {
                //é²æ­¢statusé»è®¤ä¸º0
                
                self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
                self.statusLB.text = XMFLI(@"æªæ½æ¶");
                
            }else{
                
                
                self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
                self.statusLB.text = XMFLI(@"æ ");
            }
            
            
        }
            break;
        case 1:{//å·²æ½æ¶
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"å·²æ½æ¶");
            
        }
            break;
        case 2:{//è¿è¾ä¸­
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"è¿è¾ä¸­");
        }
            break;
        case 3:{//æ´¾ä»¶ä¸­
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"æ´¾ä»¶ä¸­");
        }
            break;
        case 4:{//å·²ç­¾æ¶
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_qianshou"];
            
            self.statusLB.text = XMFLI(@"å·²ç­¾æ¶");
            
        }
            break;
        case 11:{//æ¸å³ä¸­
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"æ¸å³ä¸­");
            
        }
            break;
        case 81:{//éåä»¶
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"éåä»¶");
        }
            break;
            
        case 91:{//é®é¢ä»¶
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"é®é¢ä»¶");
        }
            break;
            
            
        default:{
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"æ ");
        }
            break;
    }
          
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
