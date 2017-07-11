//
//  ViewController.m
//  TaipeiPark
//
//  Created by Vivi on 11/07/2017.
//  Copyright © 2017 Vivi. All rights reserved.
//

#import "ViewController.h"
#import "TaipeiParkTableViewCell.h"
#import "AFHTTPSessionManager.h"
#import "AttractionData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

#define LOADING_CELL_PLACEHOLDER @"LOADING"
#define LOADING_CELL_HEIGHT 44.0

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL isGettingAPIData;
    NSInteger maxDataCount;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (strong, nonatomic) NSMutableArray *arrayOfCellHeights;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isGettingAPIData = NO;
    maxDataCount = -1;
    self.dataSourceArray = [NSMutableArray array];
    self.arrayOfCellHeights = [NSMutableArray array];
    
    [self setupView];
    [self getAPIData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView related

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.dataSourceArray.count) {
        return nil;
    }
    
    id data = self.dataSourceArray[indexPath.row];
    
    if ([data isKindOfClass:[NSString class]]) {
        // Loading cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0, LOADING_CELL_HEIGHT / 2.0);
            [spinner startAnimating];
            [cell.contentView addSubview:spinner];
        }
        
        if ([cell.contentView.subviews.lastObject isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)cell.contentView.subviews.lastObject startAnimating];
        }

        return cell;
        
    } else {
        // Regular cell
        
        TaipeiParkTableViewCell *cell = (TaipeiParkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[TaipeiParkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" cellWidth:CGRectGetWidth(self.view.frame)];
        }
        
        cell.tag = indexPath.row;
        
        AttractionData *attractionData = (AttractionData *)data;
        cell.nameLabel.text = attractionData.name;
        cell.parkNameLabel.text = attractionData.parkName;
        [cell setIntroductionLabelText:attractionData.introduction];
        
        if (attractionData.imageName) {
            [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:attractionData.imageName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (cell.tag == indexPath.row) {
                    [UIView transitionWithView:cell.thumbImageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        cell.thumbImageView.image = image;
                    } completion:^(BOOL finished) {
                    }];
                }
            }];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.arrayOfCellHeights.count) {
        return [self.arrayOfCellHeights[indexPath.row] floatValue];
    }
    
    return LOADING_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSourceArray.count - 10 && maxDataCount > 0 && self.dataSourceArray.count < maxDataCount) {
        [self getAPIData];
    }
}

#pragma mark - private methods

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat x, y, w, h;
    
    // Title label
    x = 0;
    y = 20;
    w = CGRectGetWidth(self.view.frame);
    h = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"台北市公園景點們";
    [self.view addSubview:titleLabel];
    
    // Separator
    x = 20;
    y = CGRectGetMaxY(titleLabel.frame);
    w = CGRectGetWidth(self.view.frame) - x * 2;
    h = 0.5;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    // Tableview
    x = 0;
    y = CGRectGetMaxY(line.frame);
    w = CGRectGetWidth(self.view.frame);
    h = CGRectGetHeight(self.view.frame) - y;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    [self.view addSubview:self.tableView];
}

- (void)getAPIData {
    
    if (isGettingAPIData || (maxDataCount >= 0 && self.dataSourceArray.count >= maxDataCount)) {
        return;
    }
    
    isGettingAPIData = YES;
    
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    
    NSInteger offset = self.arrayOfCellHeights.count;
    NSString *url = [NSString stringWithFormat:@"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812&limit=30&offset=%ld", (long)offset];
    
    if (offset == 0) {
        // First page, show hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"資料讀取中...";
    }
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
//        NSLog(@"API succeeded, responseObject: %@", responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]] &&
            [responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
            
            if ([responseObject[@"result"][@"count"] isKindOfClass:[NSNumber class]]) {
                maxDataCount = [responseObject[@"result"][@"count"] integerValue];
            }
            
            if ([responseObject[@"result"][@"results"] isKindOfClass:[NSArray class]]) {
                
                if ([self.dataSourceArray.lastObject isKindOfClass:[NSString class]]) {
                    // Remove the placeholder text for loading cell
                    [self.dataSourceArray removeObject:self.dataSourceArray.lastObject];
                }
                
                for (NSDictionary *dict in responseObject[@"result"][@"results"]) {
                    if (![dict isKindOfClass:[NSDictionary class]]) {
                        continue;
                    }
                    
                    AttractionData *attractionData = [[AttractionData alloc] initWithName:dict[@"Name"] parkName:dict[@"ParkName"] introduction:dict[@"Introduction"] imageName:dict[@"Image"]];
                    
                    [self.dataSourceArray addObject:attractionData];
                    
                }
                
                [self calculateCellHeights];
                
                if (self.dataSourceArray.count < maxDataCount) {
                    // Add placeholder text for loading cell
                    [self.dataSourceArray addObject:LOADING_CELL_PLACEHOLDER];
                }
            }
        }
        
//        NSLog(@"self.arrayOfCellHeights.count: %d", self.arrayOfCellHeights.count);
//        NSLog(@"self.dataSourceArray.count: %d", self.dataSourceArray.count);
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        isGettingAPIData = NO;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"API failed, error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"😣\n無法取得資料，請稍後再試。";
        hud.label.numberOfLines = 0;
        hud.mode = MBProgressHUDModeText;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        isGettingAPIData = NO;
    }];
}

- (void)calculateCellHeights {
    
    static dispatch_once_t onceToken;
    static TaipeiParkTableViewCell *cell;

    dispatch_once(&onceToken, ^{
        cell = [[TaipeiParkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FakeCell" cellWidth:CGRectGetWidth(self.tableView.frame)];
    });
    
    for (NSInteger i = self.arrayOfCellHeights.count; i < self.dataSourceArray.count; i++) {
        AttractionData *attraction = self.dataSourceArray[i];
        [cell setIntroductionLabelText:attraction.introduction];
        [self.arrayOfCellHeights addObject:@(CGRectGetMaxY(cell.introductionLabel.frame) + 20)];
    }    
}

@end
