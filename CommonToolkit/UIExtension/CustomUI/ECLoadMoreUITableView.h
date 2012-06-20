//
//  ECLoadMoreUITableView.h
//  ectoolkit
//
//  Created by star king on 12-6-15.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol AutoLoadDelegate <NSObject>
// refresh table view data source - need to be implemented by subclasses
- (void)refreshDataSource;
// load more data for table view - need to be implemented by subclasses
- (void)loadMoreDataSource;
@end

@interface ECLoadMoreUITableView : UITableView <EGORefreshTableHeaderDelegate, UIScrollViewDelegate>{
    EGORefreshTableHeaderView *mRefreshHeaderView;
    BOOL _reloading;
    BOOL _appending;
}

@property (nonatomic, retain) NSNumber *hasNext;
@property (nonatomic, retain) id<AutoLoadDelegate> autoLoadDelegate;

- (void)setReloadingFlag:(BOOL)flag;
- (void)setAppendingDataFlag:(BOOL)flag;

@end
