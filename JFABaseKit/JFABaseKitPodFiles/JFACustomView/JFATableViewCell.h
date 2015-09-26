//
//  JFATableViewCell.h
//  Pods
//
//  Created by stefan on 15/8/31.
//
//

#import <UIKit/UIKit.h>
#import "JFATableCellItem.h"

@interface JFATableViewCell : UITableViewCell

-(void)updateCell:(JFATableCellItem*)item;
-(void)createTagViewWithArr:(NSArray *)arr;


-(JFANetWorkServiceItem *)getServiceItem;
-(void)startService;
-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading;
-(void)serviceSucceededWithResult:(id)result operation:(AFHTTPRequestOperation*)operation;
-(void)serviceFailedWithError:(NSError*)error operation:(AFHTTPRequestOperation*)operation;
-(BOOL)isEqualUrl:(NSString*)url forOperation:(AFHTTPRequestOperation*)operation;
-(void)showNetworkError;
-(void)showError;
@end
