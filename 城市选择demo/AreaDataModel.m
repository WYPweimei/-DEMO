//
//  AreaDataModel.m
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/16.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "AreaDataModel.h"
#import "YYModel.h"
#import "NSObject+FMDB.h"

#define     COMMON_CITY_DATA_KEY        @"WYPCommonCityArray"
@interface AreaDataModel()

///** 1.数据源数组 */
@property (nonatomic, strong)NSArray *readArrayRoot;
@property (nonatomic, strong)NSMutableArray *allDataArray;

@end
@implementation AreaDataModel

#pragma mark - --- getters 属性 , setters 属性 ---
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}


- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self readPlistData];
//        [self makeDBlist];
    }
    return self;
}

//返回代表全部的数据model
-(Province *)returnAllStyleModel{
    NSMutableDictionary *allDic = [NSMutableDictionary new];
    [allDic setObject:@"#" forKey:@"selectedUnitType"];
    [allDic setObject:@"#" forKey:@"id"];
    [allDic setObject:@"#" forKey:@"firstId"];
    [allDic setObject:@"#" forKey:@"secondId"];
    [allDic setObject:@"#" forKey:@"thirdId"];
    [allDic setObject:@"全部" forKey:@"name"];
    [allDic setObject:@"#" forKey:@"pinyin"];
    [allDic setObject:@"#" forKey:@"initials"];
    [allDic setObject:@"#" forKey:@"firstChar"];
    return [Province yy_modelWithDictionary:allDic];
}

/**/
/**
 *  生成本地的sql数据库
 */
