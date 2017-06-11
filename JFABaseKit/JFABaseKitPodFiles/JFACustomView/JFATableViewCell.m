//
//  JFATableViewCell.m
//  Pods
//
//  Created by stefan on 15/8/31.
//
//

#import "JFATableViewCell.h"

@implementation JFATableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(JFATableCellItem*)item
{
    
}

-(JFANetWorkServiceItem*)getServiceItem
{
    return nil;
}

-(void)startService
{
    [self startServiceWithItem:[self getServiceItem] isShowLoading:NO];
}

-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading
{
    
    if (item) {
        NSURLSessionTask* req=nil;
        if ([item.method isEqualToString:@"POST"]) {
            req=[[JFANetWorkService sharedManager] post:item.url paramters:item.parameters success:^(NSURLSessionTask *operation, id responseObject) {
                [self serviceSucceededWithResult:responseObject operation:operation];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [self serviceFailedWithError:error operation:operation];
            }];
        }else{
            req=[[JFANetWorkService sharedManager] get:item.url paramters:item.parameters success:^(NSURLSessionTask *operation, id responseObject) {
                [self serviceSucceededWithResult:responseObject operation:operation];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [self serviceFailedWithError:error operation:operation];
            }];
        }
        
    }
}

-(void)serviceSucceededWithResult:(id)result operation:(NSURLSessionTask*)operation
{
    
    
}

-(void)serviceFailedWithError:(NSError*)error operation:(NSURLSessionTask*)operation
{
    
}

-(BOOL)isEqualUrl:(NSString*)url forOperation:(NSURLSessionTask*)operation
{
    NSString* operationUrl = [operation.originalRequest.URL absoluteString];
    NSString* eUrl=[NSString stringWithFormat:@"%@%@",[JFANetWorkService sharedManager].JFADomin,url];
    DLog(@"eUrl==%@  operationUrl==%@",eUrl,operationUrl);
    return [eUrl isEqualToString:operationUrl];
}

-(void)showNetworkError
{
    //    self.errorView.hidden=YES;
    //    self.networkErrorView.hidden=NO;
}

-(void)showError
{
    //    if (_errorView) {
    //        self.errorView.hidden=NO;
    //        self.networkErrorView.hidden=YES;
    //    }
}



@end
