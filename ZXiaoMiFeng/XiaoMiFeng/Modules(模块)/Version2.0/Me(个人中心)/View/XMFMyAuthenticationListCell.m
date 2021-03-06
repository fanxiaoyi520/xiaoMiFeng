//
//  XMFMyAuthenticationListCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/10/21.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFMyAuthenticationListCell.h"
#import "XMFMyAuthenticationListModel.h"


//ε¨.mζδ»ΆδΈ­ζ·»ε 
@interface  XMFMyAuthenticationListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;


@property (weak, nonatomic) IBOutlet UILabel *identityIDLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *statusLB;





@end

@implementation XMFMyAuthenticationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(XMFMyAuthenticationListModel *)model{
    
    _model = model;
    
    self.nameLB.text = model.realName;
    
    self.identityIDLB.text = model.idCardNo;
    
}

@end