- (void)makeDBlist
{
//    NSString *sqlString = @"SELECT * FROM DbcCity";
//    [Province queryWithSql:sqlString block:^(NSArray *list) {
//        NSLog(@"%@",list);
//        NSLog(@"%ld",list.count);
//    }];
//    [Province dropTable];
    [Province createWithKey:@[@"id"] owner:NO];
    NSMutableArray *dataArray = [NSMutableArray new];
    NSInteger lineCount = 0;
    //创建一个dic，写到plist文件里
    // 1.获取数据
    for (int i = 0; i < self.arrayRoot.count; i ++) {
        lineCount ++;
        NSMutableDictionary *provinces = [NSMutableDictionary new];
        NSDictionary *obj = self.arrayRoot[i];
        NSString *nameString = obj[@"state"];
        NSString *provincesIdString = [NSString stringWithFormat:@"%d",10000 + i];
        for (readData *model in self.allDataArray) {
            NSString *cityName = model.city_name;
            if ([cityName containsString:@"市"]) {
                NSRange range = [cityName rangeOfString:@"市"];
                cityName = [cityName substringToIndex:range.location];
                
            }
            if ([cityName containsString:@"地区"]) {
                NSRange range = [cityName rangeOfString:@"地区"];
                cityName = [cityName substringToIndex:range.location];
                
            }
            if ([cityName containsString:@"自治州"]) {
                NSRange range = [cityName rangeOfString:@"自治州"];
                cityName = [cityName substringToIndex:range.location];
                
            }
            if ([nameString containsString:cityName]) {
                provincesIdString = model.city_key;
            }
        }
        [provinces setObject:obj[@"state"] forKey:@"name"];
        [provinces setObject:provincesIdString forKey:@"firstId"];
        [provinces setObject:provincesIdString forKey:@"id"];
        [provinces setObject:@"" forKey:@"secondId"];
        [provinces setObject:@"" forKey:@"thirdId"];
        [provinces setObject:@"0" forKey:@"selectedUnitType"];
        [provinces setObject:[self transform:obj[@"state"]] forKey:@"pinyin"];
        NSString *provinceName = obj[@"state"];
        NSMutableString *suoxie = [NSMutableString string];
        for (int p = 0; p < provinceName.length; p++) {
            NSString *seprate = [provinceName substringWithRange:NSMakeRange(p, 1)];
            NSString *sepratePY = [self transform:seprate];
            NSString *sx = [sepratePY substringToIndex:1];
            [suoxie appendString:sx];
        }
        [provinces setObject:suoxie forKey:@"initials"];
        [provinces setObject:[suoxie substringToIndex:1] forKey:@"firstChar"];
        Province *model = [[Province alloc]initContentWithDic:provinces];
        [model insertOrUpdateValue:model.id forKey:@"id" owner:nil];
        NSArray *citysArray = obj[@"cities"];
        NSMutableArray *townArray = [NSMutableArray new];
        for (int j = 0; j < citysArray.count; j ++ ) {
            lineCount ++;
            NSDictionary *townDic = citysArray[j];
            NSMutableDictionary *theTownDic = [NSMutableDictionary new];
            NSString *cityNameString = townDic[@"city"] ;
            NSString *townIdString = [NSString stringWithFormat:@"%d",10000 * (i + 1) + (j + 1) * 100];
            for (readData *model in self.allDataArray) {
                NSString *cityName = model.city_name;
                if ([cityName containsString:@"市"]) {
                    NSRange range = [cityName rangeOfString:@"市"];
                    cityName = [cityName substringToIndex:range.location];
                    
                }
                if ([cityName containsString:@"地区"]) {
                    NSRange range = [cityName rangeOfString:@"地区"];
                    cityName = [cityName substringToIndex:range.location];
                    
                }
                if ([cityName containsString:@"自治州"]) {
                    NSRange range = [cityName rangeOfString:@"自治州"];
                    cityName = [cityName substringToIndex:range.location];
                    
                }
                if ([cityNameString containsString:cityName]) {
                    townIdString = model.city_key;
                }
            }
            [theTownDic setObject:provincesIdString forKey:@"firstId"];
            [theTownDic setObject:townIdString forKey:@"secondId"];
            [theTownDic setObject:townIdString forKey:@"id"];
            [theTownDic setObject:@"" forKey:@"thirdId"];
            [theTownDic setObject:@"1" forKey:@"selectedUnitType"];
            [theTownDic setValue:townDic[@"city"] forKey:@"name"];
            [theTownDic setValue:[self transform:townDic[@"city"]] forKey:@"pinyin"];
            NSString *townName = townDic[@"city"];
            NSMutableString *suoxie = [NSMutableString string];
            for (int p = 0; p < townName.length; p++) {
                NSString *seprate = [townName substringWithRange:NSMakeRange(p, 1)];
                NSString *sepratePY = [self transform:seprate];
                NSString *sx = [sepratePY substringToIndex:1];
                [suoxie appendString:sx];
            }
            NSString *firstChar = [[self transform:townDic[@"city"]] substringToIndex:1];
            [theTownDic setValue:suoxie forKey:@"initials"];
            [theTownDic setValue:firstChar forKey:@"firstChar"];
            NSArray *citysArray = townDic[@"areas"];
            Province *model = [[Province alloc]initContentWithDic:theTownDic];
            [model insertOrUpdateValue:model.id forKey:@"id" owner:nil];
            NSMutableArray *areaArray = [NSMutableArray new];
            for (int h = 0; h < citysArray.count; h ++) {
                lineCount ++;
                NSMutableDictionary *areaDic = [NSMutableDictionary new];
                NSString *areaIdString = [NSString stringWithFormat:@"%d",10000 * (i + 1) + (j + 1) * 100 + h + 1];
                [areaDic setObject:provincesIdString forKey:@"firstId"];
                [areaDic setObject:townIdString forKey:@"secondId"];
                [areaDic setObject:areaIdString forKey:@"thirdId"];
                [areaDic setObject:areaIdString forKey:@"id"];
                [areaDic setObject:@"2" forKey:@"selectedUnitType"];
                [areaDic setValue:citysArray[h] forKey:@"name"];
                [areaDic setValue:[self transform:citysArray[h]] forKey:@"pinyin"];
                NSString *areaName = citysArray[h];
                NSMutableString *suoxie = [NSMutableString string];
                for (int p = 0; p < areaName.length; p++) {
                    NSString *seprate = [areaName substringWithRange:NSMakeRange(p, 1)];
                    NSString *sepratePY = [self transform:seprate];
                    NSString *sx = [sepratePY substringToIndex:1];
                    [suoxie appendString:sx];
                }
                [areaDic setValue:suoxie forKey:@"initials"];
                [areaDic setValue:[[self transform:citysArray[h]] substringToIndex:1] forKey:@"firstChar"];
                Province *model = [[Province alloc]initContentWithDic:areaDic];
                [model insertOrUpdateValue:model.id forKey:@"id" owner:nil];
                [areaArray addObject:areaDic];
            }
            [theTownDic setValue:areaArray forKey:@"areas"];
            [townArray addObject:theTownDic];
        }
        [provinces setObject:townArray forKey:@"townArray"];
        [dataArray addObject:provinces];
    }
    
    
    // 写入plist文件
    
    //    NSLog(@"%@",dataArray);
    //    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *path = [pathArray objectAtIndex:0];
    //    //获取文件的完整路径
    //    NSString *filePatch = [path stringByAppendingPathComponent:@"area1.plist"];
    //    NSLog(@"%@",filePatch);
    //    [dataArray writeToFile:filePatch atomically:YES];
}

