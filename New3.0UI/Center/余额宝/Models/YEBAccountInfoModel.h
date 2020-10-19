//  Created by hansen 



#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface YEBAccountInfoModel : NSObject 

        /**999933.98*/
        @property (nonatomic, assign) double m_balance;

        /**100*/
        @property (nonatomic, assign) double m_rollInMinMoney;

        /**10000000*/
        @property (nonatomic, assign) double m_rollInMaxMoney;

        /**10000000*/
        @property (nonatomic, assign) double m_rollOutMaxMoney;

        /**151.1*/
        @property (nonatomic, assign) double m_thirtyEarnings;

        /**0*/
        @property (nonatomic, assign) double m_totalMoney;

        /***/
        @property (nonatomic, copy) NSString *m_payPassword;

        /**100*/
        @property (nonatomic, assign) double m_rollOutMinMoney;

        /**18.1*/
        @property (nonatomic, assign) double m_sevenDyr;

        /**0*/
        @property (nonatomic, assign) double m_totalEarnings;

@end
