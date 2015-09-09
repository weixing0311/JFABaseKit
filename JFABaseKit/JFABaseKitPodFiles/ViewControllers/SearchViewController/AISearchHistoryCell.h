//
//  AISearchHistoryCell.h
//  AppInstallerGreen
//
//  Created by feng.lipeng on 14-7-15.
//
//

#import <UIKit/UIKit.h>

@protocol SearchHistoryCellDelegate <NSObject>

-(void)onDeleteItemWithKey:(NSString*)key;

@end

@interface AISearchHistoryCell : UITableViewCell

@property (nonatomic ,strong) IBOutlet UILabel* titleLabel;
@property (nonatomic ,strong) IBOutlet UIButton* deleteBtn;
@property (nonatomic ,strong) IBOutlet UIView* icon;
@property (nonatomic ,assign) id<SearchHistoryCellDelegate> deleteDelegate;

-(IBAction)deleteBtnPressed:(UIButton*)button;
@end
