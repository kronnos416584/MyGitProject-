#!/bin/sh

# Проверка на наличие необязательного параметра (время задержки)
if [ -n "$1" ]; then
    delay=$1
else
    delay=0.1  # если параметр не передан, по умолчанию задержка 0.1 секунда
fi

# Чтение входных данных (ASCII-графика)
input=$(cat)

# Подсчет количества строк и максимальной длины строки
lines=$(echo "$input" | wc -l)
max_width=$(echo "$input" | awk '{ print length }' | sort -n | tail -n 1)

# Получение размеров терминала
terminal_height=$(stty size < /dev/tty | cut -d' ' -f1)
terminal_width=$(stty size < /dev/tty | cut -d' ' -f2)

# Вычисление позиции для центрирования
offset_x=$(( (terminal_width - max_width - 2) / 2 ))  # Минус 2 для рамки
offset_y=$(( (terminal_height - lines - 2) / 2 ))  # Минус 2 для рамки

# Очистка экрана и перемещение курсора в начало
clear

# Скрыть курсор
tput civis

# Перемещение курсора в начало и центрирование
tput cup $offset_y $offset_x

# Рисование рамки
for (( i=0; i<max_width+2; i++ )); do
    tput cup $offset_y $((offset_x + i))
    echo -n "─"
done
for (( i=0; i<lines; i++ )); do
    tput cup $((offset_y + i + 1)) $offset_x
    echo -n "│"
    tput cup $((offset_y + i + 1)) $((offset_x + max_width + 1))
    echo -n "│"
done
for (( i=0; i<max_width+2; i++ )); do
    tput cup $((offset_y + lines + 1)) $((offset_x + i))
    echo -n "─"
done

# Преобразование ASCII-графики в массив символов с позициями
positions=$(echo "$input" | awk -v delay="$delay" '{
    for (i = 1; i <= length($0); i++) {
        print i-1 " " NR-1 " " substr($0, i, 1)
    }
}' | shuf)

# Функция для генерации случайного цвета
random_color() {
    # Генерация случайного цвета от 31 до 37 (стандартные цвета)
    echo $((31 + RANDOM % 7))
}

# Вывод символов в случайном порядке с задержкой
echo "$positions" | while read col row char; do
    # Генерация случайного цвета
    color=$(random_color)

    # Установка цвета и вывод символа
    tput setaf $color
    tput cup $((offset_y + row + 1)) $((offset_x + col + 1))  # Смещение на 1 для рамки
    echo -n "$char"
    
    # Задержка
    sleep "$delay"
done

# Показать курсор снова
tput cnorm

# Вернуть курсор в конец
tput cup $((terminal_height - 1)) 0

# Конец скрипта

