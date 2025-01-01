#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

from playwright.sync_api import sync_playwright
import os
import sys

def type_os():
    package_manager = str(input("Введите тип дистрибутива Linux (deb/rpm): ")).strip().lower()  # Очистка и приведение к нижнему регистру
    if package_manager not in ["deb", "rpm"]:
        print("Ошибка: введено некорректное значение. Пожалуйста, введите 'deb' или 'rpm'.")
        sys.exit(1)  # Завершаем выполнение скрипта, если введено некорректное значение
    return package_manager

def run_playwright(package_manager):
    with sync_playwright() as p:
        # Получаем путь к корню проекта
        download_path = os.path.join(os.getcwd(), 'downloads')  # Путь для скачиваний
        
        # Убеждаемся, что папка существует
        os.makedirs(download_path, exist_ok=True)
        
        # Запуск браузера Firefox с созданием контекста
        browser = p.firefox.launch()
        context = browser.new_context(accept_downloads=True)  # Указываем только accept_downloads
        page = context.new_page()
        
        # Открыть сайт
        page.goto('https://communigatepro.ru')
        
        # Нажать на первую кнопку
        page.click('div.menu-open:nth-child(6) > div:nth-child(1) > a:nth-child(1)')
        
        try:
            # Ждать появления блока после первого клика 3 секунды
            page.wait_for_selector('.tn-elem__7428234401714102568894 > div:nth-child(1)', timeout=3000)
        except:
            # Если блок не появился, нажать вторую кнопку
            print("Первый блок не появился, нажимаем вторую кнопку.")
            page.click('.tn-elem__7947786241713744839614 > a:nth-child(1)')
            
            try:
                # Ждать появления блока после второго клика 3 секунды
                page.wait_for_selector('.tn-elem__7428234401714102568894 > div:nth-child(1)', timeout=3000)
            except:
                # Если блок не появился после второго клика, завершаем скрипт
                print("Ошибка: парсер не дождался появления окна загрузки.")
                # Закрыть контекст и браузер
                context.close()
                browser.close()
                sys.exit(1)  # Завершаем выполнение скрипта, так как окно загрузки не появилось
        
        # Нажать на кнопку для скачивания и ждать загрузки файла
        with page.expect_download(timeout=10000) as download_info:
            if package_manager == "deb":
                page.click('.tn-elem__7428234401714102916133 > a:nth-child(1)')
            elif package_manager == "rpm":
                page.click('.tn-elem__7428234401714102984618 > a:nth-child(1)')
        
        # Получить информацию о загруженном файле
        download = download_info.value
        print(f'Файл загружен: {download.path}')
        
        # Переместить файл в нужную директорию
        download_path_full = os.path.join(download_path, download.suggested_filename)
        download.save_as(download_path_full)
        print(f'Файл сохранён в: {download_path_full}')
        
        # Закрыть контекст и браузер
        context.close()
        browser.close()

def main():
    package_manager = type_os()  # Получаем значение package_manager из type_os()
    run_playwright(package_manager)  # Передаём package_manager в run_playwright

if __name__ == "__main__":
    main()
