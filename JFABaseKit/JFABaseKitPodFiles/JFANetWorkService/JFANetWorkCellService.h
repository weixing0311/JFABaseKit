//
//  JFANetWorkCellService.h
//  Pods
//
//  Created by 魏星 on 15/9/26.
//
//

#import "JFANetWorkService.h"

@interface JFANetWorkCellService : JFANetWorkService
-(JFANetWorkServiceItem *)getServiceItem;
-(void)startService;
-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading;
-(void)serviceSucceededWithResult:(id)result operation:(AFHTTPRequestOperation*)operation;
-(void)serviceFailedWithError:(NSError*)error operation:(AFHTTPRequestOperation*)operation;
-(BOOL)isEqualUrl:(NSString*)url forOperation:(AFHTTPRequestOperation*)operation;
-(void)showNetworkError;
-(void)showError;

@end
