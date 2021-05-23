//
//  XMFLogisticsFirstCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFLogisticsFirstCell.h"
#import "UILabel+TextAlign.h"
#import "XMFLogisticsModel.h"


//在.m文件中添加
@interface  XMFLogisticsFirstCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;


@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;


@property (weak, nonatomic) IBOutlet UILabel *statusLB;


@property (weak, nonatomic) IBOutlet UILabel *contextLB;

@end

@implementation XMFLogisticsFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
   
}


-(void)setLogisticsModel:(XMFLogisticsModel *)logisticsModel{
    
    _logisticsModel = logisticsModel;
    
    if (logisticsModel.tracks.count == 0) {
       
        //YYYY-MM-dd HH:mm:ss
        //HH:mm:ss YYYY-MM-dd
//        self.timeLB.text = [DateUtils getCurrentDateWithFormat:@"HH:mm:ss YYYY-MM-dd"];
        
        //2020.05.05 05:37:30
        
        NSArray *timeStrArr = [[DateUtils getCurrentDateWithFormat:@"YYYY-MM-dd HH:mm:ss"] componentsSeparatedByString:@" "];
        
        self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
        
        
        self.contextLB.text = XMFLI(@"对不起，暂无物流流转信息");
        
//        self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
        
        
    }else{
        
        
        self.contextLB.text = logisticsModel.tracks[0].context;
        
        
        //2020.05.05 05:37:30
        
        NSArray *timeStrArr = [logisticsModel.tracks[0].time componentsSeparatedByString:@" "];
        
        self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
        

        
    }
    
     [self.contextLB topAlignment];
    
    //物流状态（0=未揽收；1=已揽收；2=在途中；3=派件中；4=已签收；8=退回中；9=问题件）
    switch ([logisticsModel.status integerValue]) {
        case 0:{//未揽收
            
            if ([logisticsModel.result isEqualToString:@"0"]) {
                //防止status默认为0
                
                self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
                self.statusLB.text = XMFLI(@"未揽收");
                
            }else{
                
                
                self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
                self.statusLB.text = XMFLI(@"无");
            }

            
        }
            break;
        case 1:{//已揽收
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"已揽收");

        }
            break;
        case 2:{//在途中
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"在途中");
        }
            break;
        case 3:{//派件中
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"在途中");
        }
            break;
        case 4:{//已签收
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_qianshou"];
            
            self.statusLB.text = XMFLI(@"已签收");
            
        }
            break;
        case 8:{//退回中
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"退回中");
            
        }
            break;
        case 9:{//问题件
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"问题件");
        }
            break;
            
            
        default:{
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"无");
        }
            break;
    }
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
