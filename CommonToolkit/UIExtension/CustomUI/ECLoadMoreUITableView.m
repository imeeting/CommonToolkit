//
//  ECLoadMoreUITableView.m
//  ectoolkit
//
//  Created by star king on 12-6-15.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import "ECLoadMoreUITableView.h"
#import "TableFooterView.h"

@implementation ECLoadMoreUITableView

@synthesize hasNext = _hasNext;
@synthesize autoLoadDelegate = _autoLoadDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0.5 - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        mRefreshHeaderView.delegate = self;
        [self addSubview:mRefreshHeaderView];
        
        [mRefreshHeaderView refreshLastUpdatedDate];
       
        [self setDelegate:self];
    }
    return self;
}

- (void)setReloadingFlag:(BOOL)flag {
    _reloading = flag;
    if (!_reloading) {
        [mRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

- (void)setAppendingDataFlag:(BOOL)flag {
    _appending = flag;
    if (!_appending) {
        // hide table footer view
        self.tableFooterView = nil;
    }
}
 
#pragma mark - EGORefreshTableHeaderDelegate methods implemetation
-(void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    // egoRefreshTableHeader did trigger refresh
    NSLog(@"begin to reload data.");
    
    // update reloading flag
    _reloading = YES;
    // init table dataSource
    [self.autoLoadDelegate refreshDataSource];
}

-(BOOL) egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return  _reloading;
}

-(NSDate*) egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

#pragma mark - UIScrollViewDelegate methods implemetation
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_appending) {
        [self.autoLoadDelegate loadMoreDataSource];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [mRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    // scroll to bottom of self tableView, judge if or not have more data
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height && !_appending){
        // judge if or not have more data
        if(_hasNext.boolValue){
            NSLog(@"has next, need to load more data");
            // need to append more data, update append data flag
            _appending = YES;
            
            // init and add table footerView
            self.tableFooterView = [[TableFootSpinnerView alloc] initWithFrame:CGRectMake(0.0 , self.frame.size.height, self.frame.size.width, 45.0)];
        }
        else{            
            // init and add table footerView
            if(!self.tableFooterView){
                self.tableFooterView = [[TableFootNoMoreDataView alloc] initWithFrame:CGRectMake(0.0 , self.frame.size.height, self.frame.size.width, 45.0)];
            }
            
            return;
        }
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [mRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // if decelerate is no(ios4)
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

@end
