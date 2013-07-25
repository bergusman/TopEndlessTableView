//
//  VBViewController.m
//  TopEndlessTableView
//
//  Created by Vitaly Berg on 25.07.13.
//  Copyright (c) 2013 Vitaly Berg. All rights reserved.
//

#import "VBViewController.h"

#define TOP_OFFSET 1000
#define DELAY 0.3
#define ADDING_ITEMS 80

@interface VBViewController () <
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) BOOL loading;

@end

@implementation VBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    [self addItems];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.items count] - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)addItems {
    for (int i = 0; i < ADDING_ITEMS; i++) {
        NSString *item = [NSString stringWithFormat:@"%d", [self.items count]];
        [self.items insertObject:item atIndex:0];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < TOP_OFFSET && !self.loading) {
        self.loading = YES;
        
        double delayInSeconds = DELAY;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.loading = NO;
            [self addItems];
            
            CGPoint contentOffset = self.tableView.contentOffset;
            CGSize oldContentSize = self.tableView.contentSize;
            
            [self.tableView reloadData];
            
            CGSize newContentSize = self.tableView.contentSize;
            
            contentOffset.y += newContentSize.height - oldContentSize.height;
            self.tableView.contentOffset = contentOffset;
        });
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSString *item = self.items[indexPath.row];
    cell.textLabel.text = item;
    
    return cell;
}

@end
