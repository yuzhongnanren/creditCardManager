//
//  UserMessageViewController.m
//  creditManager
//
//  Created by haodai on 16/3/18.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "UserMessageViewController.h"
#import "ReactiveCocoa.h"
#import "CityViewController.h"
#import "JCCDatePickerView.h"
#import "UIButton+AFNetworking.h"

@interface UserMessageViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UITextField *nikeName;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *birthDay;
@property (weak, nonatomic) IBOutlet UITextField *weixing;
@property (weak, nonatomic) IBOutlet UITextField *qq;
@property (nonatomic, strong) NSDictionary *userDic;
@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) JCCDatePickerView *pickView;

@end

@implementation UserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    self.sex.enabled = NO;
    self.address.enabled = NO;
    self.birthDay.enabled = NO;
    ViewRadius(_photoBtn, _photoBtn.width/2);
    self.sexArray = @[@"保密",@"男",@"女",];
    [self feathData];
    
    [self.nikeName.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.nikeName resignFirstResponder];
        }
    }];
    
    [self.weixing.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.weixing resignFirstResponder];
        }
    }];
    
    [self.qq.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.qq resignFirstResponder];
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feathData {
    [[HTTPClientManager manager] POST:@"/UserCenter/get_user_info?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        self.userDic = responseObject;
        if (!StringIsNull([self.userDic objectForKey:@"avatar"])) {
            [self.photoBtn setImageForState:0 withURL:[NSURL URLWithString:[self.userDic objectForKey:@"avatar"]]];
        }
        if (!StringIsNull([self.userDic objectForKey:@"nickname"])) {
            _nikeName.text = [self.userDic objectForKey:@"nickname"];
        }
        if ([[self.userDic objectForKey:@"sex"] integerValue] == 0) {
            _sex.text = @"保密";
        }else if([[self.userDic objectForKey:@"sex"] integerValue] == 1) {
            _sex.text = @"男";
        }else if([[self.userDic objectForKey:@"sex"] integerValue] == 2) {
            _sex.text = @"女";
        }
        if (!StringIsNull([self.userDic objectForKey:@"CN"])) {
            _address.text = [self.userDic objectForKey:@"CN"];
             [ZYCacheManager shareInstance].user.address = [self.userDic objectForKey:@"CN"];
        }
        if ([[self.userDic objectForKey:@"zone_id"] integerValue]) {
            [ZYCacheManager shareInstance].user.address_Zone_Id = [self.userDic objectForKey:@"zone_id"];
        }
        [[ZYCacheManager shareInstance] save];
        if (!StringIsNull([self.userDic objectForKey:@"birthday"])) {
            _birthDay.text = [self.userDic objectForKey:@"birthday"];
        }
        if (!StringIsNull([self.userDic objectForKey:@"weixin"])) {
            _weixing.text = [self.userDic objectForKey:@"weixin"];
        }
        if (!StringIsNull([self.userDic objectForKey:@"qq"])) {
            _qq.text = [self.userDic objectForKey:@"qq"];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

#pragma mark - 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self enterTakePic];
    }else if(indexPath.row == 2) {
        [self chooseSex];
    }else if(indexPath.row == 3) {
        [self chooseAddress];
    }else if(indexPath.row == 4) {
        [self chooseBirthday];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - Action
- (void)chooseSex {
    UIAlertView *alertView = [[UIAlertView alloc] init];
   [self.sexArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [alertView addButtonWithTitle:obj];
   }];
   [alertView show];
    @weakify(self);
    [alertView.rac_buttonClickedSignal  subscribeNext:^(NSNumber* x) {
        @strongify(self);
        _sex.text = [self.sexArray objectAtIndex:[x integerValue]];
    }];
}

- (void)chooseAddress {
    CityViewController *city = [[CityViewController alloc] init];
    city.type = 1;
    city.delegate = self;
    [self.navigationController pushViewController:city animated:YES];
}

- (void)chooseBirthday {
    if (_pickView == nil) {
        _pickView = [[JCCDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.height - 260.f, self.view.width, 260.f)];
        @weakify(self);
        _pickView.dateBlock = ^(NSString *birth) {
            @strongify(self);
            self.birthDay.text = birth;
        };
    }
    if (!StringIsNull(self.birthDay.text)) {
        _pickView.birthDay = self.birthDay.text;
    }
    [_pickView show];
}

- (IBAction)takePic:(id)sender {
    [self enterTakePic];
}

- (IBAction)save:(id)sender {
    if (![_nikeName hasText]) {
        mAlertView(@"", @"请输入昵称");
        return;
    }
    if (![_birthDay hasText]) {
        mAlertView(@"", @"请输入您的生日");
        return;
    }
    NSLog(@"%@",[ZYCacheManager shareInstance].user.address_Zone_Id);
    [[HTTPClientManager manager] POST:@"UserCenter/update_user_info?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"nickname":_nikeName.text,@"sex":@([self.sexArray indexOfObject:_sex.text]),@"zone_id":[ZYCacheManager shareInstance].user.address_Zone_Id,@"birthday":_birthDay.text,@"qq":_qq.text,@"weixin":_weixing.text} success:^(id responseObject) {
        [ZYCacheManager shareInstance].user.nickname = _nikeName.text;
        if (!StringIsNull(_qq.text)) {
            [ZYCacheManager shareInstance].user.qq = _qq.text;
        }
        if (!StringIsNull(_weixing.text)) {
            [ZYCacheManager shareInstance].user.weixing = _weixing.text;
        }
        [ZYCacheManager shareInstance].user.sex = [self.sexArray indexOfObject:_sex.text];
        [ZYCacheManager shareInstance].user.birthday = self.birthDay.text;
        [[ZYCacheManager shareInstance] save];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


- (void)enterTakePic {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - 
- (void)citySelectedUpdateData {
    _address.text = [ZYCacheManager shareInstance].user.address;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 || buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }
}


#pragma mark - UIImagePickController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *theImage = [[AppFun sharedInstance] clipImage:image scaleToSize:CGSizeMake(200, 200)];
    [_photoBtn setImage:theImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadUserImageData:UIImageJPEGRepresentation(theImage, 1.0)];
}

- (void)uploadUserImageData:(NSData*)imgData {
    [[HTTPClientManager manager] POST:@"UserCenter/update_avatar?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid)} ImageData:imgData success:^(id responseObject) {
        if (isNotNull([responseObject objectForKey:@"avatar_url"])) {
            [ZYCacheManager shareInstance].user.photoPath = [responseObject objectForKey:@"avatar_url"];
            [[ZYCacheManager shareInstance] save];
        }
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
