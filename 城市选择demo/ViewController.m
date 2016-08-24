//
//  ViewController.m
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/15.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "ViewController.h"
#import "ChoiceCityCollectionView.h"
#import "AreaDataModel.h"
#import "UIColor+String.h"
#import "YPPickerArea.h"
#import "ChoiceCityTableView.h"
#import "NSObject+FMDB.h"

// 获取设备屏幕的物理尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<UISearchBarDelegate,YPPickerAreaDelegate>
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;

@property(nonatomic, strong)AreaDataModel *areaModel;//数据源

@property(nonatomic, strong)ChoiceCityTableView *tableView;

@property(nonatomic, strong)ChoiceCityCollectionView *collectionView;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ViewController



#pragma mark ----------------getting----------------

-(AreaDataModel *)areaModel{
    if (_areaModel == nil) {
        _areaModel = [[AreaDataModel alloc]init];
    }
    return _areaModel;
}

-(ChoiceCityCollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
        _collectionView = [[ChoiceCityCollectionView alloc]initWithFrame: CGRectMake(0, 44, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.areaDataModel = self.areaModel;
        __weak ViewController *this = self;
        [_collectionView choiceButtonBlockAction:^{
            [this choiceCityBlockAction];
        }];
        [_collectionView cellSelectedBlockAction:^(NSMutableArray *modelArray) {
            [this cellSelectedBlockAction:modelArray];
        }];
        _collectionView.hotCitys = @[@"10000",@"20100",@"30200",@"40300",@"50400",@"60500",@"60501"];
    }
    return _collectionView;
}

-(ChoiceCityTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[ChoiceCityTableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight)  style:UITableViewStylePlain];
        __weak ViewController *this = self;
        [_tableView cellBlockAction:^(NSMutableArray *modelArray) {
            [this cellSelectedBlockAction:modelArray];
        }];
        _tableView.areaModel = self.areaModel;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    [self.view addSubview:self.collectionView];
    
    [self makeSearchView];
    
//    [self.areaModel clearLocationCity];
}

#pragma mark 创建搜索界面
-(void)makeSearchView{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    //    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"城市名称或首字母";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.searchBar.layer setBorderWidth:0.5f];
    [self.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    [self.view addSubview:self.searchBar];
    
}




#pragma mark ---------------------------------------------block------------------------------------------------
#pragma mark -------------choiceCityBlockAction-------------
-(void)choiceCityBlockAction{
    YPPickerArea *pickerArea = [[YPPickerArea alloc]init];
    [pickerArea setDelegate:self];
    [pickerArea setContentMode:YPPickerContentModeBottom];
    [pickerArea show];
    
}

#pragma mark -------------cellSelectedBlockAction-------------
-(void)cellSelectedBlockAction:(NSMutableArray *)modelArray{
    NSLog(@"%@",modelArray);
    NSString *cityName = [self.areaModel getCityNameWithModelArray:modelArray];
    Province *model = modelArray.lastObject;
    NSString *cityId = model.id;
     NSLog(@"%@",cityName);
     NSLog(@"%@",cityId);
    
}


#pragma mark ---------------------------------------------delegate------------------------------------------
#pragma mark ------------YPPickerAreaDelegate----------------
- (void)pickerArea:(YPPickerArea *)pickerArea modelArray:(NSMutableArray *)choiceModelArray
{
    NSString *title = [self.areaModel getCityNameWithModelArray:choiceModelArray];
    NSLog(@"%@",title);
    //保存到本地ID
    Province *model = [choiceModelArray lastObject];
    NSString *cityId = model.id;
    [self.areaModel saveCityToLocationWithCityID:cityId];
    _collectionView.locationCityArray = nil;
    self.areaModel.commonCitys = nil;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.collectionView reloadSections:set];
}


#pragma mark ----------------searchBarDelegete----------------
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.view addSubview:self.tableView];
    if (searchText.length != 0) {
        BOOL isChinese = [self isChinese:searchText];
        if (isChinese) {
        NSMutableArray *searchArray = [self.areaModel getSearchModelArrayWithTitle:searchText];
        self.tableView.searchCities = searchArray;
        [self.tableView reloadData];

        }else{
            if (searchText.length < 2) {
                return;
            }else{
                NSMutableArray *searchArray = [self.areaModel getSearchModelArrayWithTitle:searchText];
                self.tableView.searchCities = searchArray;
                [self.tableView reloadData];
            }
        }
       
    }else{
        return;
    }
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

//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.tableView removeFromSuperview];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    self.isSearch = NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
