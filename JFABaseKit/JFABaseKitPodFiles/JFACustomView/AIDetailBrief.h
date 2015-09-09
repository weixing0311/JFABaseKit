//
//  AIDetailBrief.h
//  AppInstallerGreen
//
//  Created by feng.lipeng on 14-6-26.
//
//

#import <UIKit/UIKit.h>

@protocol DetailBriefDelegate <NSObject>

-(void)onDetailBriefSelectedAt:(NSInteger)viewTag more:(BOOL)more;

@end

@interface AIDetailBrief : UIView

@property (nonatomic, setter = setTitle:) NSString* title;
//@property (nonatomic, setter = setDesStr:show: more:) NSString* des;
@property (nonatomic, setter = setDateStr:) NSString* dateStr;

@property (nonatomic, retain) IBOutlet UILabel* titleLab;
@property (nonatomic, retain) IBOutlet UILabel* upgradeLab;
@property (nonatomic, retain) IBOutlet UILabel* desLab;
@property (nonatomic, retain) IBOutlet UIButton* moreBtn;
@property (nonatomic, retain) UIView* line;

@property (nonatomic, assign) id<DetailBriefDelegate>delegate;

-(void)setButtonUI:(BOOL)show more:(BOOL)more;
-(CGFloat)getHeight;
-(CGFloat)getShortHeight;
-(void)setHeight:(CGFloat)height ;
-(void)setDesStr:(NSString *)des show:(BOOL)show;
-(IBAction)btnPressed:(UIButton*)button;
@end
