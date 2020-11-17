@IsTest
public with sharing class LexicoTest {

    //Lexico
    @IsTest
    public static void testLexicoNoData() {
        final Account account = new Account(Name = 'Test');
        insert account;

        final List<Account> accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account]);

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test', accounts[0].Name);
    }

    @IsTest
    public static void testLexicoNoRecords() {
        final List<Account> accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account]);

        System.assert(accounts.isEmpty());
    }

    @IsTest
    public static void testLexicoBadData() {
        final List<Account> accounts = Lexico.getInstance().translate('es', null);

        System.assert(accounts.isEmpty());
    }

    @IsTest
    public static void testLexicoWithData() {
        final Account account = new Account(Name = 'Test');
        insert account;

        final Data_Translation__c accountNameDt = new Data_Translation__c(
                Record_Id__c = account.Id,
                Field_API_Name__c = 'Name',
                Language__c = 'es',
                Translated_Value__c = 'Test in spanish'
        );
        insert accountNameDt;

        final List<Account> accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account]);

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test in spanish', accounts[0].Name);
    }

    @IsTest
    public static void testLexicoWithCache() {
        final Account account = new Account(Name = 'Test');
        insert account;

        final Data_Translation__c accountNameDt = new Data_Translation__c(
                Record_Id__c = account.Id,
                Field_API_Name__c = 'Name',
                Language__c = 'es',
                Translated_Value__c = 'Test in spanish'
        );
        insert accountNameDt;

        List<Account> accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account]);
        accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account]);

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test in spanish', accounts[0].Name);
    }

    @IsTest
    public static void testLexicoWithDataAndRefresh() {
        final Account account = new Account(Name = 'Test');
        insert account;

        final Data_Translation__c accountNameDt = new Data_Translation__c(
                Record_Id__c = account.Id,
                Field_API_Name__c = 'Name',
                Language__c = 'es',
                Translated_Value__c = 'Test in spanish'
        );
        insert accountNameDt;

        final List<Account> accounts = Lexico.getInstance().translate('es', [SELECT Id, Name FROM Account], true);

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test in spanish', accounts[0].Name);
    }
}