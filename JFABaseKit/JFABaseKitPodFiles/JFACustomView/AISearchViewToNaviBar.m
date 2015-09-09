//
//  AISearchViewToNaviBar.m
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-17.
//
//

#import "AISearchViewToNaviBar.h"

@implementation AISearchViewToNaviBar

- (IBAction)cancelButtonAction:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(canelButtonPressAction)]) {
        [self.delegate canelButtonPressAction];
    }
}

- (IBAction)searchButtonPressAction:(id)sender {
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchButtonPressAction)]) {
        [self.delegate searchButtonPressAction];
    }
}

- (void)awakeFromNib {
    self.textbg.backgroundColor = [UIColor colorForHex:@"#e3e4e6"];
    self.textbg.layer.cornerRadius = 5;
    
    if (IOS7_OR_LATER) {
        self.textField.tintColor = AI_MAIN_BLUECOLOR;
    }
    [self.cancelBtn setTitleColor:AI_MAIN_BLUECOLOR  forState:UIControlStateSelected];
    [self.cancelBtn setTitleColor:AI_MAIN_BLUECOLOR forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundImage:[UIImage storeImageNamed:@"searchbar_cancel_button_normal"] forState:UIControlStateSelected];
    [self.cancelBtn setBackgroundImage:[UIImage storeImageNamed:@"searchbar_cancel_button_normal"] forState:UIControlStateHighlighted];
    
    self.searchIconImageview.image = [[UIImage storeImageNamed:@"search_bar_icon@3x.png"] scaledImageFrom3x];
    
    
}

+ (id)viewFromNib {
    AISearchViewToNaviBar *searchView = [[AISearchViewToNaviBar alloc] init];

    return searchView;
}


- (void)showCancelButton:(BOOL)isShow animation:(BOOL)animation completion:(void (^)(BOOL finished))completion
{    
    CGRect inputViewFrame = self.searchContainer.frame;
    CGRect cancelBtnFrame = self.cancelBtn.frame;
    
    DLog(@"before = %f     %f",self.searchContainer.frame.size.width,self.cancelBtn.frame.origin.x);
    
    
    if (isShow) {
        inputViewFrame.size.width = self.frame.size.width - 68;
    }
    cancelBtnFrame.origin.x = self.frame.size.width - 43;

    
    self.searchContainer.frame = inputViewFrame;
    self.cancelBtn.frame = cancelBtnFrame;
    
    
    DLog(@"after = %f     %f",self.searchContainer.frame.size.width,self.cancelBtn.frame.origin.x);

    
}

@end
