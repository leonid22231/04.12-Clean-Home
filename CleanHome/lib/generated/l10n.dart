// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Управление городами`
  String get control_city {
    return Intl.message(
      'Управление городами',
      name: 'control_city',
      desc: '',
      args: [],
    );
  }

  /// `Поиск города...`
  String get search_city {
    return Intl.message(
      'Поиск города...',
      name: 'search_city',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка городов...`
  String get load_city {
    return Intl.message(
      'Загрузка городов...',
      name: 'load_city',
      desc: '',
      args: [],
    );
  }

  /// `Добавить город`
  String get add_city {
    return Intl.message(
      'Добавить город',
      name: 'add_city',
      desc: '',
      args: [],
    );
  }

  /// `Выйти`
  String get exit {
    return Intl.message(
      'Выйти',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Цена за комнату`
  String get price_room {
    return Intl.message(
      'Цена за комнату',
      name: 'price_room',
      desc: '',
      args: [],
    );
  }

  /// `Цена за ванну`
  String get price_wash {
    return Intl.message(
      'Цена за ванну',
      name: 'price_wash',
      desc: '',
      args: [],
    );
  }

  /// `Цена за квадратный метр`
  String get price_1m {
    return Intl.message(
      'Цена за квадратный метр',
      name: 'price_1m',
      desc: '',
      args: [],
    );
  }

  /// `Добавить`
  String get add {
    return Intl.message(
      'Добавить',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Имя`
  String get name {
    return Intl.message(
      'Имя',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Назначить менеджера`
  String get select_manager {
    return Intl.message(
      'Назначить менеджера',
      name: 'select_manager',
      desc: '',
      args: [],
    );
  }

  /// `Выберите пользователя`
  String get select_user {
    return Intl.message(
      'Выберите пользователя',
      name: 'select_user',
      desc: '',
      args: [],
    );
  }

  /// `Поиск по номеру`
  String get search_number {
    return Intl.message(
      'Поиск по номеру',
      name: 'search_number',
      desc: '',
      args: [],
    );
  }

  /// `Не найдено`
  String get not_found {
    return Intl.message(
      'Не найдено',
      name: 'not_found',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка...`
  String get loading {
    return Intl.message(
      'Загрузка...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Номер телефона`
  String get number_phone {
    return Intl.message(
      'Номер телефона',
      name: 'number_phone',
      desc: '',
      args: [],
    );
  }

  /// `Основная информация`
  String get main_info {
    return Intl.message(
      'Основная информация',
      name: 'main_info',
      desc: '',
      args: [],
    );
  }

  /// `Дополнительные опции`
  String get additional {
    return Intl.message(
      'Дополнительные опции',
      name: 'additional',
      desc: '',
      args: [],
    );
  }

  /// `Опций не найдено, создайте их в редакторе`
  String get option_not_found {
    return Intl.message(
      'Опций не найдено, создайте их в редакторе',
      name: 'option_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Настройки`
  String get settings {
    return Intl.message(
      'Настройки',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Менеджеры`
  String get managers {
    return Intl.message(
      'Менеджеры',
      name: 'managers',
      desc: '',
      args: [],
    );
  }

  /// `Новости`
  String get news {
    return Intl.message(
      'Новости',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Главная`
  String get main {
    return Intl.message(
      'Главная',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `Пользователи`
  String get users {
    return Intl.message(
      'Пользователи',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Добавить новую опцию`
  String get add_new_option {
    return Intl.message(
      'Добавить новую опцию',
      name: 'add_new_option',
      desc: '',
      args: [],
    );
  }

  /// `Введите данные для новой опции`
  String get add_new_option_info {
    return Intl.message(
      'Введите данные для новой опции',
      name: 'add_new_option_info',
      desc: '',
      args: [],
    );
  }

  /// `Описание*(по желанию)`
  String get op_not_required {
    return Intl.message(
      'Описание*(по желанию)',
      name: 'op_not_required',
      desc: '',
      args: [],
    );
  }

  /// `Цена`
  String get price {
    return Intl.message(
      'Цена',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Введите код`
  String get enter_code {
    return Intl.message(
      'Введите код',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста, введите код, отправленный на`
  String get enter_code_ {
    return Intl.message(
      'Пожалуйста, введите код, отправленный на',
      name: 'enter_code_',
      desc: '',
      args: [],
    );
  }

  /// `Активные заказы`
  String get active_orders {
    return Intl.message(
      'Активные заказы',
      name: 'active_orders',
      desc: '',
      args: [],
    );
  }

  /// `Доп. опции`
  String get additional_options {
    return Intl.message(
      'Доп. опции',
      name: 'additional_options',
      desc: '',
      args: [],
    );
  }

  /// `Опций не найдено, добавьте новые`
  String get op_not_found {
    return Intl.message(
      'Опций не найдено, добавьте новые',
      name: 'op_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить изменения`
  String get save_changes {
    return Intl.message(
      'Сохранить изменения',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `не найдены`
  String get not_founds {
    return Intl.message(
      'не найдены',
      name: 'not_founds',
      desc: '',
      args: [],
    );
  }

  /// `Клинеры`
  String get cleaners {
    return Intl.message(
      'Клинеры',
      name: 'cleaners',
      desc: '',
      args: [],
    );
  }

  /// `Заказы`
  String get orders {
    return Intl.message(
      'Заказы',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Уборка квартиры`
  String get apartaments_clean {
    return Intl.message(
      'Уборка квартиры',
      name: 'apartaments_clean',
      desc: '',
      args: [],
    );
  }

  /// `Заказов еще нет`
  String get orders_not_found {
    return Intl.message(
      'Заказов еще нет',
      name: 'orders_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Поиск заказов`
  String get search_orders {
    return Intl.message(
      'Поиск заказов',
      name: 'search_orders',
      desc: '',
      args: [],
    );
  }

  /// `Выберите город`
  String get enter_city {
    return Intl.message(
      'Выберите город',
      name: 'enter_city',
      desc: '',
      args: [],
    );
  }

  /// `Далее`
  String get next {
    return Intl.message(
      'Далее',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Отправить код`
  String get send_code {
    return Intl.message(
      'Отправить код',
      name: 'send_code',
      desc: '',
      args: [],
    );
  }

  /// `Пользователь`
  String get user {
    return Intl.message(
      'Пользователь',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Клинер`
  String get cleaner {
    return Intl.message(
      'Клинер',
      name: 'cleaner',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста, введите номер вашего мобильного телефона`
  String get enter_number_phone {
    return Intl.message(
      'Пожалуйста, введите номер вашего мобильного телефона',
      name: 'enter_number_phone',
      desc: '',
      args: [],
    );
  }

  /// `Я принимаю`
  String get confirm {
    return Intl.message(
      'Я принимаю',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `условия пользовательского соглашения`
  String get prefs {
    return Intl.message(
      'условия пользовательского соглашения',
      name: 'prefs',
      desc: '',
      args: [],
    );
  }

  /// `Выйти из аккаунта`
  String get logout {
    return Intl.message(
      'Выйти из аккаунта',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Удалить аккаунт`
  String get delete_account {
    return Intl.message(
      'Удалить аккаунт',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Стоимость уборки`
  String get price_clean {
    return Intl.message(
      'Стоимость уборки',
      name: 'price_clean',
      desc: '',
      args: [],
    );
  }

  /// `Общая стоимость`
  String get main_price {
    return Intl.message(
      'Общая стоимость',
      name: 'main_price',
      desc: '',
      args: [],
    );
  }

  /// `Закрыть`
  String get close {
    return Intl.message(
      'Закрыть',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Перенести`
  String get move {
    return Intl.message(
      'Перенести',
      name: 'move',
      desc: '',
      args: [],
    );
  }

  /// `Принять`
  String get confirm_ {
    return Intl.message(
      'Принять',
      name: 'confirm_',
      desc: '',
      args: [],
    );
  }

  /// `Приступить к работе`
  String get start_work {
    return Intl.message(
      'Приступить к работе',
      name: 'start_work',
      desc: '',
      args: [],
    );
  }

  /// `Закончить работу`
  String get end_work {
    return Intl.message(
      'Закончить работу',
      name: 'end_work',
      desc: '',
      args: [],
    );
  }

  /// `Отменить`
  String get cancel {
    return Intl.message(
      'Отменить',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Приветствую!`
  String get hello {
    return Intl.message(
      'Приветствую!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Нет активных заказов`
  String get active_orders_not_found {
    return Intl.message(
      'Нет активных заказов',
      name: 'active_orders_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Заказать уборку`
  String get start_order {
    return Intl.message(
      'Заказать уборку',
      name: 'start_order',
      desc: '',
      args: [],
    );
  }

  /// `Пришлем проверенного клинера и наведем порядок`
  String get lol {
    return Intl.message(
      'Пришлем проверенного клинера и наведем порядок',
      name: 'lol',
      desc: '',
      args: [],
    );
  }

  /// `Бонусы`
  String get bonus {
    return Intl.message(
      'Бонусы',
      name: 'bonus',
      desc: '',
      args: [],
    );
  }

  /// `Что входит в уборку`
  String get kek {
    return Intl.message(
      'Что входит в уборку',
      name: 'kek',
      desc: '',
      args: [],
    );
  }

  /// `Комнаты`
  String get rooms {
    return Intl.message(
      'Комнаты',
      name: 'rooms',
      desc: '',
      args: [],
    );
  }

  /// `Цена одной комнаты`
  String get price_one_room {
    return Intl.message(
      'Цена одной комнаты',
      name: 'price_one_room',
      desc: '',
      args: [],
    );
  }

  /// `Санузлы`
  String get kto {
    return Intl.message(
      'Санузлы',
      name: 'kto',
      desc: '',
      args: [],
    );
  }

  /// `Цена одного санусла`
  String get price_one_kto {
    return Intl.message(
      'Цена одного санусла',
      name: 'price_one_kto',
      desc: '',
      args: [],
    );
  }

  /// `Или`
  String get or {
    return Intl.message(
      'Или',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Цена одного кв. м`
  String get price_one_m {
    return Intl.message(
      'Цена одного кв. м',
      name: 'price_one_m',
      desc: '',
      args: [],
    );
  }

  /// `Размер`
  String get size {
    return Intl.message(
      'Размер',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Что еще нужно дополнительно ?`
  String get dop {
    return Intl.message(
      'Что еще нужно дополнительно ?',
      name: 'dop',
      desc: '',
      args: [],
    );
  }

  /// `Введите промокод`
  String get promo {
    return Intl.message(
      'Введите промокод',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `кв. м`
  String get kw_m {
    return Intl.message(
      'кв. м',
      name: 'kw_m',
      desc: '',
      args: [],
    );
  }

  /// `Итого`
  String get result {
    return Intl.message(
      'Итого',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Стоимость всей услуги`
  String get kto_price {
    return Intl.message(
      'Стоимость всей услуги',
      name: 'kto_price',
      desc: '',
      args: [],
    );
  }

  /// `Предложите свою цену`
  String get price_ {
    return Intl.message(
      'Предложите свою цену',
      name: 'price_',
      desc: '',
      args: [],
    );
  }

  /// `Ваш заказ`
  String get you_order {
    return Intl.message(
      'Ваш заказ',
      name: 'you_order',
      desc: '',
      args: [],
    );
  }

  /// `Оплата наличными`
  String get pay {
    return Intl.message(
      'Оплата наличными',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Итого к оплате`
  String get price_result {
    return Intl.message(
      'Итого к оплате',
      name: 'price_result',
      desc: '',
      args: [],
    );
  }

  /// `Ваша цена`
  String get you_price {
    return Intl.message(
      'Ваша цена',
      name: 'you_price',
      desc: '',
      args: [],
    );
  }

  /// `Основная уборка`
  String get main_clean {
    return Intl.message(
      'Основная уборка',
      name: 'main_clean',
      desc: '',
      args: [],
    );
  }

  /// `комната и`
  String get room_and {
    return Intl.message(
      'комната и',
      name: 'room_and',
      desc: '',
      args: [],
    );
  }

  /// `Дата и время`
  String get date_and_time {
    return Intl.message(
      'Дата и время',
      name: 'date_and_time',
      desc: '',
      args: [],
    );
  }

  /// `Выберите удобную дату и время`
  String get select_date_and_time {
    return Intl.message(
      'Выберите удобную дату и время',
      name: 'select_date_and_time',
      desc: '',
      args: [],
    );
  }

  /// `Готово`
  String get l {
    return Intl.message(
      'Готово',
      name: 'l',
      desc: '',
      args: [],
    );
  }

  /// `Добавить новый адрес`
  String get add_address {
    return Intl.message(
      'Добавить новый адрес',
      name: 'add_address',
      desc: '',
      args: [],
    );
  }

  /// `Улица`
  String get street {
    return Intl.message(
      'Улица',
      name: 'street',
      desc: '',
      args: [],
    );
  }

  /// `Дом`
  String get house {
    return Intl.message(
      'Дом',
      name: 'house',
      desc: '',
      args: [],
    );
  }

  /// `Строение`
  String get str {
    return Intl.message(
      'Строение',
      name: 'str',
      desc: '',
      args: [],
    );
  }

  /// `Подъезд`
  String get pod {
    return Intl.message(
      'Подъезд',
      name: 'pod',
      desc: '',
      args: [],
    );
  }

  /// `Квартира`
  String get kw {
    return Intl.message(
      'Квартира',
      name: 'kw',
      desc: '',
      args: [],
    );
  }

  /// `Домофон`
  String get dom {
    return Intl.message(
      'Домофон',
      name: 'dom',
      desc: '',
      args: [],
    );
  }

  /// `Этаж`
  String get et {
    return Intl.message(
      'Этаж',
      name: 'et',
      desc: '',
      args: [],
    );
  }

  /// `Добавить адрес`
  String get add_address_ {
    return Intl.message(
      'Добавить адрес',
      name: 'add_address_',
      desc: '',
      args: [],
    );
  }

  /// `Выберите адрес`
  String get select_address {
    return Intl.message(
      'Выберите адрес',
      name: 'select_address',
      desc: '',
      args: [],
    );
  }

  /// `Адресов не найдено`
  String get address_not_found {
    return Intl.message(
      'Адресов не найдено',
      name: 'address_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Поиск клинера`
  String get w_1 {
    return Intl.message(
      'Поиск клинера',
      name: 'w_1',
      desc: '',
      args: [],
    );
  }

  /// `Клинер назначен`
  String get w_2 {
    return Intl.message(
      'Клинер назначен',
      name: 'w_2',
      desc: '',
      args: [],
    );
  }

  /// `Уборка начата`
  String get w_3 {
    return Intl.message(
      'Уборка начата',
      name: 'w_3',
      desc: '',
      args: [],
    );
  }

  /// `Уборка закончена`
  String get w_4 {
    return Intl.message(
      'Уборка закончена',
      name: 'w_4',
      desc: '',
      args: [],
    );
  }

  /// `Уборка отменена`
  String get w_5 {
    return Intl.message(
      'Уборка отменена',
      name: 'w_5',
      desc: '',
      args: [],
    );
  }

  /// `Статус не найден`
  String get w_6 {
    return Intl.message(
      'Статус не найден',
      name: 'w_6',
      desc: '',
      args: [],
    );
  }

  /// `Закажите уборку`
  String get w_8 {
    return Intl.message(
      'Закажите уборку',
      name: 'w_8',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
