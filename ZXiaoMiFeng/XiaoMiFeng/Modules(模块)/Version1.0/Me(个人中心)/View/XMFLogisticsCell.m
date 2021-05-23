//
//  XMFLogisticsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFLogisticsCell.h"
#import "UILabel+TextAlign.h"
#import "XMFLogisticsModel.h"


//在.m文件中添加
@interface  XMFLogisticsCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;


@property (weak, nonatomic) IBOutlet UILabel *contextLB;



@end


@implementation XMFLogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
   
    
}


-(void)setTracksModel:(XMFLogisticsTracksModel *)tracksModel{
    
    _tracksModel = tracksModel;
    
    self.contextLB.text = tracksModel.context;
    
    [self.contextLB topAlignment];
    
    //2020.05.05 05:37:30
    
    NSArray *timeStrArr = [tracksModel.time componentsSeparatedByString:@" "];
    
    self.timeLB.text = [NSString stringWithFormat:@"%@\n%@",timeStrArr[1],timeStrArr[0]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
