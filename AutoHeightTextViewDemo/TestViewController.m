//
//  TestViewController.m
//  AutoHeightTextViewDemo
//
//  Created by 张令林 on 2017/4/18.
//  Copyright © 2017年 personer. All rights reserved.
//

#import "TestViewController.h"
#import "AutoFitHeightCell.h"

static NSString *cellId = @"cellId";
static NSString *autofitHeightCellId = @"autofitHeightCellId";

@interface TestViewController ()<AutoFitHeightCellDelegate>

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerClass:[AutoFitHeightCell class] forCellReuseIdentifier:autofitHeightCellId];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AutoFitHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:autofitHeightCellId forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @"112233445566";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        [self.view endEditing:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (self.cellHeight != 0)
        {
            return self.cellHeight;
        }
        return 45.0f;
    }
    return 50.0f;
}

#pragma mark - AutoFitHeightCellDelegate
-(void)autoFitHeightCell:(AutoFitHeightCell *)cell DidChangedHeight:(CGFloat)height
{
    self.cellHeight = height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
