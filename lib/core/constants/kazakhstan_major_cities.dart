// Крупные города Казахстана — единый справочник для вакансий, фильтров и резюме.

/// Подпись фильтра «показать все города».
const String kKazakhstanAllCitiesLabel = 'Все города';

/// Крупные города (единые подписи для Firestore [location] и UI).
const List<String> kKazakhstanMajorCities = [
  'Алматы',
  'Астана',
  'Шымкент',
  'Караганда',
  'Актобе',
  'Тараз',
  'Павлодар',
  'Усть-Каменогорск',
  'Семей',
  'Атырау',
  'Кызылорда',
  'Костанай',
  'Уральск',
  'Петропавловск',
  'Актау',
  'Темиртау',
  'Туркестан',
  'Кокшетау',
  'Талдыкорган',
  'Экибастуз',
];

/// Горизонтальный фильтр на главной: «Все города» + крупные города (один список на процесс).
final List<String> kKazakhstanCityFilterChips = [
  kKazakhstanAllCitiesLabel,
  ...kKazakhstanMajorCities,
];

bool kKazakhstanCityMatchesFilter(String vacancyLocation, String selected) {
  if (selected == kKazakhstanAllCitiesLabel) return true;
  return vacancyLocation.trim() == selected;
}
