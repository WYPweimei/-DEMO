//
//  ChoiceCityTableView.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaDataModel.h"

typedef void(^CellSelectedBlock) (NSMutableArray *modelArray);

@interface ChoiceCityTableView : UITableView

@property(nonatomic, strong)AreaDataModel *areaModel;//数据源

@property(nonatomic, copy)CellSelectedBlock block;
/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;


-(void)cellBlockAction:(CellSelectedBlock)block;

@end
