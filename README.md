# Моделирование данных в Хранилище (с использованием Data Vault и dbt)

## Цели задания:

- Моделирование данных в Data Warehouse: нормализация, обогащение, интеграция, единая логическая модель, витрины данных и расчет метрик
- Развертывание окружения: СУБД + dbt
- Конфигурация проекта dbt, установка модуля dbtVault
- Проектирование детального слоя на базе подхода Data Vault, подготовка метаданных для кодогенерации
- Автоматизация наполнения детального слоя данных с помощью dbt + dbtVault
- Формирование витрин данных на основе детального слоя

## Ход выполнения:

1. Развертывание окружения: СУБД + dbt
 - Берем за основу репозиторий https://github.com/kzzzr/jaffle_shop_dbtvault 
 - Устонавливаем СУБД Postgres (Docker)
 - Устанавливаем утилиту CLI dbt
2. Установка модуля dbtVault
3. Проектирование детального слоя на базе Data Vault.
  - настройка конфигураций /dbt_project.yml
  - загрузка исходных данных ./data/ в формате .csv
  - настройка конфигурации dbt sources в models/schema.yml
4. Наполнение данных
  - Загрузка .csv из репо в таблицы исходных данных 
  ~~~
  dbt seed
  ~~~
  - Формирование слоя staging:
  ~~~
  dbt run -m tag:stage
  ~~~
  -  Формирование слоя Data Vault:
  ~~~
  dbt run -m tag:raw_vault
  ~~~  
  
5. Инициация изменений в исходных данных:
  ~~~
  dbt seed —-full-refresh
  dbt run -m tag:stage
  dbt run -m tag:raw_vault
  ~~~  
  
 6. Создание витрины данных над Data Vault

**Динамика изменения количества заказов в разрезе календарной недели и статуса заказа**

![orders_per_week](https://github.com/FaradG11/Otus_DE-jaffle_shop_dbtvault/blob/16f03982ad99d5afde8cff1f61b838979cb6a540/screenshots/orders_per_week.png)

**Представление Point-in-time, которое показывает актуальные атрибуты клиента (first name, last name, email) на заданный момент времени**
 
![PIT_customers](https://github.com/FaradG11/Otus_DE-jaffle_shop_dbtvault/blob/16f03982ad99d5afde8cff1f61b838979cb6a540/screenshots/PIT_after_new_source_adding.png)

