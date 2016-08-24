//
//  ChoiceHeaderReusableView.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoiceButtonBlock) (void);
@interface ChoiceHeaderReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (copy, nonatomic) ChoiceButtonBlock block;

-(void)choiceButtonBlockAction:(ChoiceButtonBlock)block;
@end
