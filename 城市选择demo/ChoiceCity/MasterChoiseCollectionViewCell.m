//
//  MasterChoiseCollectionViewCell.m
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import "MasterChoiseCollectionViewCell.h"
#import "UIColor+String.h"

@implementation MasterChoiseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithString:@"#dddddd"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5.0;
    self.selectedView.hidden = YES;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.textColor = [UIColor colorWithString:@"#333333"];
    }
//    self.selectedView.hidden = !isSelected;
}

@end

