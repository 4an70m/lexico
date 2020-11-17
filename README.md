Lexico - Data Translations
--
## What is Lexico?
Salesforce has great means of delivering translatable metadata - custom labels, Translation Workbench. 
Mostly everything can be translated.
But what about data? Currently, Salesforce doesn't have means to translate data. Why would they? Does it even make sense to translate the data, rather than having it the way it was inputted?
Sometimes, there is a presentation part of data, that need to get to the end user, some custom development, that relies heavily on the texts, stored in the Objects, rather than in Metadata.
This use-cases might be:
- Communities
- Public Community pages
- Public Sites
 
Whenever you display the data to the external end-user, outside of Salesforce, you might want to get it translated to be pleasantly presented. 
Sometimes, it might even be the case for the internal users.

## Is Lexico for me?
If: 
- you custom development or package is heavily data-driven
- you have large chunks of text data in your Objects 
- you want to make your data in the Objects multilingual

Lexico is for you.  

## How Lexico works?
It adds a Custom Object - Data Translations, where it stores translations for each individual field of each object you need translations for.
All you need to do, to translate data in code is to add the following line of code, pass the language name, and a list of record you want to translate.

```Apex
final List<SObject> translatedRecords = Lexico.getInstance().translate('language', <list of SObjects to translate>);
```

Lexico performs a single query for the whole chunk of SObject you've passed, replaces all the fields, which have translations with translated values,
and caches the result in a static map, so that subsequent calls for the same records wouldn't result a query.

## TODO
- Finish Readme
- Expand Lexico