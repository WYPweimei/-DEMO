//
//  ChoiceCityCollectionView.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaDataModel;

#define     MAX_COMMON_CITY_NUMBER      8
typedef void(^ChoiceButtonBlock) (void);
typedef void(^CellSelectedBlock) (NSMutableArray *modelArray);
@interface ChoiceCityCollectionView : UICollectionView
/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;

@property(nonatomic, strong)AreaDataModel *areaDataModel;

/*
 *  热门城市id数组
 */
@property (nonatomic, strong) NSArray *hotCitys;

@property(nonatomic, strong)NSMutableArray *locationCityArray;

@property (copy, nonatomic) ChoiceButtonBlock block;

@property (copy, nonatomic) CellSelectedBlock cellBlock;

-(void)choiceButtonBlockAction:(ChoiceButtonBlock)block;

-(void)cellSelectedBlockAction:(CellSelectedBlock)block;


@end
