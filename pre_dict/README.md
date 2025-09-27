# Лабораторная работа по Функциональному программированию

**Выполнила Козырева Эмилия, ИСУ - 394031.**

[![CI Pipeline](https://github.com/Rrackoon/functional-programming-lab2/actions/workflows/ci.yml/badge.svg)](https://github.com/Rrackoon/functional-programming-lab2/actions/workflows/ci.yml)

---

## Требования к разработанному ПО

1. Реализовать абстрактный тип данных «словарь» (PreDict) с поддержкой:  
   - вставки пары ключ–значение;  
   - получения значения по ключу;  
   - удаления;  
   - объединения словарей;  
   - функций высшего порядка (map, filter, foldl, foldr).  

2. Обеспечить неизменяемость структуры (функциональный стиль).  

3. Добавить тесты, включая property-based тестирование.  

4. Настроить автоматическую проверку (GitHub Actions, CI/CD):  
   - форматирование кода;  
   - статический анализ (Credo);  
   - выполнение тестов.  
---
## Ключевые элементы реализации

Модуль *PreDict* содержит основные операции:  

```elixir
def put(%PreDict{root: root, size: size} = dict, key, value) do
  {new_root, added?} = Node.put(root, key, value)
  %PreDict{dict | root: new_root, size: if(added?, do: size + 1, else: size)}
end
```

`put/3` — вставка элемента
`get/3` — получение по ключу с дефолтом
`map/2`, `filter/2`, `foldl/3`, `foldr/3` — функции высшего порядка
`combine/2` — объединение двух словарей
`equal?/2` — проверка равенства словарей

---
## Тесты и CI
`Unit`- и `property-based` тесты: проверка вставки, удаления, поиска, свойств объединения словарей.

`CI Workflow` (.github/workflows/ci.yml) включает шаги:

1. `mix format --check-formatted` — контроль стиля;
2. `mix credo` — статический анализ;
2. `mix test` — выполнение тестов.


