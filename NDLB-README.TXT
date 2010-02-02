Installation notes on setting up the production server.

Updating the source code:
ndlb$ svn update

Creating the database:
ndlb$ mysql -u rubyuser -p

If you are "uninstalling" and "reinstalling" delete database first:
mysql> drop database ndlb_production;

Then create it:
mysql> create database ndlb_production;
mysql> exit

Because there code for globalization assumes the presence of certain tables that won't be created until the db migration is run, you have to temporarily comment them out in the config/environment  (near the end) like this:
# Code for globalization
#LOCALES = Language.locales_hash
#Globalize::Locale.set_base_language LOCALES['dz']
#ACCEPTED_LOCALES = LOCALES.keys.freeze
#LANGUAGES = Language.languages_array

Setup language tables:
ndlb$ rake globalize:setup RAILS_ENV=production

Go half-way through the migrations:
ndlb$ rake db:migrate RAILS_ENV=production VERSION=12

Now the tables required by the code for globalization have been created, so you can uncomment them again like this:
# Code for globalization
LOCALES = Language.locales_hash
Globalize::Locale.set_base_language LOCALES['dz']
ACCEPTED_LOCALES = LOCALES.keys.freeze
LANGUAGES = Language.languages_array

Run the full set of migrations:
ndlb$ rake db:migrate RAILS_ENV=production

Now import the images:

ndlb$ rake import:images RAILS_ENV=production SOURCE=db/migrate/images/

Import the texts:

PENDING

Import the videos:

ndlb$  rake import:movies RAILS_ENV=production SOURCE=db/migrate/movies/ --trace
