//
//  WolaoGreetCardViewController.m
//  LaoYiLao
////    NSDictionary * dic  =@{@"message":@"isOK",@"code":@"100",@"resultList":@[
//                            @{@"info": @"139****5581", @"createTime": @"15:26"},
//                            @{@"info": @"139****5582", @"createTime": @"15:21"},
//                            @{@"info": @"139****5583", @"createTime": @"15:27"},
//                            @{@"info": @"139****5582", @"createTime": @"15:22"},
//                            @{@"info": @"139****5584", @"createTime": @"15:28"},
//                            @{@"info": @"139****5587", @"createTime": @"15:23"},
//                            @{@"info": @"139****5585", @"createTime": @"15:29"},
//                            @{@"info": @"139****5588", @"createTime": @"15:24"},
//                            @{@"info": @"139****5586", @"createTime": @"15:20"},
//                            @{@"info": @"139****5589", @"createTime": @"15:25"},]};
//
//
//  Created by sunsu on 15/12/18.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WolaoGreetCardViewController.h"
#import "WolaoCardCell.h"
#import "WolaoCardResultModel.h"
#import "WolaoCardModel.h"
#import "NewNoDumpView.h"
@interface WolaoGreetCardViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate>
{
//    NSDictionary * _receiveData;
    int _page;
    MJRefreshHeaderView * _header;
    MJRefreshFooterView * _footer;
    
    
    NewNoDumpView * _noCardView;
}
@property (nonatomic, strong) NSMutableArray * receveArray;
@property (nonatomic, strong) UICollectionView * WodeCardView;
@property (nonatomic, strong) NSMutableArray * middleMutableArray;

@end

@implementation WolaoGreetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self changeBarTitleWithString:@"我的贺卡"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigation.backgroundColor = RGBACOLOR(192, 21, 31, 1);

    self.receveArray = [NSMutableArray array];
    self.middleMutableArray = [NSMutableArray array];
    
    [self addNoCardView];
    [self addCollectionView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([self.cardNumber isEqualToString:@"0"]) {
//        [self showNoListView];
//    }else{
        [self showLaoHekaList];
        [self requestData];
        [_WodeCardView reloadData];
//    }
}


-(void)addNoCardView{
    _noCardView = [[NewNoDumpView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
    [_noCardView showViewWithType:NoTypeGreetCard];
    _noCardView.hidden = YES;
    [self.view addSubview:_noCardView];
}

-(void)showNoListView{    
    _WodeCardView.hidden = YES;
    _noCardView.hidden = NO;
}

-(void)showLaoHekaList{
    _WodeCardView.hidden = NO;
    _noCardView.hidden = YES;
}


-(void)requestData{
    
    [self showHudInView:self.view hint:@"正在加载"];
    NSString * pageNo = [NSString stringWithFormat:@"%d",_page];
   NSString * str = [LYLHttpTool myGreetingCardWithSize:@"10" page:pageNo];
    [LYLAFNetWorking getWithBaseURL:str success:^(id json) {
        [self hideHud];
        ZHLog(@"wolaoHekaJson==%@",json);
        if ([json[@"code"] isEqualToString:@"100"]) {
            NSArray *arr = json[@"resultList"];
            if (arr.count>0) {
                NSMutableArray * tempMutableArray = [NSMutableArray array];
                for (int i=0; i<arr.count; i++) {
                    WolaoCardResultModel * model = [WolaoCardResultModel getWolaoCardResultModelWithDic:arr[i]];
                    [tempMutableArray addObject:model];
                }
                
                if (_page == 1) {
                    [self.middleMutableArray removeAllObjects];
                }
                [self.middleMutableArray  addObjectsFromArray:tempMutableArray];
                
                self.receveArray = [NSMutableArray arrayWithArray:self.middleMutableArray];
                [self doneWithView:_footer];
                
            }else{
                [self showHint:@"没有更多了"];
                [self doneWithView:_footer];
            }
            
            [_WodeCardView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
    }];

}


#pragma mark MJRefresh
- (void)addRefresh
{
    //    _header = [MJRefreshHeaderView header];
    //    _header.scrollView = _woBaoTableView;
    //    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _WodeCardView;
    _footer.delegate = self;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer){
        _page ++;
    }else {
        _page = 1;
        [self.receveArray removeAllObjects];
    }
    
    [self requestData];
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.5];
}


- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}


#pragma mark -- UI
-(void)addCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    layout.minimumInteritemSpacing = 0;
//    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); 
    CGRect browserViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _WodeCardView = [[UICollectionView alloc] initWithFrame:browserViewFrame collectionViewLayout:layout];
    [_WodeCardView setBackgroundColor:[UIColor whiteColor]];
    
    _WodeCardView.alwaysBounceVertical = YES;
    [_WodeCardView setDelegate:self];
    [_WodeCardView setDataSource:self];
    [self.view addSubview:_WodeCardView];
    _WodeCardView.showsVerticalScrollIndicator = NO;
    
    
    //注册collectionview
    [_WodeCardView registerClass:[WolaoCardCell class] forCellWithReuseIdentifier:@"WodeCardCell"];
    [self addRefresh];
}

#pragma mark CollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    WolaoCardModel * model = [WolaoCardModel getWolaoCardModelWithDic:_receiveData];
//    return model.resultListArray.count;
    return self.receveArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WolaoCardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WodeCardCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[WolaoCardCell alloc] initWithFrame:CGRectMake(0, 0, (kkViewWidth)/2, CustomViewHeight)];
    }
    
//    WolaoCardModel * model = [WolaoCardModel getWolaoCardModelWithDic:_receiveData];
    cell.laoCardModel = self.receveArray[indexPath.row];
    return cell;
}

#define ItemWidth  (kkViewWidth/2)  //318
#define ItemHeight 240/2 *KPercenY

#pragma mark – UICollectionViewDelegateFlowLayout
//cell类
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

        CGSize size = CGSizeMake(ItemWidth,ItemHeight);
        return size;

}


//返回cell，header，footer之间的空白大小  //定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"row==%ld",indexPath.row);
    
    
    
}

//item上下间距为0
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

@end
