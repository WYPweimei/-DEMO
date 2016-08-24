//
//  AreaDataModel.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/16.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Province;

@interface AreaDataModel : NSObject
//数据源转化成的model数据源
@property (nonatomic, strong)NSMutableArray *modelArray;
/*
 *  常用城市id数组,自动管理，也可赋值(存在本地的城市)
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;

///** 1.数据源数组 */
@property (nonatomic, strong)NSArray *arrayRoot;

///** 当前选择的model */
@property (nonatomic, strong)Province *provinceModel;


//获取检索之后返回的model数组
-(NSMutableArray *)getSearchModelArrayWithTitle:(NSString *)searchText;

//通过城市ID获取城市MODEL数组
-(NSMutableArray *)getHotModelArrayWithHotId:(NSArray *)hotIdArray;

//获取最近访问的城市数组
-(NSMutableArray *)getLocationModelArray;

//保存已经选择过的城市id到本地
-(void)saveCityToLocationWithCityID:(NSString *)theId;

//获取本地存储的城市ID数据
-(NSMutableArray *)getLocationCityIdArray;

//获取本地存储的城市ID对应的数据model数组
-(NSMutableArray *)getLocationCityModelArray;

//根据选择的model数组返回城市名字
-(NSString *)getCityNameWithModelArray:(NSMutableArray *)provinceArray;

//移除本地城市
-(void)clearLocationCity;


#pragma mark  查找Picker数据里面的填充数据
/**
 *  查找Picker数据里面的填充数据
 */
//获取所有的省
-(NSMutableArray *)pickerSearchFirstLineData;

//根据省获取市
-(NSMutableArray *)pickerSearchSecondLineDataWithProvince:(Province *)province;

//根据市获取县
-(NSMutableArray *)pickerSearchThirdLineDataWithProvince:(Province *)province;

@end

/**
 *  省份model
 */
@interface Province : NSObject

@property (nonatomic, assign)NSString *selectedUnitType;//选择的级别
@property (nonatomic, strong) NSString *id;//
@property (nonatomic, strong) NSString *firstId;//一级ID
@property (nonatomic, strong) NSString *secondId;//二级ID
@property (nonatomic, strong) NSString *thirdId;//三级ID
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *initials;// 缩写
@property (nonatomic, strong) NSString *firstChar;// 首字母

@end


@interface readData : NSObject

@property (nonatomic, assign)NSString *city_key;
@property (nonatomic, assign)NSString *city_name;
@property (nonatomic, assign)NSString *initials;
@property (nonatomic, assign)NSString *pinyin;

@end
