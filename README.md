# weather-api-load-test

## Профиль нагрузки

- `GET  http://91.185.85.213/Cities`          - 47,5% всех запросов
- `GET  http://91.185.85.213/Forecast`        - 47,5% всех запросов
- `POST http://91.185.85.213/Forecast/1`      - 2,5%  всех запросов
- `GET  http://91.185.85.213/WeatherForecast` - 2,5%  всех запросов

## Нефункциональные требования по производительности сервиса weather-api

1. Количество запросов в секунду:

   1. В обычном режиме - 75 RPS.
   2. В периоды пиковой нагрузки - 125 RPS.

2. Какое допустимое время ответа сервера:

    1. В обычном режиме:
        - 50% запросов: <= 10ms.
        - 90% запросов: <= 200ms.
        - 95% запросов: <= 400ms.

    2. В периоды пиковой нагрузки.
        - 50% запросов: <= 50ms.
        - 90% запросов: <= 500ms.
        - 95% запросов: <= 1000ms.

3. Количество городов в БД - не менее 75.
4. Количество запросов на добавление погоды не менее 2% всех запросов.
5. Количество запросов погоды для всех городов (WeatherForecast) не менее 2%.

## Инструмент нагрузочного тестирования

В качестве инструмента нагрузочного тестирования была выбрана утилита vegeta.
Подготовлен скрипт peak.sh для имитации нагрузки на систему в обычном режиме с кратковременным всплеском нагрузки до пикового состояния. 

Последовательность стресс-теста:
   - прогрев: 5 RPS на 5 секунд;
   - обычный режим: 75 RPS на 300 секунд;
   - пиковый режим: 125 RPS на 60 секунд;
   - обычный режим: 75 RPS на 300 секунд;

** В идеале, для получения более точных результатов теста следует запускать тест на 1-2 часа. 

## Максимальная производительность системы 

Определение проводилось скриптом loader.sh и утилитой vegeta.

Выполнялась последовательная нагрузка в диапазоне от 25 RPS до 150 RPS с шагом 25 RPS. Длина итерации - 120 секунд.
Выяснил, что система остается работоспособной при 125 RPS при кратковременной нагрузке в течение 60 секунд.
При 150 RPS уже появляются ошибки, система работает нестабильно.

## Выводы

Судя по дашборду из node-exporter, хост с postgresql упирается в RAM и CPU на хостах с БД. Видно даже что он начинает свопить.  
![Alt text](<cpu-mem-swap.png>)

Также, видно что система очень близка к своим предельным значениям CPU для weather-api в k8s.  
![Alt text](<k8s-api-cpu.png>)

Пример графика по определению максимального значения RPS:  
![Alt text](<max_rps.png>)

Задержки:  
![Alt text](<latencies.png>)