import 'package:hkinfo/CovidApp/country.dart';
import 'package:hkinfo/CovidApp/owid.dart';
import 'package:hkinfo/CovidApp/hk.dart';
import 'package:hkinfo/CovidHKApp/dataGetter.dart';

List<Country> countries = [
  Country('Hong Kong', hkDataGetter, DateTime(2020, 1, 8),
      source: 'hk.data.gov', moreInfoDataGetter: hkMoreData),
  Country(
      'France',
      ({override = false}) async => await owidDataGetter('France', override),
      DateTime(2019, 12, 31)),
  Country(
      'Madagascar',
      ({override = false}) async => await owidDataGetter('Madagascar', override),
      DateTime(2020, 3, 21)),
  Country(
      'United States',
      ({override = false}) async => await owidDataGetter('United States', override),
      DateTime(2019, 12, 31)),
  Country(
      'Afghanistan',
      ({override = false}) async => await owidDataGetter('Afghanistan', override),
      DateTime(2019, 12, 31)),
  Country(
      'Albania',
      ({override = false}) async => await owidDataGetter('Albania', override),
      DateTime(2020, 3, 9)),
  Country(
      'Algeria',
      ({override = false}) async => await owidDataGetter('Algeria', override),
      DateTime(2019, 12, 31)),
  Country(
      'Andorra',
      ({override = false}) async => await owidDataGetter('Andorra', override),
      DateTime(2020, 3, 3)),
  Country(
      'Angola',
      ({override = false}) async => await owidDataGetter('Angola', override),
      DateTime(2020, 3, 22)),
  Country(
      'Anguilla',
      ({override = false}) async => await owidDataGetter('Anguilla', override),
      DateTime(2020, 3, 27)),
  Country(
      'Antigua and Barbuda',
      ({override = false}) async => await owidDataGetter('Antigua and Barbuda', override),
      DateTime(2020, 3, 15)),
  Country(
      'Armenia',
      ({override = false}) async => await owidDataGetter('Armenia', override),
      DateTime(2019, 12, 31)),
  Country('Aruba', ({override = false}) async => await owidDataGetter('Aruba', override),
      DateTime(2020, 3, 13)),
  Country(
      'Australia',
      ({override = false}) async => await owidDataGetter('Australia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Austria',
      ({override = false}) async => await owidDataGetter('Austria', override),
      DateTime(2019, 12, 31)),
  Country(
      'Azerbaijan',
      ({override = false}) async => await owidDataGetter('Azerbaijan', override),
      DateTime(2019, 12, 31)),
  Country(
      'Bahamas',
      ({override = false}) async => await owidDataGetter('Bahamas', override),
      DateTime(2020, 3, 16)),
  Country(
      'Bahrain',
      ({override = false}) async => await owidDataGetter('Bahrain', override),
      DateTime(2019, 12, 31)),
  Country(
      'Barbados',
      ({override = false}) async => await owidDataGetter('Barbados', override),
      DateTime(2020, 3, 18)),
  Country(
      'Belarus',
      ({override = false}) async => await owidDataGetter('Belarus', override),
      DateTime(2019, 12, 31)),
  Country(
      'Belgium',
      ({override = false}) async => await owidDataGetter('Belgium', override),
      DateTime(2019, 12, 31)),
  Country(
      'Belize',
      ({override = false}) async => await owidDataGetter('Belize', override),
      DateTime(2020, 3, 24)),
  Country('Benin', ({override = false}) async => await owidDataGetter('Benin', override),
      DateTime(2020, 3, 17)),
  Country(
      'Bermuda',
      ({override = false}) async => await owidDataGetter('Bermuda', override),
      DateTime(2020, 3, 20)),
  Country(
      'Bhutan',
      ({override = false}) async => await owidDataGetter('Bhutan', override),
      DateTime(2020, 3, 6)),
  Country(
      'Bolivia',
      ({override = false}) async => await owidDataGetter('Bolivia', override),
      DateTime(2020, 3, 12)),
  Country(
      'Bonaire Sint Eustatius and Saba',
      ({override = false}) async =>
          await owidDataGetter('Bonaire Sint Eustatius and Saba', override),
      DateTime(2020, 4, 2)),
  Country(
      'Bosnia and Herzegovina',
      ({override = false}) async =>
          await owidDataGetter('Bosnia and Herzegovina', override),
      DateTime(2020, 3, 6)),
  Country(
      'Botswana',
      ({override = false}) async => await owidDataGetter('Botswana', override),
      DateTime(2020, 4, 1)),
  Country(
      'Brazil',
      ({override = false}) async => await owidDataGetter('Brazil', override),
      DateTime(2019, 12, 31)),
  Country(
      'British Virgin Islands',
      ({override = false}) async =>
          await owidDataGetter('British Virgin Islands', override),
      DateTime(2020, 3, 27)),
  Country(
      'Brunei',
      ({override = false}) async => await owidDataGetter('Brunei', override),
      DateTime(2020, 3, 10)),
  Country(
      'Bulgaria',
      ({override = false}) async => await owidDataGetter('Bulgaria', override),
      DateTime(2020, 3, 8)),
  Country(
      'Burkina Faso',
      ({override = false}) async => await owidDataGetter('Burkina Faso', override),
      DateTime(2020, 3, 11)),
  Country(
      'Burundi',
      ({override = false}) async => await owidDataGetter('Burundi', override),
      DateTime(2020, 4, 1)),
  Country(
      'Cambodia',
      ({override = false}) async => await owidDataGetter('Cambodia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Cameroon',
      ({override = false}) async => await owidDataGetter('Cameroon', override),
      DateTime(2020, 3, 7)),
  Country(
      'Canada',
      ({override = false}) async => await owidDataGetter('Canada', override),
      DateTime(2019, 12, 31)),
  Country(
      'Cape Verde',
      ({override = false}) async => await owidDataGetter('Cape Verde', override),
      DateTime(2020, 3, 21)),
  Country(
      'Cayman Islands',
      ({override = false}) async => await owidDataGetter('Cayman Islands', override),
      DateTime(2020, 3, 20)),
  Country(
      'Central African Republic',
      ({override = false}) async =>
          await owidDataGetter('Central African Republic', override),
      DateTime(2020, 3, 16)),
  Country('Chad', ({override = false}) async => await owidDataGetter('Chad', override),
      DateTime(2020, 3, 20)),
  Country('Chile', ({override = false}) async => await owidDataGetter('Chile', override),
      DateTime(2020, 3, 4)),
  Country('China', ({override = false}) async => await owidDataGetter('China', override),
      DateTime(2019, 12, 31)),
  Country(
      'Comoros',
      ({override = false}) async => await owidDataGetter('Comoros', override),
      DateTime(2020, 5, 2)),
  Country('Congo', ({override = false}) async => await owidDataGetter('Congo', override),
      DateTime(2020, 3, 16)),
  Country(
      'Costa Rica',
      ({override = false}) async => await owidDataGetter('Costa Rica', override),
      DateTime(2020, 3, 7)),
  Country(
      'Cote d\'Ivoire',
      ({override = false}) async => await owidDataGetter('Cote d\'Ivoire', override),
      DateTime(2020, 3, 12)),
  Country(
      'Croatia',
      ({override = false}) async => await owidDataGetter('Croatia', override),
      DateTime(2019, 12, 31)),
  Country('Cuba', ({override = false}) async => await owidDataGetter('Cuba', override),
      DateTime(2020, 3, 12)),
  Country(
      'Curacao',
      ({override = false}) async => await owidDataGetter('Curacao', override),
      DateTime(2020, 3, 13)),
  Country(
      'Cyprus',
      ({override = false}) async => await owidDataGetter('Cyprus', override),
      DateTime(2020, 3, 10)),
  Country(
      'Czech Republic',
      ({override = false}) async => await owidDataGetter('Czech Republic', override),
      DateTime(2019, 12, 31)),
  Country(
      'Democratic Republic of Congo',
      ({override = false}) async =>
          await owidDataGetter('Democratic Republic of Congo', override),
      DateTime(2020, 3, 11)),
  Country(
      'Denmark',
      ({override = false}) async => await owidDataGetter('Denmark', override),
      DateTime(2019, 12, 31)),
  Country(
      'Djibouti',
      ({override = false}) async => await owidDataGetter('Djibouti', override),
      DateTime(2020, 3, 19)),
  Country(
      'Dominica',
      ({override = false}) async => await owidDataGetter('Dominica', override),
      DateTime(2020, 3, 23)),
  Country(
      'Dominican Republic',
      ({override = false}) async => await owidDataGetter('Dominican Republic', override),
      DateTime(2019, 12, 31)),
  Country(
      'Ecuador',
      ({override = false}) async => await owidDataGetter('Ecuador', override),
      DateTime(2019, 12, 31)),
  Country('Egypt', ({override = false}) async => await owidDataGetter('Egypt', override),
      DateTime(2019, 12, 31)),
  Country(
      'El Salvador',
      ({override = false}) async => await owidDataGetter('El Salvador', override),
      DateTime(2020, 3, 19)),
  Country(
      'Equatorial Guinea',
      ({override = false}) async => await owidDataGetter('Equatorial Guinea', override),
      DateTime(2020, 3, 15)),
  Country(
      'Eritrea',
      ({override = false}) async => await owidDataGetter('Eritrea', override),
      DateTime(2020, 3, 22)),
  Country(
      'Estonia',
      ({override = false}) async => await owidDataGetter('Estonia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Ethiopia',
      ({override = false}) async => await owidDataGetter('Ethiopia', override),
      DateTime(2020, 3, 14)),
  Country(
      'Faeroe Islands',
      ({override = false}) async => await owidDataGetter('Faeroe Islands', override),
      DateTime(2020, 3, 6)),
  Country(
      'Falkland Islands',
      ({override = false}) async => await owidDataGetter('Falkland Islands', override),
      DateTime(2020, 4, 4)),
  Country(
      'Finland',
      ({override = false}) async => await owidDataGetter('Finland', override),
      DateTime(2019, 12, 31)),
  Country(
      'French Polynesia',
      ({override = false}) async => await owidDataGetter('French Polynesia', override),
      DateTime(2020, 3, 19)),
  Country('Gabon', ({override = false}) async => await owidDataGetter('Gabon', override),
      DateTime(2020, 3, 13)),
  Country(
      'Gambia',
      ({override = false}) async => await owidDataGetter('Gambia', override),
      DateTime(2020, 3, 18)),
  Country(
      'Georgia',
      ({override = false}) async => await owidDataGetter('Georgia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Germany',
      ({override = false}) async => await owidDataGetter('Germany', override),
      DateTime(2019, 12, 31)),
  Country('Ghana', ({override = false}) async => await owidDataGetter('Ghana', override),
      DateTime(2020, 3, 13)),
  Country(
      'Gibraltar',
      ({override = false}) async => await owidDataGetter('Gibraltar', override),
      DateTime(2020, 3, 20)),
  Country(
      'Greece',
      ({override = false}) async => await owidDataGetter('Greece', override),
      DateTime(2019, 12, 31)),
  Country(
      'Greenland',
      ({override = false}) async => await owidDataGetter('Greenland', override),
      DateTime(2020, 3, 20)),
  Country(
      'Grenada',
      ({override = false}) async => await owidDataGetter('Grenada', override),
      DateTime(2020, 3, 23)),
  Country('Guam', ({override = false}) async => await owidDataGetter('Guam', override),
      DateTime(2020, 3, 19)),
  Country(
      'Guatemala',
      ({override = false}) async => await owidDataGetter('Guatemala', override),
      DateTime(2020, 3, 15)),
  Country(
      'Guernsey',
      ({override = false}) async => await owidDataGetter('Guernsey', override),
      DateTime(2020, 3, 20)),
  Country(
      'Guinea',
      ({override = false}) async => await owidDataGetter('Guinea', override),
      DateTime(2020, 3, 14)),
  Country(
      'Guinea-Bissau',
      ({override = false}) async => await owidDataGetter('Guinea-Bissau', override),
      DateTime(2020, 3, 27)),
  Country(
      'Guyana',
      ({override = false}) async => await owidDataGetter('Guyana', override),
      DateTime(2020, 3, 13)),
  Country('Haiti', ({override = false}) async => await owidDataGetter('Haiti', override),
      DateTime(2020, 3, 20)),
  Country(
      'Honduras',
      ({override = false}) async => await owidDataGetter('Honduras', override),
      DateTime(2020, 3, 12)),
  Country(
      'Iceland',
      ({override = false}) async => await owidDataGetter('Iceland', override),
      DateTime(2019, 12, 31)),
  Country('India', ({override = false}) async => await owidDataGetter('India', override),
      DateTime(2019, 12, 31)),
  Country(
      'Indonesia',
      ({override = false}) async => await owidDataGetter('Indonesia', override),
      DateTime(2019, 12, 31)),
  Country('Iran', ({override = false}) async => await owidDataGetter('Iran', override),
      DateTime(2019, 12, 31)),
  Country('Iraq', ({override = false}) async => await owidDataGetter('Iraq', override),
      DateTime(2019, 12, 31)),
  Country(
      'Ireland',
      ({override = false}) async => await owidDataGetter('Ireland', override),
      DateTime(2019, 12, 31)),
  Country(
      'Isle of Man',
      ({override = false}) async => await owidDataGetter('Isle of Man', override),
      DateTime(2020, 3, 21)),
  Country(
      'Israel',
      ({override = false}) async => await owidDataGetter('Israel', override),
      DateTime(2019, 12, 31)),
  Country('Italy', ({override = false}) async => await owidDataGetter('Italy', override),
      DateTime(2019, 12, 31)),
  Country(
      'Jamaica',
      ({override = false}) async => await owidDataGetter('Jamaica', override),
      DateTime(2020, 3, 12)),
  Country('Japan', ({override = false}) async => await owidDataGetter('Japan', override),
      DateTime(2019, 12, 31)),
  Country(
      'Jersey',
      ({override = false}) async => await owidDataGetter('Jersey', override),
      DateTime(2020, 3, 20)),
  Country(
      'Jordan',
      ({override = false}) async => await owidDataGetter('Jordan', override),
      DateTime(2020, 3, 3)),
  Country(
      'Kosovo',
      ({override = false}) async => await owidDataGetter('Kosovo', override),
      DateTime(2020, 3, 14)),
  Country(
      'Kuwait',
      ({override = false}) async => await owidDataGetter('Kuwait', override),
      DateTime(2019, 12, 31)),
  Country(
      'Kyrgyzstan',
      ({override = false}) async => await owidDataGetter('Kyrgyzstan', override),
      DateTime(2020, 3, 19)),
  Country('Laos', ({override = false}) async => await owidDataGetter('Laos', override),
      DateTime(2020, 3, 25)),
  Country(
      'Lebanon',
      ({override = false}) async => await owidDataGetter('Lebanon', override),
      DateTime(2019, 12, 31)),
  Country(
      'Lesotho',
      ({override = false}) async => await owidDataGetter('Lesotho', override),
      DateTime(2020, 5, 15)),
  Country(
      'Liberia',
      ({override = false}) async => await owidDataGetter('Liberia', override),
      DateTime(2020, 3, 17)),
  Country('Libya', ({override = false}) async => await owidDataGetter('Libya', override),
      DateTime(2020, 3, 25)),
  Country(
      'Liechtenstein',
      ({override = false}) async => await owidDataGetter('Liechtenstein', override),
      DateTime(2020, 3, 5)),
  Country(
      'Lithuania',
      ({override = false}) async => await owidDataGetter('Lithuania', override),
      DateTime(2019, 12, 31)),
  Country(
      'Luxembourg',
      ({override = false}) async => await owidDataGetter('Luxembourg', override),
      DateTime(2019, 12, 31)),
  Country(
      'Macedonia',
      ({override = false}) async => await owidDataGetter('Macedonia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Malawi',
      ({override = false}) async => await owidDataGetter('Malawi', override),
      DateTime(2020, 4, 3)),
  Country(
      'Malaysia',
      ({override = false}) async => await owidDataGetter('Malaysia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Maldives',
      ({override = false}) async => await owidDataGetter('Maldives', override),
      DateTime(2020, 3, 8)),
  Country('Mali', ({override = false}) async => await owidDataGetter('Mali', override),
      DateTime(2020, 3, 26)),
  Country(
      'Mauritania',
      ({override = false}) async => await owidDataGetter('Mauritania', override),
      DateTime(2020, 3, 15)),
  Country(
      'Mauritius',
      ({override = false}) async => await owidDataGetter('Mauritius', override),
      DateTime(2020, 3, 20)),
  Country(
      'Mexico',
      ({override = false}) async => await owidDataGetter('Mexico', override),
      DateTime(2019, 12, 31)),
  Country(
      'Moldova',
      ({override = false}) async => await owidDataGetter('Moldova', override),
      DateTime(2020, 3, 8)),
  Country(
      'Monaco',
      ({override = false}) async => await owidDataGetter('Monaco', override),
      DateTime(2019, 12, 31)),
  Country(
      'Mongolia',
      ({override = false}) async => await owidDataGetter('Mongolia', override),
      DateTime(2020, 3, 10)),
  Country(
      'Montenegro',
      ({override = false}) async => await owidDataGetter('Montenegro', override),
      DateTime(2020, 3, 18)),
  Country(
      'Montserrat',
      ({override = false}) async => await owidDataGetter('Montserrat', override),
      DateTime(2020, 3, 21)),
  Country(
      'Mozambique',
      ({override = false}) async => await owidDataGetter('Mozambique', override),
      DateTime(2020, 3, 23)),
  Country(
      'Myanmar',
      ({override = false}) async => await owidDataGetter('Myanmar', override),
      DateTime(2020, 3, 17)),
  Country(
      'Namibia',
      ({override = false}) async => await owidDataGetter('Namibia', override),
      DateTime(2020, 3, 15)),
  Country('Nepal', ({override = false}) async => await owidDataGetter('Nepal', override),
      DateTime(2019, 12, 31)),
  Country(
      'Netherlands',
      ({override = false}) async => await owidDataGetter('Netherlands', override),
      DateTime(2019, 12, 31)),
  Country(
      'New Caledonia',
      ({override = false}) async => await owidDataGetter('New Caledonia', override),
      DateTime(2020, 3, 21)),
  Country(
      'New Zealand',
      ({override = false}) async => await owidDataGetter('New Zealand', override),
      DateTime(2019, 12, 31)),
  Country(
      'Nicaragua',
      ({override = false}) async => await owidDataGetter('Nicaragua', override),
      DateTime(2020, 3, 19)),
  Country('Niger', ({override = false}) async => await owidDataGetter('Niger', override),
      DateTime(2020, 3, 21)),
  Country(
      'Nigeria',
      ({override = false}) async => await owidDataGetter('Nigeria', override),
      DateTime(2019, 12, 31)),
  Country(
      'Northern Mariana Islands',
      ({override = false}) async =>
          await owidDataGetter('Northern Mariana Islands', override),
      DateTime(2020, 3, 31)),
  Country(
      'Norway',
      ({override = false}) async => await owidDataGetter('Norway', override),
      DateTime(2019, 12, 31)),
  Country('Oman', ({override = false}) async => await owidDataGetter('Oman', override),
      DateTime(2019, 12, 31)),
  Country(
      'Pakistan',
      ({override = false}) async => await owidDataGetter('Pakistan', override),
      DateTime(2019, 12, 31)),
  Country(
      'Palestine',
      ({override = false}) async => await owidDataGetter('Palestine', override),
      DateTime(2020, 3, 6)),
  Country(
      'Papua New Guinea',
      ({override = false}) async => await owidDataGetter('Papua New Guinea', override),
      DateTime(2020, 3, 21)),
  Country(
      'Philippines',
      ({override = false}) async => await owidDataGetter('Philippines', override),
      DateTime(2019, 12, 31)),
  Country(
      'Poland',
      ({override = false}) async => await owidDataGetter('Poland', override),
      DateTime(2020, 3, 4)),
  Country(
      'Puerto Rico',
      ({override = false}) async => await owidDataGetter('Puerto Rico', override),
      DateTime(2020, 3, 28)),
  Country('Qatar', ({override = false}) async => await owidDataGetter('Qatar', override),
      DateTime(2019, 12, 31)),
  Country(
      'Romania',
      ({override = false}) async => await owidDataGetter('Romania', override),
      DateTime(2019, 12, 31)),
  Country(
      'Russia',
      ({override = false}) async => await owidDataGetter('Russia', override),
      DateTime(2019, 12, 31)),
  Country(
      'Rwanda',
      ({override = false}) async => await owidDataGetter('Rwanda', override),
      DateTime(2020, 3, 15)),
  Country(
      'Saint Kitts and Nevis',
      ({override = false}) async =>
          await owidDataGetter('Saint Kitts and Nevis', override),
      DateTime(2020, 3, 26)),
  Country(
      'Saint Lucia',
      ({override = false}) async => await owidDataGetter('Saint Lucia', override),
      DateTime(2020, 3, 15)),
  Country(
      'Saint Vincent and the Grenadines',
      ({override = false}) async =>
          await owidDataGetter('Saint Vincent and the Grenadines', override),
      DateTime(2020, 3, 13)),
  Country(
      'San Marino',
      ({override = false}) async => await owidDataGetter('San Marino', override),
      DateTime(2019, 12, 31)),
  Country(
      'Sao Tome and Principe',
      ({override = false}) async =>
          await owidDataGetter('Sao Tome and Principe', override),
      DateTime(2020, 4, 9)),
  Country(
      'Saudi Arabia',
      ({override = false}) async => await owidDataGetter('Saudi Arabia', override),
      DateTime(2020, 3, 3)),
  Country(
      'Seychelles',
      ({override = false}) async => await owidDataGetter('Seychelles', override),
      DateTime(2020, 3, 15)),
  Country(
      'Sierra Leone',
      ({override = false}) async => await owidDataGetter('Sierra Leone', override),
      DateTime(2020, 4, 1)),
  Country(
      'Singapore',
      ({override = false}) async => await owidDataGetter('Singapore', override),
      DateTime(2019, 12, 31)),
  Country(
      'Sint Maarten (Dutch part)',
      ({override = false}) async =>
          await owidDataGetter('Sint Maarten (Dutch part)', override),
      DateTime(2020, 3, 3)),
  Country(
      'Slovakia',
      ({override = false}) async => await owidDataGetter('Slovakia', override),
      DateTime(2020, 3, 7)),
  Country(
      'Slovenia',
      ({override = false}) async => await owidDataGetter('Slovenia', override),
      DateTime(2020, 3, 5)),
  Country(
      'Somalia',
      ({override = false}) async => await owidDataGetter('Somalia', override),
      DateTime(2020, 3, 17)),
  Country(
      'South Korea',
      ({override = false}) async => await owidDataGetter('South Korea', override),
      DateTime(2019, 12, 31)),
  Country(
      'South Sudan',
      ({override = false}) async => await owidDataGetter('South Sudan', override),
      DateTime(2020, 4, 6)),
  Country('Spain', ({override = false}) async => await owidDataGetter('Spain', override),
      DateTime(2019, 12, 31)),
  Country(
      'Sri Lanka',
      ({override = false}) async => await owidDataGetter('Sri Lanka', override),
      DateTime(2019, 12, 31)),
  Country('Sudan', ({override = false}) async => await owidDataGetter('Sudan', override),
      DateTime(2020, 3, 14)),
  Country(
      'Suriname',
      ({override = false}) async => await owidDataGetter('Suriname', override),
      DateTime(2020, 3, 15)),
  Country(
      'Swaziland',
      ({override = false}) async => await owidDataGetter('Swaziland', override),
      DateTime(2020, 3, 15)),
  Country(
      'Sweden',
      ({override = false}) async => await owidDataGetter('Sweden', override),
      DateTime(2019, 12, 31)),
  Country(
      'Switzerland',
      ({override = false}) async => await owidDataGetter('Switzerland', override),
      DateTime(2019, 12, 31)),
  Country('Syria', ({override = false}) async => await owidDataGetter('Syria', override),
      DateTime(2020, 3, 23)),
  Country(
      'Taiwan',
      ({override = false}) async => await owidDataGetter('Taiwan', override),
      DateTime(2019, 12, 31)),
  Country(
      'Tajikistan',
      ({override = false}) async => await owidDataGetter('Tajikistan', override),
      DateTime(2020, 5, 1)),
  Country(
      'Tanzania',
      ({override = false}) async => await owidDataGetter('Tanzania', override),
      DateTime(2020, 3, 17)),
  Country(
      'Thailand',
      ({override = false}) async => await owidDataGetter('Thailand', override),
      DateTime(2019, 12, 31)),
  Country('Timor', ({override = false}) async => await owidDataGetter('Timor', override),
      DateTime(2020, 3, 22)),
  Country(
      'Trinidad and Tobago',
      ({override = false}) async => await owidDataGetter('Trinidad and Tobago', override),
      DateTime(2020, 3, 13)),
  Country(
      'Tunisia',
      ({override = false}) async => await owidDataGetter('Tunisia', override),
      DateTime(2020, 3, 3)),
  Country(
      'Turkey',
      ({override = false}) async => await owidDataGetter('Turkey', override),
      DateTime(2020, 3, 12)),
  Country(
      'Turks and Caicos Islands',
      ({override = false}) async =>
          await owidDataGetter('Turks and Caicos Islands', override),
      DateTime(2020, 3, 25)),
  Country(
      'Uganda',
      ({override = false}) async => await owidDataGetter('Uganda', override),
      DateTime(2020, 3, 22)),
  Country(
      'Ukraine',
      ({override = false}) async => await owidDataGetter('Ukraine', override),
      DateTime(2020, 3, 4)),
  Country(
      'United Arab Emirates',
      ({override = false}) async =>
          await owidDataGetter('United Arab Emirates', override),
      DateTime(2019, 12, 31)),
  Country(
      'United Kingdom',
      ({override = false}) async => await owidDataGetter('United Kingdom', override),
      DateTime(2019, 12, 31)),
  Country(
      'United States Virgin Islands',
      ({override = false}) async =>
          await owidDataGetter('United States Virgin Islands', override),
      DateTime(2020, 3, 24)),
  Country(
      'Uruguay',
      ({override = false}) async => await owidDataGetter('Uruguay', override),
      DateTime(2020, 3, 15)),
  Country(
      'Uzbekistan',
      ({override = false}) async => await owidDataGetter('Uzbekistan', override),
      DateTime(2020, 3, 16)),
  Country(
      'Vatican',
      ({override = false}) async => await owidDataGetter('Vatican', override),
      DateTime(2020, 3, 7)),
  Country(
      'Venezuela',
      ({override = false}) async => await owidDataGetter('Venezuela', override),
      DateTime(2020, 3, 15)),
  Country(
      'Vietnam',
      ({override = false}) async => await owidDataGetter('Vietnam', override),
      DateTime(2019, 12, 31)),
  Country(
      'Western Sahara',
      ({override = false}) async => await owidDataGetter('Western Sahara', override),
      DateTime(2020, 4, 26)),
  Country('Yemen', ({override = false}) async => await owidDataGetter('Yemen', override),
      DateTime(2020, 4, 10)),
  Country(
      'Zambia',
      ({override = false}) async => await owidDataGetter('Zambia', override),
      DateTime(2020, 3, 19)),
  Country(
      'Zimbabwe',
      ({override = false}) async => await owidDataGetter('Zimbabwe', override),
      DateTime(2020, 3, 21)),
];
