//
//  ChoiceHeaderReusableView.m
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "ChoiceHeaderReusableView.h"

@implementation ChoiceHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)choiceCityAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

-(void)choiceButtonBlockAction:(ChoiceButtonBlock)block{
    if (block) {
        self.block = block;
    }
}
@end
