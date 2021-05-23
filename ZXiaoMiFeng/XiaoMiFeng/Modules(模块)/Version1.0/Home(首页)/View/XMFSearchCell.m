//
//  XMFSearchCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchCell.h"

@implementation XMFSearchCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.wordLabel];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    [_wordLabel cornerWithRadius:_wordLabel.height/2.0];
    
    _wordLabel.cornerRadius = 15;

    
}



- (KKPaddingLabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[KKPaddingLabel alloc]initWithFrame:CGRectZero];
        _wordLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
        _wordLabel.textColor = UIColorFromRGB(0x666666);
        _wordLabel.font                = [UIFont fontWithName:@"PingFang-SC-Medium" size:13.f];
//        _wordLabel.layer.cornerRadius  = 10;
//        _wordLabel.layer.masksToBounds = YES;
        _wordLabel.textAlignment       = NSTextAlignmentCenter;
        _wordLabel.numberOfLines = 0;
        _wordLabel.left_padding = 5;
        _wordLabel.right_padding = 5;
    }
    return _wordLabel;
}

- (void)setSearchStr:(NSString *)searchStr{
    _searchStr = searchStr;
    _wordLabel.text = _searchStr;
    CGSize size = [_searchStr boundingRectWithSize:CGSizeMake(KScreenWidth - 40, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.f]} context:nil].size;
//    _wordLabel.frame = CGRectMake(10, 10, size.width+30, 30);
    _wordLabel.frame = CGRectMake(10, 10, size.width + 20, size.height + 20);
}

- (CGSize)sizeForCell {
    
    CGFloat cellWidth;
    
    if ((_wordLabel.frame.size.width + 20) > (KScreenWidth - 10)) {
        
        cellWidth = KScreenWidth - 10;
        
    }else{
        
        cellWidth = _wordLabel.frame.size.width + 20;
    }
    
    return CGSizeMake(cellWidth, _wordLabel.frame.size.height + 10);
}

@end
