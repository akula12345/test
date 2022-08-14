require "date"
require "sqlite3"
require_relative "menu"

db = SQLite3::Database.new "Costs.db"

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS  users (
    login TEXT,
    pass TEXT
  );
SQL

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS  costs (
    login TEXT,
    category TEXT,
    cost INT,
    dateOfCost DATE
  );
SQL

$user = ""

$category = ["Продукти", "Розваги", "Медицина", "Подорожі", "Комуналка", "Одяг", "Інше"]

def singUp
    puts("Реєстрація~")
    puts("Введіть логін:")
    l = gets.chomp
    db = SQLite3::Database.new "Costs.db"
    n = db.execute( "SELECT * FROM users WHERE login = ?", [l] )

    if l == "auth"
        signIn
    end
    case n.length
        when 0
            puts("Введіть пароль:")
            p = gets.chomp
            db.execute("INSERT INTO users (login, pass)
            VALUES (?, ?)", [l, p])
            puts("Ви успішно пройшли реєстрацію!")

            # db.execute( "select * from users" ) do |row| 
            #     p row
            # end
            $user = l
            menu
        else
            puts("Такий користувач вже існує\nВведіть 'auth', щоб зареєструватися.")
            singUp
    end
end

def signIn
    puts("Авторизація~")
    puts("Введіть логін:")
    l = gets.chomp
    db = SQLite3::Database.new "Costs.db"
    n = db.execute( "SELECT * FROM users WHERE login = ?", [l] )

    if l == "reg"
        singUp
    end
    case n.length
        when 0
            puts("Такого користувача не існує\nВведіть 'reg', щоб зареєструватися.")
            signIn
        else
            puts("Введіть пароль:")
            p = gets.chomp
            r = db.execute( "SELECT * FROM users WHERE login = ? AND pass = ?", [l, p] )
            case r.length
                when 0
                    puts("Невірний пароль!")
                    signIn
                else
                    $user = l
                    menu
            end
    end
end

def main
    t = Time.now.strftime("%H:00").to_i
    case t
        when 5..12
            puts("""
                ┌───── •✧✧• ─────┐
                   -Доброго дня- 
                └───── •✧✧• ─────┘
                """)
        else
            puts("""
                ┊┊┊┊
                ┊┊┊☆
                ┊┊🌙 *
                ┊┊
                ┊☆ °
                🌙*
                Добрий вечір!
                """)
    end
    puts("""
        Увійти/зареєструватися?

        [1]Увійти
        [2]Зареєструватися

        Оберіть пункт меню
        """)
    c = gets.chomp
    if c == "1"
        signIn
    elsif c == "2"
        singUp
    else
        puts("Невірний пункт меню!")
    end
end

main