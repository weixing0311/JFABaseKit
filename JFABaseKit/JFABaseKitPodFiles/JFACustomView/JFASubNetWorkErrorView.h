//
//  JFASubNetWorkErrorView.h
//  Pods
//
//  Created by 魏星 on 15/10/10.
//
//

#import "JFANetworkErrorView.h"
@protocol subNetWorkDelegate <NSObject>
-(void)didRefreshInfo;
@end
@interface JFASubNetWorkErrorView : JFANetworkErrorView
@property (nonatomic, assign)id<subNetWorkDelegate>delegate;
@end
