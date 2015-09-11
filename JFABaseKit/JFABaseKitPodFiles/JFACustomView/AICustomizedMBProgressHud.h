//
//  AICustomizedMBProgressHud.h
//  AppInstallerGreen
//
//  Created by chengb on 13-10-16.
//
//

#import "MBProgressHUD.h"

typedef enum _tagAIHudType{
    AI_HudType_Info,
    AI_HudType_Warning,
    AI_HudType_Loading,
}AIHudType;


@interface AICustomizedMBProgressHud : MBProgressHUD

+ (AICustomizedMBProgressHud *)showHUDAddedTo:(UIView *)view type:(int)type animated:(BOOL)animated;

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

@end