-(void)readPlistData{
    _allDataArray = [NSMutableArray new];
    for (int i = 0; i < self.readArrayRoot.count; i ++) {
        NSDictionary *cityDic = self.readArrayRoot[i];
        for (NSDictionary *theDic in cityDic[@"citys"]) {
            readData *model = [[readData alloc]initContentWithDic:theDic];
            [_allDataArray addObject:model];
        }
    }
    
}

#pragma mark -----------------//中文转拼音------------------
- (NSString *)transformToPinyin:(NSString *)str
{
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [pinyinString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (NSString *)transform:(NSString *)chinese
{
    if (chinese.length == 0 || chinese == nil) {
        return @"#";
    }
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    if ([pinyin containsString:@" "]) {
        NSString *str = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
        pinyin = [NSMutableString stringWithFormat:@"%@",str];
    }
    return [pinyin uppercaseString];
}

//判断是中文还是汉字
-(BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//获取检索之后返回的model数组
-(NSMutableArray *)getSearchModelArrayWithTitle:(NSString *)searchText{
    NSMutableArray *choiceIDArray = [NSMutableArray new];
    BOOL isChinese = [self isChinese:searchText];
    NSString *sql;
    if (isChinese) {
         sql = [NSString stringWithFormat:@"SELECT * FROM %@ where name like '%%%@%%'", [Province tableName], searchText];
    }else{
         sql = [NSString stringWithFormat:@"SELECT * FROM %@ where initials like '%%%@%%' or pinyin like '%%%@%%'", [Province tableName], searchText, searchText];
    }
    [Province queryWithSql:sql responseModelBlock:^(NSArray *list) {
        for (Province *model in list) {
            [choiceIDArray addObject:model.id];
        }
    }];
    NSSet *citySet = [NSSet setWithArray:choiceIDArray];
    NSMutableArray *cityIDArray = [[NSMutableArray alloc]initWithArray:[citySet allObjects]];
    return [self getHotModelArrayWithHotId:cityIDArray];
}

//获取热门城市数组
-(NSMutableArray *)getHotModelArrayWithHotId:(NSArray *)hotIdArray{
    NSMutableArray *hotCityArray = [NSMutableArray new];
    for (NSString *hotId in hotIdArray) {
        NSMutableArray *userArray = [NSMutableArray new];
        NSMutableArray *smallArray = [NSMutableArray new];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:hotId forKey:@"id"];
        [Province queryWithParams:dic block:^(NSArray *list) {
            for (Province *model in list) {
                [smallArray addObject:model];
            }
        }];
        if (smallArray.count == 0) {
            continue;
        }else{
            Province *userModel = smallArray[0];
            if (userModel.firstId) {
                NSMutableDictionary *firstDic = [NSMutableDictionary new];
                [firstDic setValue:userModel.firstId forKey:@"id"];
                [Province queryWithParams:firstDic block:^(NSArray *list) {
                    for (Province *model in list) {
                        [userArray addObject:model];
                    }
                }];
            }
            if (userModel.secondId) {
                NSMutableDictionary *secondDic = [NSMutableDictionary new];
                [secondDic setValue:userModel.secondId forKey:@"id"];
                [Province queryWithParams:secondDic block:^(NSArray *list) {
                    for (Province *model in list) {
                        [userArray addObject:model];
                    }
                }];
            }
            if (userModel.thirdId) {
                NSMutableDictionary *thirdDic = [NSMutableDictionary new];
                [thirdDic setValue:userModel.thirdId forKey:@"id"];
                [Province queryWithParams:thirdDic block:^(NSArray *list) {
                    for (Province *model in list) {
                        [userArray addObject:model];
                    }
                }];
            }
            [hotCityArray addObject:userArray];
        }

    }
    return hotCityArray;
}

//获取最近访问的城市数组
-(NSMutableArray *)getLocationModelArray{
     NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
    return [self getHotModelArrayWithHotId:array];
}

//保存选择过的城市ID
-(void)saveCityToLocationWithCityID:(NSString *)theId{
    NSMutableArray *array = [NSMutableArray new];
     [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY]];
    if ([array containsObject:theId]) {
        
    }else{
        if (array.count >= YPLoactionBiggestNumber) {
            [array removeObjectAtIndex:array.count - 1];
        }
        [array insertObject:theId atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:array forKey:COMMON_CITY_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//根据选择的model返回城市名字
-(NSString *)getCityNameWithModelArray:(NSMutableArray *)provinceArray{
    NSMutableString *cityName = [NSMutableString new];
    if (provinceArray.count == 1) {
        Province *model = provinceArray[0];
        [cityName appendFormat:@"%@",model.name];
    }else if(provinceArray.count == 2){
        Province *model1 = provinceArray[0];
        Province *model2 = provinceArray[1];
         [cityName appendFormat:@"%@  %@",model1.name,model2.name];
    }else if(provinceArray.count == 3){
        Province *model1 = provinceArray[0];
        Province *model2 = provinceArray[1];
        Province *model3 = provinceArray[2];
        [cityName appendFormat:@"%@  %@  %@",model1.name,model2.name,model3.name];
    }else{
        cityName = [NSMutableString stringWithFormat:@""];
    }
    return cityName;
}

//获取本地存储的城市ID数据
-(NSMutableArray *)getLocationCityIdArray{
    return self.commonCitys;
}

//获取本地存储的城市ID对应的数据model数组
-(NSMutableArray *)getLocationCityModelArray{
    NSMutableArray *modelArray = [self getHotModelArrayWithHotId:self.commonCitys];
    return modelArray;
}


//移除本地城市
-(void)clearLocationCity{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:COMMON_CITY_DATA_KEY];
}


/**
 *  查找Picker数据里面的填充数据
 */
//获取所有的省
-(NSMutableArray *)pickerSearchFirstLineData{
    NSMutableArray *choiceCityArray = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where selectedUnitType = '0'", [Province tableName]];
    [Province queryWithSql:sql responseModelBlock:^(NSArray *list) {
        [choiceCityArray addObjectsFromArray:list];
    }];
    return choiceCityArray;
}

//根据省获取市
-(NSMutableArray *)pickerSearchSecondLineDataWithProvince:(Province *)province{
    NSString *firstId = province.id;
    NSMutableArray *choiceCityArray = [NSMutableArray new];
    [choiceCityArray addObject:[self returnAllStyleModel]];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where selectedUnitType = '1' and firstId = '%@' and id <> '%@'",[Province tableName],firstId,firstId];
    [Province queryWithSql:sql responseModelBlock:^(NSArray *list) {
        [choiceCityArray addObjectsFromArray:list];
    }];
    return choiceCityArray;
}
//根据市获取县
-(NSMutableArray *)pickerSearchThirdLineDataWithProvince:(Province *)province{
    NSString *secondId = province.id;
    NSMutableArray *choiceAreaArray = [NSMutableArray new];
    [choiceAreaArray addObject:[self returnAllStyleModel]];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where selectedUnitType = '2' and secondId = '%@' and id <> '%@'", [Province tableName], secondId , secondId];
    [Province queryWithSql:sql responseModelBlock:^(NSArray *list) {
        [choiceAreaArray addObjectsFromArray:list];
    }];
    return choiceAreaArray;
}

- (NSArray *)readArrayRoot
{
    if (!_readArrayRoot) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"CityData" ofType:@"plist"];
        _readArrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _readArrayRoot;
}

@end



@implementation Province


// 表名
+(NSString *)tableName{
    return @"DbcCity";
}


@end


@implementation readData


@end
