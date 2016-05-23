//
//  CreditCardFormSubmit.m
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditCardFormSubmit.h"
#import "CardSubmitSuccess.h"
#import "SubmitCreditMessage.h"
#import "ReactiveCocoa.h"
#import "SubmitCredit.h"
#import "AES128Base64Util.h"

@interface CreditCardFormSubmit ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SubmitCredit  *creditForm;
@property (nonatomic, strong) NSArray *districts;
@property (nonatomic, strong) NSArray *area_names;
@end

@implementation CreditCardFormSubmit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    if ([[ZYCacheManager shareInstance] getCreditForm]) {
        self.creditForm = [[ZYCacheManager shareInstance] getCreditForm];
    }else {
        self.creditForm = [[SubmitCredit alloc] init];
    }
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.title = @"信用卡申请";
    
    [self feachData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.creditForm.id_card = @"";
    [[ZYCacheManager shareInstance] saveCreditForm:self.creditForm];
}

- (void)feachData {
    [[HTTPClientManager manager] POST:@"credit/get_zone_list?" dictionary:@{} success:^(id responseObject) {
        self.districts = [responseObject objectForKey:@"items"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
        [self.districts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temp addObject:[obj objectForKey:@"area_name"]];
        }];
        self.area_names = temp;
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([ZYCacheManager shareInstance].user.isLogin) {
       return 11;
    }else {
       return 13;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitCreditMessage *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            break;
        case 6:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell7"];
            break;
        case 7:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell8"];
            break;
        case 8:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell9"];
            break;
        case 9:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
            break;
        case 10:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
            break;
        case 11:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell12"];
            break;
        case 12:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell13"];
            break;
        default:
            break;
    }
    @weakify(self);
    [cell.id_card.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (![x isEqualToString:@""]) {
            self.creditForm.id_card = x;
        }
    }];
    [cell.name.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (![x isEqualToString:@""]) {
            self.creditForm.name = x;
        }
    }];
    [cell.address.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (![x isEqualToString:@""]) {
            self.creditForm.address = x;
        }
    }];
    [cell.tel.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (![x isEqualToString:@""]) {
            self.creditForm.tel = x;
        }
    }];
    [cell.code.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (![x isEqualToString:@""]) {
            self.creditForm.code = x;
        }
    }];
    cell.creditForm = self.creditForm;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            __block NSArray *temp = @[@"专科",@"本科及以上",@"其他"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"专科",@"本科及以上",@"其他",nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                self.creditForm.education = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 1:
        {
            __block NSArray *temp = @[@"租房",@"本地购置住房",@"集体宿舍",@"父母、亲属家",@"其他"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"租房",@"本地购置住房",@"集体宿舍",@"父母、亲属家",@"其他", nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                self.creditForm.house = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 2:
        {
            __block NSArray *temp = @[@"无信用卡",@"有其他信用卡",@"有本行信用卡"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"无信用卡",@"有其他信用卡",@"有本行信用卡",nil];
            [sheet showInView:self.view];
             @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                NSLog(@"%d",[index integerValue]);
                self.creditForm.creditMessage = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 3:
        {
            __block NSArray *temp = @[@"白领上班族",@"公务员事业单位",@"房地产经纪",@"美容美发",@"小型餐饮",@"保安保洁",@"个体户",@"其他"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"白领上班族",@"公务员事业单位",@"房地产经纪",@"美容美发",@"小型餐饮",@"保安保洁",@"个体户",@"其他",nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                NSLog(@"%d",[index integerValue]);
                self.creditForm.work = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];

        }
            break;
        case 4:
        {
            __block NSArray *temp = @[@"国有",@"机关事业",@"外商独资",@"民营",@"合资/合作",@"股份制",@"个体私营",@"其他"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"国有",@"机关事业",@"外商独资",@"民营",@"合资/合作",@"股份制",@"个体私营",@"其他",nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                NSLog(@"%d",[index integerValue]);
                self.creditForm.companyType = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 5:
        {
            __block NSArray *temp = @[@"无社保",@"连续缴纳三个月",@"连续缴纳半年",@"连续缴纳一年",@"连续缴纳一年以上"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"无社保",@"连续缴纳三个月",@"连续缴纳半年",@"连续缴纳一年",@"连续缴纳一年以上",nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                NSLog(@"%d",[index integerValue]);
                self.creditForm.socialSecurity = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 6:
        {
            __block NSArray *temp = @[@"工牌",@"营业执照",@"工作证明",@"名片",@"无工作证明"];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"工牌",@"营业执照",@"工作证明",@"名片",@"无工作证明",nil];
            [sheet showInView:self.view];
            @weakify(self);
            [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                @strongify(self);
                if ([index integerValue] == temp.count) {
                    return;
                }
                NSLog(@"%d",[index integerValue]);
                self.creditForm.workIndetified = [temp objectAtIndex:[index integerValue]];
                [self.tableView reloadData];
            }];
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            
        }
            break;
        case 9:
        {
            if (self.area_names.count != 0) {
                UIActionSheet *sheet = [[UIActionSheet alloc] init];
                [self.area_names enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [sheet addButtonWithTitle:obj];
                }];
                [sheet addButtonWithTitle:@"取消"];
                [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber* index) {
                    if ([index integerValue] == self.area_names.count) {
                        return;
                    }
                    NSLog(@"%d",[index integerValue]);
                    self.creditForm.district = [self.area_names objectAtIndex:[index integerValue]];
                    [self.tableView reloadData];

                }];
                [sheet showInView:self.view];
            }
        }
            break;
        case 10:
        {
            
        }
            break;
        case 11:
        {
            
        }
            break;
        case 12:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -
- (IBAction)submit:(id)sender {
    if (StringIsNull(_creditForm.education)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.house)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.creditMessage)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.work)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.companyType)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.socialSecurity)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.workIndetified)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.id_card)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.name)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.district)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (StringIsNull(_creditForm.address)) {
        mAlertView(@"", @"请完善信息");
        return;
    }
    if (![ZYCacheManager shareInstance].user.isLogin) {
        if (StringIsNull(_creditForm.tel)) {
            mAlertView(@"", @"请完善信息");
            return;
        }
        if (StringIsNull(_creditForm.code)) {
            mAlertView(@"", @"请完善信息");
            return;
        }
    }else {
        _creditForm.tel = [ZYCacheManager shareInstance].user.telephone;
    }
    BOOL b = [NSString validateIdentityCard:_creditForm.id_card];
    if (!b) {
        mAlertView(@"", @"请填写正确的身份证号")
        return;
    }
    [MobClick event:@"creditFormSubmit"];
    NSString *tel = [AES128Base64Util AES128Encrypt:_creditForm.tel withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    NSString *citycode = [[self.districts objectAtIndex:[self.area_names indexOfObject:_creditForm.district]] objectForKey:@"area_code"];
    [[HTTPClientManager manager] POST:@"credit/send_credit_apply?" dictionary:@{@"city":[ZYCacheManager shareInstance].user.city_s_EN,@"bankids":@(_bank_id),@"card_id":@(_card_id),@"truename":_creditForm.name,@"mobile":tel,@"checksms":_creditForm.code,@"address":_creditForm.address,@"idcard":_creditForm.id_card,@"areacode":citycode,@"cardgrade":_creditForm.creditMessage,@"occupation":_creditForm.work,@"socialensure":_creditForm.socialSecurity,@"jobprove":_creditForm.workIndetified,@"graduation":_creditForm.education,@"jobtype":_creditForm.companyType,@"fund":_creditForm.house,@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        CardSubmitSuccess *success = StoryBoardDefined(@"CardSubmitSuccess");
        [self.navigationController pushViewController:success animated:YES];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


- (void)dealloc {
   
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
