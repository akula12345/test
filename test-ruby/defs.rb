### ДОДАТИ ВИТРАТУ
def addCost
    puts("Додати витрату за...?\n[1]Сьогодні - #{Date.today}\n[2]Вчора - #{Date.today - 1}\n[3]Вільна дата...\n\nОберіть пункт меню")
    c = gets.chomp
    cost = []
    case c
        when "1"
            cost[0] = Date.today
            puts("Оберіть категорію:\n\n")
            $category.each_with_index do |i, index|
                puts("[#{index + 1}] #{i[i]}")
            end
            category = gets.chomp
            if category.to_i <= $category.length && category.to_i != 0
                cost[1] = $category[category.to_i - 1]
                puts("Введіть суму витрати: ")
                sum = gets.chomp
                if sum.to_i != 0
                    cost[2] = sum.to_i

                    db = SQLite3::Database.new "Costs.db"

                    db.execute("INSERT INTO costs (login, category, cost, dateOfCost)
                    VALUES (?, ?, ?, ?)", [$user, cost[1], cost[2], cost[0].to_s])

                    # db.execute( "select * from costs" ) do |row| 
                    #     p row
                    # end

                    puts("Витрата була додана!")
                    menu
                else
                    puts("Невірне число!")
                    addCost
                end
            else
                puts("Невірна категорія!")
                addCost
            end
        when "2"
            cost[0] = Date.today - 1
            puts("Оберіть категорію:\n\n")
            $category.each_with_index do |i, index|
                puts("[#{index + 1}] #{i[i]}")
            end
            category = gets.chomp
            if category.to_i <= $category.length && category.to_i != 0
                cost[1] = $category[category.to_i - 1]
                puts("Введіть суму витрати: ")
                sum = gets.chomp
                if sum.to_i != 0
                    cost[2] = sum.to_i

                    db = SQLite3::Database.new "Costs.db"

                    db.execute("INSERT INTO costs (login, category, cost, dateOfCost)
                    VALUES (?, ?, ?, ?)", [$user, cost[1], cost[2], cost[0].to_s])

                    # db.execute( "select * from costs" ) do |row| 
                    #     p row
                    # end

                    puts("Витрата була додана!")
                    menu
                else
                    puts("Невірне число!")
                    addCost
                end
            else
                puts("Невірна категорія!")
                addCost
            end
        when "3"
            puts("Введіть дату:\nНаприклад: 12.12.2012")
            d = gets.chomp
            puts(d)
            begin
                cost[0] = Date.parse(d)
                puts("Оберіть категорію:\n\n")
                $category.each_with_index do |i, index|
                    puts("[#{index}] #{i[i]}")
                end
                category = gets.chomp
                if category.to_i <= $category.length
                    cost[1] = $category[category.to_i]
                    puts("Введіть суму витрати: ")
                    sum = gets.chomp
                    if sum.to_i != 0
                        cost[2] = sum.to_i
    
                        db = SQLite3::Database.new "Costs.db"
    
                        db.execute("INSERT INTO costs (login, category, cost, dateOfCost)
                        VALUES (?, ?, ?, ?)", [$user, cost[1], cost[2], cost[0].to_s])
    
                        # db.execute( "select * from costs" ) do |row| 
                        #     p row
                        # end
    
                        puts("Витрата була додана!")
                        menu
                    else
                        puts("Невірне число!")
                        addCost
                    end
                else
                    puts("Невірна категорія!")
                    addCost
                end
            rescue ArgumentError
                puts("Невірно!")
                addCost
            end

    end
end

###ПОДИВИТИСЬ СТАТИСТИКУ ВИТРАТ
def showStat
    puts("Подивитися статистику витрат\n\n[1]Всі категорії\n[2]Обрати категорію")
    c = gets.chomp
    stat = []
    case c
        when "1"
            puts("За який час ви хочете бачити статистику?\n\n[1]За день\n[2]За місяць\n[3]За рік")
            t = gets.chomp
            if t == "1"
                db = SQLite3::Database.new "Costs.db"
                sum = 0
                db.execute( "SELECT * FROM costs WHERE dateOfCost = ? AND login = ?", [Date.today.to_s, $user] ) do |row| 
                    puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                    sum += row[2].to_i
                end
                puts("\n| За сьогодні ви витратили - #{sum} UAH |")
            elsif t == "2"
                db = SQLite3::Database.new "Costs.db"
                sum = 0
                db.execute( "SELECT * FROM costs WHERE dateOfCost BETWEEN ? AND ? AND login = ?", [(Date.today - Date.today.mday).to_s, Date.today.to_s, $user] ) do |row| 
                    puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                    sum += row[2].to_i
                end
                puts("\n| За місяць ви витратили - #{sum} UAH |")
            elsif t == "3"
                db = SQLite3::Database.new "Costs.db"
                sum = 0
                db.execute( "SELECT * FROM costs WHERE dateOfCost BETWEEN ? AND ? AND login = ?", [(Date.today - Date.today.yday).to_s, Date.today.to_s, $user] ) do |row| 
                    puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                    sum += row[2].to_i
                end
                puts("\n| За рік ви витратили - #{sum} UAH |")
            else
                puts("Невірний пункт меню!")
            end
        when "2"
            puts("Оберіть категорію:\n\n")
            $category.each_with_index do |i, index|
                puts("[#{index + 1}] #{i[i]}")
            end
            category = gets.chomp
            if category.to_i <= $category.length && category.to_i != 0
                stat[0] = $category[category.to_i]
                
                puts("За який час ви хочете бачити статистику?\n\n[1]За день\n[2]За місяць\n[3]За рік")
                t = gets.chomp
                if t == "1"
                    db = SQLite3::Database.new "Costs.db"
                    sum = 0
                    db.execute( "SELECT * FROM costs WHERE dateOfCost = ? AND login = ? AND category = ?", [Date.today.to_s, $user, $category[category.to_i - 1]] ) do |row| 
                        puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                        sum += row[2].to_i
                    end
                    puts("\n| За сьогодні ви витратили - #{sum} UAH |")
                elsif t == "2"
                    db = SQLite3::Database.new "Costs.db"
                    sum = 0
                    db.execute( "SELECT * FROM costs WHERE dateOfCost BETWEEN ? AND ? AND login = ? AND category = ?", [(Date.today - Date.today.mday).to_s, Date.today.to_s, $user, $category[category.to_i - 1]] ) do |row| 
                        puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                        sum += row[2].to_i
                    end
                    puts("\n| За місяць ви витратили - #{sum} UAH |")
                elsif t == "3"
                    db = SQLite3::Database.new "Costs.db"
                    sum = 0
                    db.execute( "SELECT * FROM costs WHERE dateOfCost BETWEEN ? AND ? AND login = ? AND category = ?", [(Date.today - Date.today.yday).to_s, Date.today.to_s, $user, $category[category.to_i - 1]] ) do |row| 
                        puts("|#{row[3]}| #{row[1]} | -#{row[2]} UAH")
                        sum += row[2].to_i
                    end
                    puts("\n| За рік ви витратили - #{sum} UAH |")
                else
                    puts("Невірний пункт меню!")
                end

            else
                puts("Невірний пункт меню!")
            end      
        else
            puts("Невірний пункт меню!")
            showStat
    end
    menu
end

### ОЧИСТИТИ ДАНІ КОРИСТУВАЧА
def clearDB
    db = SQLite3::Database.new "Costs.db"
    db.execute( "DELETE FROM costs WHERE login = ?", [$user] )
    puts("Ваші дані були видалені")
    menu
end