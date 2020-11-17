/**
    MIT License

    Copyright (c) 2020 4an70m

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 */
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