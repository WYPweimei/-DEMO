//
//  YPPickerView.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/23.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class YPPickerArea;
@class AreaDataModel;
@class Province;
@class Town;
@class Areas;

@protocol  YPPickerAreaDelegate<NSObject>

- (void)pickerArea:(YPPickerArea *)pickerArea modelArray:(NSMutableArray *)choiceModelArray;

@end
@interface YPPickerArea : YPPickerView
/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <YPPickerAreaDelegate>delegate ;
@end
NS_ASSUME_NONNULL_END