#include <stdio.h>
#include <locale.h>
#include <libintl.h>

#define _(String) gettext(String)

int main() {
    setlocale(LC_ALL, "");  // Инициализация локали для перевода
    bindtextdomain("guess", "./locale");  // Указываем путь к файлам перевода
    textdomain("guess");

    int low = 1, high = 100;
    char answer[10];
    
    printf(_("Загадайте число от 1 до 100 и не говорите его!\n"));

    while (low <= high) {
        int mid = (low + high) / 2;
        
        printf(_("Число больше %d? (да/нет): "), mid);
        if (scanf("%s", answer) != 1) {
            printf(_("Ошибка ввода! Попробуйте снова.\n"));
            continue;
        }

        if (answer[0] == 'д' || answer[0] == 'Д') {
            low = mid + 1;
        } else if (answer[0] == 'н' || answer[0] == 'Н') {
            high = mid - 1;
        } else {
            printf(_("Ошибка ввода! Пожалуйста, ответьте 'да' или 'нет'.\n"));
            continue;
        }
    }

    printf(_("Ваше число — это %d!\n"), low);

    return 0;
}
