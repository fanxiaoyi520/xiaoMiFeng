//
//  XMFOrdersLogisticsFirstCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersLogisticsFirstCell.h"
#import "UILabel+TextAlign.h"
#import "XMFOrdersLogisticsModel.h"
#import "DashLineView.h"//竖虚线view


//在.m文件中添加
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
    
    //竖向的虚线
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
            
            
            self.contextLB.text = XMFLI(@"对不起，暂无物流信息");
            
    //        self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            
            
        }else{
            
            
            self.contextLB.text = logisticsModel.tracks[0].context;
            
            
            //2020.05.05 05:37:30
            
            NSArray *timeStrArr = [logisticsModel.tracks[0].time componentsSeparatedByString:@" "];
            
            self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
            

            
        }
        
         [self.contextLB topAlignment];
    
    //物流状态（0=未揽收；1=已揽收；2=运输中；3=派件中；4=已签收；11：清关中，81：退回件，91：问题件）
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
        case 2:{//运输中
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"运输中");
        }
            break;
        case 3:{//派件中
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"派件中");
        }
            break;
        case 4:{//已签收
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_qianshou"];
            
            self.statusLB.text = XMFLI(@"已签收");
            
        }
            break;
        case 11:{//清关中
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"清关中");
            
        }
            break;
        case 81:{//退回件
            
            self.statusImgView.image = [UIImage imageNamed:@"icon_wuliu_ye"];
            self.statusLB.text = XMFLI(@"退回件");
        }
            break;
            
        case 91:{//问题件
            
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
