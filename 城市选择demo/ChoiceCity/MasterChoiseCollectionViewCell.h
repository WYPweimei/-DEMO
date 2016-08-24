//
//  MasterChoiseCollectionViewCell.h
//  ChoiseDemo
//
//  Created by DBC on 16/7/12.
//  Copyright © 2016年 DBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterChoiseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;

@end
