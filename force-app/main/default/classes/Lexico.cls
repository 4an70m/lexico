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
public without sharing class Lexico {

    private static Lexico instance;

    public static Lexico getInstance() {
        if (instance == null) {
            instance = new Lexico();
        }
        return instance;
    }

    private final Map<String, SObject> cachedTranslations;

    private Lexico() {
        this.cachedTranslations = new Map<String, SObject>();
    }

    public List<SObject> translate(final List<SObject> records) {
        return this.translate(UserInfo.getLanguage(), records, false);
    }

    public List<SObject> translate(final String language, final List<SObject> records) {
        return this.translate(language, records, false);
    }

    public List<SObject> translate(final String language, final List<SObject> records, final Boolean refreshCache) {
        if (language == null || String.isEmpty(language) || records == null || records.isEmpty()) {
            return new List<SObject>();
        }

        final List<SObject> recordsToTranslate = records.deepClone(true, true, true);

        final List<SObject> cachedTranslatedRecords = this.getCachedTranslations(language, recordsToTranslate, refreshCache);
        final List<SObject> translatedRecords = this.getTranslations(language, recordsToTranslate);
        final List<SObject> mergedTranslations = this.mergeTranslations(translatedRecords, cachedTranslatedRecords);

        this.cacheTranslations(language, mergedTranslations);
        return mergedTranslations;
    }

    private List<SObject> getCachedTranslations(final String language, final List<SObject> records, final Boolean refreshCache) {
        final List<SObject> result = new List<SObject>();
        if (refreshCache) {
            return result;
        }
        final List<SObject> filteredRecords = new List<SObject>();
        for (SObject record : records) {
            final String key = record.Id + language;
            if (this.cachedTranslations.containsKey(key)) {
                result.add(this.cachedTranslations.get(key));
            } else {
                filteredRecords.add(record);
            }
        }
        records.clear();
        records.addAll(filteredRecords);
        return result;
    }

    private List<SObject> getTranslations(final String language, final List<SObject> records) {
        if (records.isEmpty()) {
            return new List<SObject>();
        }
        final Set<Id> recordIds = new Map<Id, SObject>(records).keySet();
        final List<Data_Translation__c> dataTranslations = [
                SELECT Id
                        , Record_Id__c
                        , Field_API_Name__c
                        , Translated_Value__c
                        , Language__c
                FROM Data_Translation__c
                WHERE Record_Id__c IN :recordIds
                AND Language__c = :language
        ];

        final Map<Id, SObject> recordsById = new Map<Id, SObject>(records);
        for (Data_Translation__c translation : dataTranslations) {
            final SObject recordToTranslate = recordsById.get(translation.Record_Id__c);
            if (recordToTranslate != null && recordToTranslate.isSet(translation.Field_API_Name__c)) {
                recordToTranslate.put(translation.Field_API_Name__c, translation.Translated_Value__c);
            }
        }
        return recordsById.values();
    }

    private List<SObject> mergeTranslations(final List<SObject> translatedRecords, final List<SObject> cachedTranslatedRecords) {
        final List<SObject> result = new List<SObject>();
        result.addAll(translatedRecords);
        result.addAll(cachedTranslatedRecords);
        return result;
    }

    private void cacheTranslations(final String language, final List<SObject> translatedRecords) {
        for (SObject translatedRecord : translatedRecords) {
            final String key = translatedRecord.Id + language;
            if (!this.cachedTranslations.containsKey(key)) {
                this.cachedTranslations.put(key, translatedRecord);
            }
        }
    }
}