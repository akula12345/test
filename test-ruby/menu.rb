require_relative "defs"

def menu
    puts("""
        Я - ВАШ ПОМІЧНИК З ВИТРАТ! <3

        [1]Додати витрату
        [2]Отримати статистику
        [3]Видалити дані

        Оберіть пункт меню
        """)
    m = gets.chomp
    case m
    when "1"
        addCost
    when "2"
        showStat
    when "3"
        clearDB
    else
        puts("Невірний пункт меню!")
        menu
    end
end